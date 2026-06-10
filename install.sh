#!/usr/bin/env bash
#
# install.sh — agentic-ocean corpus installer (symlink farm, ADR-002)
#
# Reads installer.yaml and symlinks each source's corpus/<kind>/<entry> into the
# editor target dir named by the mapping. Symlink mode (C-INST-1 GO). Per-item links
# so multiple sources can populate the same target dir. Idempotent; collision = error
# (unless --force).
#
#   install.sh [--uninstall] [--dry-run] [--force] [--verbose]
#
#     --uninstall   remove installer-created symlinks (corpus untouched)
#     --dry-run     print actions without changing the filesystem
#     --force       replace a conflicting target (real file / foreign symlink)
#     --verbose     report skipped/unchanged entries too
#
# Config lookup: $AGENTIC_OCEAN_CONFIG, else $XDG_CONFIG_HOME/agentic-ocean/installer.yaml,
# else ~/.config/agentic-ocean/installer.yaml.
#
# Schema: docs/installer-schema.md. (Scope: Group 4 / Tasks 11–13. The core→personal
# check arrives in Task 14.)

set -euo pipefail

err()  { printf 'error: %s\n' "$*" >&2; exit 1; }
log()  { printf '%s\n' "$*"; }
vlog() { if [ "$VERBOSE" -eq 1 ]; then printf '%s\n' "$*"; fi; }

usage() { sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'; }

expand_tilde() {
  case "$1" in
    "~")    printf '%s\n' "$HOME" ;;
    "~/"*)  printf '%s\n' "$HOME/${1#\~/}" ;;
    *)      printf '%s\n' "$1" ;;
  esac
}

# --- args ------------------------------------------------------------------
mode="install"; DRY_RUN=0; FORCE=0; VERBOSE=0
while [ $# -gt 0 ]; do
  case "$1" in
    --uninstall)   mode="uninstall" ;;
    --dry-run)     DRY_RUN=1 ;;
    --force)       FORCE=1 ;;
    --verbose|-v)  VERBOSE=1 ;;
    -h|--help)     usage; exit 0 ;;
    *)             err "unknown argument: $1 (see --help)" ;;
  esac
  shift
done

# --- prerequisites ---------------------------------------------------------
command -v yq >/dev/null 2>&1 || \
  err "yq is required (https://github.com/mikefarah/yq) — install with: brew install yq"

config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
config_file="${AGENTIC_OCEAN_CONFIG:-$config_home/agentic-ocean/installer.yaml}"
[ -f "$config_file" ] || \
  err "config not found: $config_file (copy installer.example.yaml there and adjust paths)"

n_changed=0

# Iterate every (link, entry, target) the mapping defines, calling: <handler> link entry target
for_each_link() {
  local handler="$1"
  local src_count i name root kind target srcdir entry link
  src_count="$(yq '.sources | length' "$config_file")"
  [ "$src_count" -gt 0 ] 2>/dev/null || err "no sources defined in $config_file"
  for i in $(seq 0 "$((src_count - 1))"); do
    name="$(yq ".sources[$i].name" "$config_file")"
    root="$(expand_tilde "$(yq ".sources[$i].root" "$config_file")")"
    [ -d "$root" ] || err "source '$name': root not found: $root"
    for kind in $(yq ".sources[$i].links | keys | .[]" "$config_file"); do
      target="$(expand_tilde "$(yq ".sources[$i].links.$kind" "$config_file")")"
      srcdir="$root/$kind"
      [ -d "$srcdir" ] || continue
      for entry in "$srcdir"/*; do
        [ -e "$entry" ] || continue
        link="$target/$(basename "$entry")"
        "$handler" "$link" "$entry" "$target"
      done
    done
  done
}

install_one() {
  local link="$1" entry="$2" target="$3"
  [ "$DRY_RUN" -eq 1 ] || mkdir -p "$target"

  if [ -L "$link" ] && [ "$(readlink "$link")" = "$entry" ]; then
    vlog "skip (already linked): $link"
    return 0
  fi

  if [ -L "$link" ] || [ -e "$link" ]; then
    # something is in the way
    if [ "$FORCE" -ne 1 ]; then
      err "collision: $link exists and is not our link — use --force to replace"
    fi
    if [ "$DRY_RUN" -eq 1 ]; then
      log "would replace: $link -> $entry"; n_changed=$((n_changed + 1)); return 0
    fi
    rm -rf "$link"
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    log "would link: $link -> $entry"
  else
    ln -s "$entry" "$link"
    log "linked: $link -> $entry"
  fi
  n_changed=$((n_changed + 1))
}

# Remove a link only if it is OUR symlink (points at the corpus entry).
uninstall_one() {
  local link="$1" entry="$2"
  if [ -L "$link" ] && [ "$(readlink "$link")" = "$entry" ]; then
    if [ "$DRY_RUN" -eq 1 ]; then
      log "would unlink: $link"
    else
      rm "$link"; log "unlinked: $link"
    fi
    n_changed=$((n_changed + 1))
  else
    vlog "skip (not our link): $link"
  fi
}

# --- main ------------------------------------------------------------------
if [ "$DRY_RUN" -eq 1 ]; then log "(dry-run — no changes will be made)"; fi

if [ "$mode" = "install" ]; then
  for_each_link install_one
  if [ "$DRY_RUN" -eq 1 ]; then
    log "install dry-run complete ($n_changed link(s) would change)"
  else
    log "install complete ($n_changed new link(s))"
  fi
else
  for_each_link uninstall_one
  if [ "$DRY_RUN" -eq 1 ]; then
    log "uninstall dry-run complete ($n_changed link(s) would be removed)"
  else
    log "uninstall complete ($n_changed link(s) removed)"
  fi
fi

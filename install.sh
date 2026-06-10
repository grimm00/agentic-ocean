#!/usr/bin/env bash
#
# install.sh — agentic-ocean corpus installer (symlink farm, ADR-002)
#
# Reads installer.yaml and symlinks each source's corpus/<kind>/<entry> into the
# editor target dir named by the mapping. Symlink mode (C-INST-1 GO). Per-item links
# so multiple sources can populate the same target dir. Idempotent.
#
# Additive by default (feature ADR-002): ~/.cursor/ is always a managed/shared space, so
# a foreign target is never clobbered. On collision the installer compares contents —
# identical => skip silently; differs => skip and warn — then keeps going. --force
# replaces; --strict errors on a divergent collision.
#
#   install.sh [--uninstall] [--dry-run] [--force] [--strict] [--verbose]
#
#     --uninstall   remove installer-created symlinks (corpus untouched)
#     --dry-run     print actions without changing the filesystem
#     --force       replace a conflicting target (real file / foreign symlink) — destructive
#     --strict      error on a divergent collision instead of skipping
#     --verbose     report skipped/unchanged entries too
#
# Config lookup: $AGENTIC_OCEAN_CONFIG, else $XDG_CONFIG_HOME/agentic-ocean/installer.yaml,
# else ~/.config/agentic-ocean/installer.yaml.
#
# Schema: docs/installer-schema.md.

set -euo pipefail

err()  { printf 'error: %s\n' "$*" >&2; exit 1; }
warn() { printf 'warning: %s\n' "$*" >&2; }
log()  { printf '%s\n' "$*"; }
vlog() { if [ "$VERBOSE" -eq 1 ]; then printf '%s\n' "$*"; fi; }

# Help text lives here (not parsed out of the header) so editing the top-of-file
# comment can never desync --help.
usage() {
  cat <<'EOF'
install.sh [--uninstall] [--dry-run] [--force] [--strict] [--verbose]

  --uninstall   remove installer-created symlinks (corpus untouched)
  --dry-run     print actions without changing the filesystem
  --force       replace a conflicting target (real file / foreign symlink) — destructive
  --strict      error on a divergent collision instead of skipping
  --verbose     report skipped/unchanged entries too
EOF
}

# True when two paths have the same content: files by bytes, dirs recursively.
# Type mismatch (or anything we can't compare cleanly) => false (treated as divergent,
# so we skip+warn rather than ever silently assuming equality).
same_content() {
  local a="$1" b="$2"
  if [ -d "$a" ] && [ -d "$b" ]; then
    diff -r "$a" "$b" >/dev/null 2>&1
  elif [ -f "$a" ] && [ -f "$b" ]; then
    cmp -s "$a" "$b"
  else
    return 1
  fi
}

expand_tilde() {
  case "$1" in
    "~")    printf '%s\n' "$HOME" ;;
    "~/"*)  printf '%s\n' "$HOME/${1#\~/}" ;;
    *)      printf '%s\n' "$1" ;;
  esac
}

# --- args ------------------------------------------------------------------
mode="install"; DRY_RUN=0; FORCE=0; STRICT=0; VERBOSE=0
while [ $# -gt 0 ]; do
  case "$1" in
    --uninstall)   mode="uninstall" ;;
    --dry-run)     DRY_RUN=1 ;;
    --force)       FORCE=1 ;;
    --strict)      STRICT=1 ;;
    --verbose|-v)  VERBOSE=1 ;;
    -h|--help)     usage; exit 0 ;;
    *)             err "unknown argument: $1 (see --help)" ;;
  esac
  shift
done
[ "$FORCE" -eq 1 ] && [ "$STRICT" -eq 1 ] && err "--force and --strict are mutually exclusive"

# --- prerequisites ---------------------------------------------------------
command -v yq >/dev/null 2>&1 || \
  err "yq is required (https://github.com/mikefarah/yq) — install with: brew install yq"

config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
config_file="${AGENTIC_OCEAN_CONFIG:-$config_home/agentic-ocean/installer.yaml}"
[ -f "$config_file" ] || \
  err "config not found: $config_file (copy installer.example.yaml there and adjust paths)"

n_changed=0
n_skipped=0

# Iterate every (link, entry, target) the mapping defines, calling: <handler> link entry target
for_each_link() {
  local handler="$1"
  local src_count i name root kind target srcdir entry link
  src_count="$(yq '.sources | length' "$config_file")"
  # yq yields a number for a list, but 'null'/'' if 'sources:' is missing or unreadable.
  # Validate explicitly so a malformed config gives our error, not a raw `[` failure.
  case "$src_count" in
    '' | *[!0-9]*) err "no readable 'sources:' list in $config_file" ;;
  esac
  [ "$src_count" -gt 0 ] || err "no sources defined in $config_file"
  for i in $(seq 0 "$((src_count - 1))"); do
    name="$(yq ".sources[$i].name" "$config_file")"
    root="$(expand_tilde "$(yq ".sources[$i].root" "$config_file")")"
    [ -d "$root" ] || err "source '$name': root not found: $root"
    # Process substitution (not a pipe) so the loop runs in this shell and the
    # n_changed/n_skipped increments inside the handler survive.
    while IFS= read -r kind; do
      [ -n "$kind" ] || continue
      target="$(expand_tilde "$(yq ".sources[$i].links.$kind" "$config_file")")"
      srcdir="$root/$kind"
      [ -d "$srcdir" ] || continue
      for entry in "$srcdir"/*; do
        [ -e "$entry" ] || continue
        link="$target/$(basename "$entry")"
        "$handler" "$link" "$entry" "$target"
      done
    done < <(yq ".sources[$i].links | keys | .[]" "$config_file")
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
    # A foreign target is in the way. Additive default (ADR-002): never clobber.
    if [ "$FORCE" -eq 1 ]; then
      if [ "$DRY_RUN" -eq 1 ]; then
        log "would replace: $link -> $entry"; n_changed=$((n_changed + 1)); return 0
      fi
      rm -rf "$link"
      # fall through to create the link
    elif same_content "$link" "$entry"; then
      vlog "skip (identical): $link"
      n_skipped=$((n_skipped + 1)); return 0
    elif [ "$STRICT" -eq 1 ]; then
      err "collision: $link differs from corpus entry (--strict) — resolve it or drop --strict"
    else
      warn "skip (differs, kept existing): $link — use --force to replace with the corpus version"
      n_skipped=$((n_skipped + 1)); return 0
    fi
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
    log "install dry-run complete ($n_changed link(s) would change, $n_skipped skipped)"
  else
    log "install complete ($n_changed new link(s), $n_skipped skipped)"
  fi
else
  for_each_link uninstall_one
  if [ "$DRY_RUN" -eq 1 ]; then
    log "uninstall dry-run complete ($n_changed link(s) would be removed)"
  else
    log "uninstall complete ($n_changed link(s) removed)"
  fi
fi

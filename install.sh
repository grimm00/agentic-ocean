#!/usr/bin/env bash
#
# install.sh — agentic-ocean corpus installer (symlink farm, ADR-002)
#
# Reads installer.yaml and symlinks each source's corpus/<kind>/<entry> into the
# editor target dir named by the mapping. Symlink mode (C-INST-1 GO). Per-item links
# so multiple sources can populate the same target dir. Idempotent; collision = error.
#
#   install.sh              install (default)
#   install.sh --uninstall  remove installer-created symlinks (corpus untouched)
#
# Config lookup: $AGENTIC_OCEAN_CONFIG, else $XDG_CONFIG_HOME/agentic-ocean/installer.yaml,
# else ~/.config/agentic-ocean/installer.yaml.
#
# Schema: docs/installer-schema.md. (Scope: Group 4 / Tasks 11–12 — install + uninstall.
# Standard flags and the core→personal check arrive in Tasks 13–14.)

set -euo pipefail

err() { printf 'error: %s\n' "$*" >&2; exit 1; }
log() { printf '%s\n' "$*"; }

expand_tilde() {
  case "$1" in
    "~")    printf '%s\n' "$HOME" ;;
    "~/"*)  printf '%s\n' "$HOME/${1#\~/}" ;;
    *)      printf '%s\n' "$1" ;;
  esac
}

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
  mkdir -p "$target"
  if [ -L "$link" ]; then
    [ "$(readlink "$link")" = "$entry" ] && return 0   # already correct — idempotent
    err "collision: $link is a symlink pointing elsewhere ($(readlink "$link"))"
  elif [ -e "$link" ]; then
    err "collision: $link exists and is not managed by this installer"
  fi
  ln -s "$entry" "$link"
  log "linked: $link -> $entry"
  n_changed=$((n_changed + 1))
}

# Remove a link only if it is OUR symlink (points at the corpus entry); never touch
# real files, missing entries, or symlinks pointing elsewhere.
uninstall_one() {
  local link="$1" entry="$2"
  if [ -L "$link" ] && [ "$(readlink "$link")" = "$entry" ]; then
    rm "$link"
    log "unlinked: $link"
    n_changed=$((n_changed + 1))
  fi
}

# --- main ------------------------------------------------------------------
mode="install"
case "${1:-}" in
  --uninstall) mode="uninstall" ;;
  "")          ;;
  *)           err "unknown argument: $1 (supported: --uninstall)" ;;
esac

if [ "$mode" = "install" ]; then
  for_each_link install_one
  log "install complete ($n_changed new link(s))"
else
  for_each_link uninstall_one
  log "uninstall complete ($n_changed link(s) removed)"
fi

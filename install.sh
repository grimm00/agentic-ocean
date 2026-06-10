#!/usr/bin/env bash
#
# install.sh — agentic-ocean corpus installer (symlink farm, ADR-002)
#
# Reads installer.yaml and symlinks each source's corpus/<kind>/<entry> into the
# editor target dir named by the mapping. Symlink mode (C-INST-1 GO). Per-item links
# so multiple sources can populate the same target dir. Idempotent; collision = error.
#
# Config lookup: $AGENTIC_OCEAN_CONFIG, else $XDG_CONFIG_HOME/agentic-ocean/installer.yaml,
# else ~/.config/agentic-ocean/installer.yaml.
#
# Schema: docs/installer-schema.md. (Scope: Group 4 / Task 11 — core install.
# Uninstall, flags, and the core→personal check arrive in Tasks 12–14.)

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

# --- install ---------------------------------------------------------------
src_count="$(yq '.sources | length' "$config_file")"
[ "$src_count" -gt 0 ] 2>/dev/null || err "no sources defined in $config_file"

linked=0
for i in $(seq 0 "$((src_count - 1))"); do
  name="$(yq ".sources[$i].name" "$config_file")"
  root="$(expand_tilde "$(yq ".sources[$i].root" "$config_file")")"
  [ -d "$root" ] || err "source '$name': root not found: $root"

  for kind in $(yq ".sources[$i].links | keys | .[]" "$config_file"); do
    target="$(expand_tilde "$(yq ".sources[$i].links.$kind" "$config_file")")"
    srcdir="$root/$kind"
    [ -d "$srcdir" ] || continue   # source has no entries of this kind — skip
    mkdir -p "$target"

    for entry in "$srcdir"/*; do
      [ -e "$entry" ] || continue   # empty kind dir (glob didn't match)
      link="$target/$(basename "$entry")"
      if [ -L "$link" ]; then
        if [ "$(readlink "$link")" = "$entry" ]; then
          continue                  # already correct — idempotent
        fi
        err "collision: $link is a symlink pointing elsewhere ($(readlink "$link"))"
      elif [ -e "$link" ]; then
        err "collision: $link exists and is not managed by this installer"
      fi
      ln -s "$entry" "$link"
      log "linked: $link -> $entry"
      linked=$((linked + 1))
    done
  done
done

log "install complete ($linked new link(s))"

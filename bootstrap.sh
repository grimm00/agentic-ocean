#!/usr/bin/env bash
#
# bootstrap.sh — fresh-machine setup for the agentic-ocean corpus (Tier 2, ADR-002).
#
# Run it from a cloned core repo: it clones the private personal repo as a sibling,
# seeds ~/.config/agentic-ocean/installer.yaml from installer.example.yaml (rewriting
# the corpus roots to the local clones), then delegates to install.sh (additive — it
# never clobbers a pre-existing ~/.cursor/).
#
#   git clone https://github.com/grimm00/agentic-ocean.git
#   cd agentic-ocean && ./bootstrap.sh
#
#   bootstrap.sh [--core-only] [--dry-run] [--verbose]
#
#     --core-only   skip the private personal repo (install core corpus only)
#     --dry-run     print what would happen; make no changes
#     --verbose     pass through to install.sh
#
# Env overrides (forks / testing): AGENTIC_OCEAN_PERSONAL_URL.
# Layout: core repo = this script's dir; personal repo = a sibling 'agentic-ocean-personal'.

set -euo pipefail

err()  { printf 'error: %s\n' "$*" >&2; exit 1; }
warn() { printf 'warning: %s\n' "$*" >&2; }
log()  { printf '%s\n' "$*"; }
vlog() { if [ "$VERBOSE" -eq 1 ]; then printf '%s\n' "$*"; fi; }

usage() {
  cat <<'EOF'
bootstrap.sh [--core-only] [--dry-run] [--verbose]

  --core-only   skip the private personal repo (install core corpus only)
  --dry-run     print what would happen; make no changes
  --verbose     pass through to install.sh
EOF
}

# --- args ------------------------------------------------------------------
CORE_ONLY=0; DRY_RUN=0; VERBOSE=0
while [ $# -gt 0 ]; do
  case "$1" in
    --core-only)  CORE_ONLY=1 ;;
    --dry-run)    DRY_RUN=1 ;;
    --verbose|-v) VERBOSE=1 ;;
    -h|--help)    usage; exit 0 ;;
    *)            err "unknown argument: $1 (see --help)" ;;
  esac
  shift
done

# --- prerequisites ---------------------------------------------------------
command -v git >/dev/null 2>&1 || err "git is required"
command -v yq  >/dev/null 2>&1 || \
  err "yq is required (https://github.com/mikefarah/yq) — install with: brew install yq"

core_dir="$(cd "$(dirname "$0")" && pwd)"
base_dir="$(dirname "$core_dir")"
personal_dir="$base_dir/agentic-ocean-personal"
personal_url="${AGENTIC_OCEAN_PERSONAL_URL:-git@github.com:grimm00/agentic-ocean-personal.git}"

installer="$core_dir/install.sh"
example="$core_dir/installer.example.yaml"
[ -f "$installer" ] || err "install.sh not found next to bootstrap.sh ($installer)"
[ -f "$example" ]   || err "installer.example.yaml not found ($example)"

config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
config_dir="$config_home/agentic-ocean"
config_file="$config_dir/installer.yaml"

# --- 1. clone the personal repo (unless core-only) -------------------------
have_personal=0
if [ "$CORE_ONLY" -eq 1 ]; then
  warn "core-only: skipping the personal repo"
elif [ -d "$personal_dir/.git" ]; then
  vlog "personal repo present: $personal_dir"; have_personal=1
elif [ "$DRY_RUN" -eq 1 ]; then
  log "would clone personal repo → $personal_dir"; have_personal=1
elif git clone "$personal_url" "$personal_dir" 2>/dev/null; then
  log "cloned personal repo → $personal_dir"; have_personal=1
else
  err "could not clone the personal repo ($personal_url) — set up SSH/gh auth, or re-run with --core-only"
fi

# --- 2. seed the config (idempotent: never overwrite an existing one) -------
if [ -f "$config_file" ]; then
  log "config exists, leaving as-is: $config_file"
elif [ "$DRY_RUN" -eq 1 ]; then
  log "would write config → $config_file (core root: $core_dir/corpus$( [ "$have_personal" -eq 1 ] && printf '%s' "; personal root: $personal_dir/corpus" ))"
else
  mkdir -p "$config_dir"
  tmp="$(mktemp)"
  yq ".sources[0].root = \"$core_dir/corpus\"" "$example" > "$tmp"
  if [ "$have_personal" -eq 1 ]; then
    yq -i ".sources[1].root = \"$personal_dir/corpus\"" "$tmp"
  else
    yq -i 'del(.sources[1])' "$tmp"
  fi
  mv "$tmp" "$config_file"
  log "wrote config → $config_file"
fi

# --- 3. install (delegate to the additive installer) -----------------------
if [ "$DRY_RUN" -eq 1 ]; then
  log "would run: $installer (additive)"
elif [ "$VERBOSE" -eq 1 ]; then
  "$installer" --verbose
else
  "$installer"
fi

log "bootstrap complete."

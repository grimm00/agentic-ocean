#!/usr/bin/env bash
#
# validate-fresh-install.sh — Docker clean-room validation of the Tier 2 flow (Group 5 / Task 18).
#
# Bundles the local core + personal repos (offline — no network/private auth needed), clones
# them inside a pristine container, runs bootstrap.sh against a fresh $HOME, and asserts:
#
#   A) Clean machine:  clone → bootstrap yields a working corpus (symlinks under ~/.cursor/).
#   B) Managed/shared:  a pre-populated, COLLIDING ~/.cursor entry is skipped + warned and
#                       left byte-for-byte intact (additive, never clobbered — feature ADR-002),
#                       while non-colliding entries still install.
#
# This proves the install mechanics on a clean OS/HOME. It does NOT exercise a live private
# clone over SSH (bundles stand in) — that part is covered by the real-Linux-box acceptance.
#
#   scripts/validate-fresh-install.sh [--image IMG] [--keep]
#
#     --image IMG   base image (default: ubuntu:latest)
#     --keep        keep the scratch bundle dir (default: cleaned up)
#
# Env: AGENTIC_OCEAN_PERSONAL_REPO (default: ~/Projects/agentic-ocean-personal).

set -euo pipefail

err() { printf 'error: %s\n' "$*" >&2; exit 1; }

IMAGE="ubuntu:latest"; KEEP=0
while [ $# -gt 0 ]; do
  case "$1" in
    --image) IMAGE="$2"; shift ;;
    --keep)  KEEP=1 ;;
    -h|--help) sed -n '2,22p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) err "unknown argument: $1 (see --help)" ;;
  esac
  shift
done

command -v docker >/dev/null 2>&1 || err "docker is required"
docker version >/dev/null 2>&1 || err "docker daemon not reachable"

core_repo="$(cd "$(dirname "$0")/.." && pwd)"
personal_repo="${AGENTIC_OCEAN_PERSONAL_REPO:-$HOME/Projects/agentic-ocean-personal}"
[ -d "$core_repo/.git" ]     || err "core repo not a git repo: $core_repo"
[ -d "$personal_repo/.git" ] || err "personal repo not found: $personal_repo (set AGENTIC_OCEAN_PERSONAL_REPO)"

work="$(mktemp -d)"
cleanup() { [ "$KEEP" -eq 1 ] || rm -rf "$work"; }
trap cleanup EXIT

echo "Bundling repos (offline) → $work"
git -C "$core_repo"     bundle create "$work/core.bundle" HEAD >/dev/null
git -C "$personal_repo" bundle create "$work/personal.bundle" HEAD >/dev/null

cat > "$work/run.sh" <<'CONTAINER'
set -eu
export DEBIAN_FRONTEND=noninteractive
echo "--- installing tooling (git + yq) ---"
apt-get update -qq >/dev/null
apt-get install -yqq git wget ca-certificates >/dev/null
ARCH="$(dpkg --print-architecture)"
wget -qO /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${ARCH}"
chmod +x /usr/local/bin/yq
echo "git $(git --version | awk '{print $3}'), $(yq --version)"

clone_and_bootstrap() {  # $1 = fresh HOME
  local H="$1"
  rm -rf "$H"; mkdir -p "$H"
  HOME="$H" git clone -q /mnt/core.bundle "$H/agentic-ocean"
  HOME="$H" AGENTIC_OCEAN_PERSONAL_URL=/mnt/personal.bundle \
    bash "$H/agentic-ocean/bootstrap.sh"
}

echo
echo "=== Scenario A: clean machine (clone -> bootstrap) ==="
clone_and_bootstrap /root/a
[ -L /root/a/.cursor/skills/update-pr-description ] \
  || { echo "FAIL A: core skill 'update-pr-description' not symlinked"; exit 1; }
A_LINKS="$(find /root/a/.cursor -type l | wc -l | tr -d ' ')"
echo "A: ~/.cursor symlinks created = $A_LINKS"
[ "$A_LINKS" -gt 1 ] || { echo "FAIL A: expected multiple symlinks"; exit 1; }
echo "PASS A"

echo
echo "=== Scenario B: pre-populated/managed ~/.cursor (additive, never clobber) ==="
rm -rf /root/b; mkdir -p /root/b/.cursor/skills
printf 'TEAM MANAGED\n' > /root/b/.cursor/skills/update-pr-description   # foreign collision (file vs corpus dir)
HOME=/root/b git clone -q /mnt/core.bundle /root/b/agentic-ocean
set +e
OUT="$(HOME=/root/b AGENTIC_OCEAN_PERSONAL_URL=/mnt/personal.bundle bash /root/b/agentic-ocean/bootstrap.sh 2>&1)"
RC=$?
set -e
echo "$OUT" | sed 's/^/  | /'
[ "$RC" -eq 0 ] || { echo "FAIL B: bootstrap exited $RC (additive should not abort)"; exit 1; }
echo "$OUT" | grep -qiE "differs|skip" || { echo "FAIL B: no skip/warn for the colliding entry"; exit 1; }
[ ! -L /root/b/.cursor/skills/update-pr-description ] \
  || { echo "FAIL B: foreign entry was clobbered into a symlink"; exit 1; }
[ "$(cat /root/b/.cursor/skills/update-pr-description)" = "TEAM MANAGED" ] \
  || { echo "FAIL B: foreign entry content changed"; exit 1; }
B_LINKS="$(find /root/b/.cursor -type l | wc -l | tr -d ' ')"
echo "B: non-colliding symlinks still installed = $B_LINKS"
[ "$B_LINKS" -gt 1 ] || { echo "FAIL B: nothing else linked"; exit 1; }
echo "PASS B"

echo
echo "ALL VALIDATIONS PASSED"
CONTAINER

echo "Running clean-room in $IMAGE …"
docker run --rm -v "$work:/mnt:ro" "$IMAGE" bash /mnt/run.sh

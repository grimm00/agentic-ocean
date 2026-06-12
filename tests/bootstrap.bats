#!/usr/bin/env bats
# Tests for bootstrap.sh — fresh-machine clone+config+install flow (Group 5 / Task 17).
# Network is avoided by pre-creating the two clones as local dirs (with a .git/ so the
# clone step is skipped); only the offline seams (config seeding, idempotency, delegation,
# flags) are exercised here. Live cloning is covered by Task 18 validation.

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  TMP="$BATS_TEST_TMPDIR"
  BASE="$TMP/Projects"
  CORE="$BASE/agentic-ocean"
  PERSONAL="$BASE/agentic-ocean-personal"

  # fake "core clone": corpus payload + the real install.sh/bootstrap.sh + a fixture example
  mkdir -p "$CORE/.git" "$CORE/corpus/skills/alpha" "$CORE/corpus/skills/beta" "$CORE/corpus/commands"
  echo "alpha" > "$CORE/corpus/skills/alpha/SKILL.md"
  echo "beta"  > "$CORE/corpus/skills/beta/SKILL.md"
  echo "cmd"   > "$CORE/corpus/commands/foo.md"
  cp "$REPO_ROOT/install.sh"   "$CORE/install.sh"
  cp "$REPO_ROOT/bootstrap.sh" "$CORE/bootstrap.sh"

  # fake "personal clone"
  mkdir -p "$PERSONAL/.git" "$PERSONAL/corpus/skills/pskill"
  echo "p" > "$PERSONAL/corpus/skills/pskill/SKILL.md"

  # editor targets + isolated XDG config home (never touch the real ~/.cursor or ~/.config)
  mkdir -p "$TMP/editor/skills" "$TMP/editor/commands"
  export XDG_CONFIG_HOME="$TMP/xdg"

  # fixture example: links point at temp editor dirs; roots are placeholders bootstrap rewrites
  cat > "$CORE/installer.example.yaml" <<EOF
schema_version: 1
sources:
  - name: agentic-ocean
    role: core
    root: /placeholder/core/corpus
    links:
      skills: $TMP/editor/skills
      commands: $TMP/editor/commands
  - name: agentic-ocean-personal
    role: personal
    root: /placeholder/personal/corpus
    links:
      skills: $TMP/editor/skills
EOF

  BOOTSTRAP="$CORE/bootstrap.sh"
  CFG="$XDG_CONFIG_HOME/agentic-ocean/installer.yaml"
}

@test "seeds config with rewritten roots and installs both repos" {
  run bash "$BOOTSTRAP"
  [ "$status" -eq 0 ]
  [ -f "$CFG" ]
  [ "$(yq '.sources[0].root' "$CFG")" = "$CORE/corpus" ]
  [ "$(yq '.sources[1].root' "$CFG")" = "$PERSONAL/corpus" ]
  [ -L "$TMP/editor/skills/alpha" ]       # core entry linked
  [ -L "$TMP/editor/skills/pskill" ]      # personal entry linked
}

@test "is idempotent (re-run succeeds, config + links intact)" {
  run bash "$BOOTSTRAP"; [ "$status" -eq 0 ]
  run bash "$BOOTSTRAP"; [ "$status" -eq 0 ]
  [ -L "$TMP/editor/skills/alpha" ]
}

@test "leaves an existing config untouched" {
  mkdir -p "$XDG_CONFIG_HOME/agentic-ocean"
  cat > "$CFG" <<EOF
# my custom config marker
schema_version: 1
sources:
  - name: agentic-ocean
    role: core
    root: $CORE/corpus
    links:
      skills: $TMP/editor/skills
EOF
  run bash "$BOOTSTRAP"
  [ "$status" -eq 0 ]
  grep -q "my custom config marker" "$CFG"        # not overwritten
  [ "$(yq '.sources | length' "$CFG")" = "1" ]    # not re-seeded to 2 sources
}

@test "--core-only drops the personal source" {
  run bash "$BOOTSTRAP" --core-only
  [ "$status" -eq 0 ]
  [ "$(yq '.sources | length' "$CFG")" = "1" ]
  [ -L "$TMP/editor/skills/alpha" ]
  [ ! -e "$TMP/editor/skills/pskill" ]            # personal not installed
}

@test "--dry-run makes no filesystem changes" {
  run bash "$BOOTSTRAP" --dry-run
  [ "$status" -eq 0 ]
  [ ! -f "$CFG" ]
  [ ! -e "$TMP/editor/skills/alpha" ]
  [[ "$output" == *"would"* ]]
}

@test "missing personal clone without --core-only fails fast with guidance" {
  rm -rf "$PERSONAL"
  AGENTIC_OCEAN_PERSONAL_URL="file:///nonexistent-$RANDOM" run bash "$BOOTSTRAP"
  [ "$status" -ne 0 ]
  [[ "$output" == *"--core-only"* ]]              # actionable guidance
}

@test "--help lists flags and exits 0" {
  run bash "$BOOTSTRAP" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"--core-only"* ]]
  [[ "$output" == *"--dry-run"* ]]
}

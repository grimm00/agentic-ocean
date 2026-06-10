#!/usr/bin/env bats
# Tests for install.sh — core install (Group 4 / Task 11).

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  INSTALL="$REPO_ROOT/install.sh"
  TMP="$BATS_TEST_TMPDIR/fix"
  mkdir -p "$TMP/corpus/skills/alpha" "$TMP/corpus/skills/beta" "$TMP/corpus/commands"
  echo "alpha" > "$TMP/corpus/skills/alpha/SKILL.md"
  echo "beta"  > "$TMP/corpus/skills/beta/SKILL.md"
  echo "cmd"   > "$TMP/corpus/commands/foo.md"
  mkdir -p "$TMP/editor/skills" "$TMP/editor/commands"
  CONFIG="$TMP/installer.yaml"
  cat > "$CONFIG" <<EOF
schema_version: 1
sources:
  - name: test-core
    root: $TMP/corpus
    links:
      skills: $TMP/editor/skills
      commands: $TMP/editor/commands
EOF
  export AGENTIC_OCEAN_CONFIG="$CONFIG"
}

@test "install creates per-item symlinks into editor targets" {
  run bash "$INSTALL"
  [ "$status" -eq 0 ]
  [ -L "$TMP/editor/skills/alpha" ]
  [ -L "$TMP/editor/skills/beta" ]
  [ -L "$TMP/editor/commands/foo.md" ]
  [ "$(readlink "$TMP/editor/skills/alpha")" = "$TMP/corpus/skills/alpha" ]
}

@test "install is idempotent (re-run succeeds, links intact)" {
  run bash "$INSTALL"; [ "$status" -eq 0 ]
  run bash "$INSTALL"; [ "$status" -eq 0 ]
  [ -L "$TMP/editor/skills/alpha" ]
}

@test "collision errors when target exists as a non-managed file" {
  echo "real" > "$TMP/editor/skills/alpha"
  run bash "$INSTALL"
  [ "$status" -ne 0 ]
  [[ "$output" == *"collision"* ]]
}

@test "missing config errors clearly" {
  export AGENTIC_OCEAN_CONFIG="$TMP/does-not-exist.yaml"
  run bash "$INSTALL"
  [ "$status" -ne 0 ]
  [[ "$output" == *"config not found"* ]]
}

@test "uninstall removes installer-created links, corpus intact" {
  run bash "$INSTALL"; [ "$status" -eq 0 ]
  run bash "$INSTALL" --uninstall; [ "$status" -eq 0 ]
  [ ! -e "$TMP/editor/skills/alpha" ]
  [ ! -e "$TMP/editor/commands/foo.md" ]
  [ -f "$TMP/corpus/skills/alpha/SKILL.md" ]   # corpus untouched
}

@test "uninstall leaves unrelated entries untouched" {
  run bash "$INSTALL"; [ "$status" -eq 0 ]
  echo "mine" > "$TMP/editor/skills/unrelated"   # a real file we didn't create
  run bash "$INSTALL" --uninstall; [ "$status" -eq 0 ]
  [ -f "$TMP/editor/skills/unrelated" ]          # left alone
  [ ! -e "$TMP/editor/skills/alpha" ]            # ours removed
}

@test "uninstall is idempotent" {
  run bash "$INSTALL"; [ "$status" -eq 0 ]
  run bash "$INSTALL" --uninstall; [ "$status" -eq 0 ]
  run bash "$INSTALL" --uninstall; [ "$status" -eq 0 ]
}

@test "unknown argument errors" {
  run bash "$INSTALL" --bogus
  [ "$status" -ne 0 ]
  [[ "$output" == *"unknown argument"* ]]
}

@test "--dry-run makes no filesystem changes" {
  run bash "$INSTALL" --dry-run
  [ "$status" -eq 0 ]
  [ ! -e "$TMP/editor/skills/alpha" ]
  [[ "$output" == *"would link"* ]]
}

@test "--force replaces a conflicting non-managed target" {
  echo "real" > "$TMP/editor/skills/alpha"
  run bash "$INSTALL" --force
  [ "$status" -eq 0 ]
  [ -L "$TMP/editor/skills/alpha" ]
  [ "$(readlink "$TMP/editor/skills/alpha")" = "$TMP/corpus/skills/alpha" ]
}

@test "collision without --force still errors" {
  echo "real" > "$TMP/editor/skills/alpha"
  run bash "$INSTALL"
  [ "$status" -ne 0 ]
  [[ "$output" == *"--force"* ]]
}

@test "--verbose reports already-linked skips" {
  run bash "$INSTALL"; [ "$status" -eq 0 ]
  run bash "$INSTALL" --verbose
  [ "$status" -eq 0 ]
  [[ "$output" == *"skip"* ]]
}

#!/usr/bin/env bash
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
VERIFIER="$SCRIPT_DIR/verify-knowledge-base.sh"
WORK_DIR=$(mktemp -d)
VERIFIER_TODAY='2026-09-23'

cleanup() {
  rm -rf "$WORK_DIR"
}
trap cleanup EXIT

write_fixture() {
  rm -rf "$WORK_DIR"
  mkdir -p "$WORK_DIR/docs" "$WORK_DIR/sources"
  printf '%s\n' '# Fixture' '[source:GOOD-SOURCE]' '[maintenance](docs/maintenance.md)' > "$WORK_DIR/README.md"
  printf '%s\n' '# Agent instructions' > "$WORK_DIR/AGENTS.md"
  printf '%s\n' '# Changelog' > "$WORK_DIR/CHANGELOG.md"
  printf '%s\n' '# Maintenance' > "$WORK_DIR/docs/maintenance.md"
  printf '%s\n' '# Review log' > "$WORK_DIR/sources/review-log.md"
  printf '%s\n' "schema_version: 1" "updated_at: '2026-09-12'" 'sources:' \
    "  - id: 'GOOD-SOURCE'" "    level: 'S'" "    publisher: 'OpenAI'" \
    "    title: 'Fixture source'" '    published_at: null' \
    "    verified_at: '2026-09-12'" '    review_interval_days: 30' \
    "    url: 'https://example.com/source'" \
    "    stability: 'volatile'" "    status: 'active'" \
    > "$WORK_DIR/sources/registry.yaml"
}

run_verifier() {
  set +e
  verifier_output=$(KNOWLEDGE_BASE_TODAY="$VERIFIER_TODAY" "$VERIFIER" "$WORK_DIR" 2>&1)
  verifier_status=$?
  set -e
}

assert_success() {
  run_verifier
  [ "$verifier_status" -eq 0 ] || {
    printf '%s\n' "$verifier_output"
    return 1
  }
  case "$verifier_output" in
    PASS:*) ;;
    *) printf '%s\n' "$verifier_output"; return 1 ;;
  esac
}

assert_failure() {
  run_verifier
  [ "$verifier_status" -ne 0 ] || {
    printf 'unexpected success: %s\n' "$verifier_output"
    return 1
  }
  case "$verifier_output" in
    FAIL:*) ;;
    *) printf '%s\n' "$verifier_output"; return 1 ;;
  esac
}

assert_failure_contains() {
  expected_fragment=$1
  run_verifier
  [ "$verifier_status" -ne 0 ] || {
    printf 'unexpected success: %s\n' "$verifier_output"
    return 1
  }
  case "$verifier_output" in
    FAIL:*) ;;
    *) printf '%s\n' "$verifier_output"; return 1 ;;
  esac
  case "$verifier_output" in
    *"$expected_fragment"*) ;;
    *) printf 'expected output to contain "%s":\n%s\n' "$expected_fragment" "$verifier_output"; return 1 ;;
  esac
}

write_fixture
assert_success
printf '%s\n' 'PASS: valid fixture accepted'

write_fixture
VERIFIER_TODAY='2026-10-13'
cp "$WORK_DIR/sources/registry.yaml" "$WORK_DIR/registry.before"
assert_failure_contains 'GOOD-SOURCE'
cmp -s "$WORK_DIR/registry.before" "$WORK_DIR/sources/registry.yaml"
grep -q "^    status: 'active'$" "$WORK_DIR/sources/registry.yaml"
printf '%s\n' 'PASS: overdue source reported without changing registry'

write_fixture
VERIFIER_TODAY='2026-10-12'
assert_success
printf '%s\n' 'PASS: source at review interval boundary accepted'
VERIFIER_TODAY='2026-09-23'

write_fixture
awk '!/^    review_interval_days:/' "$WORK_DIR/sources/registry.yaml" > "$WORK_DIR/registry.tmp"
mv "$WORK_DIR/registry.tmp" "$WORK_DIR/sources/registry.yaml"
assert_failure
printf '%s\n' 'PASS: missing review interval rejected'

write_fixture
sed 's/^    review_interval_days: 30$/    review_interval_days: 45/' "$WORK_DIR/sources/registry.yaml" > "$WORK_DIR/registry.tmp"
mv "$WORK_DIR/registry.tmp" "$WORK_DIR/sources/registry.yaml"
assert_failure
printf '%s\n' 'PASS: unsupported review interval rejected'

write_fixture
sed "s/verified_at: '2026-09-12'/verified_at: '2026-02-30'/" "$WORK_DIR/sources/registry.yaml" > "$WORK_DIR/registry.tmp"
mv "$WORK_DIR/registry.tmp" "$WORK_DIR/sources/registry.yaml"
assert_failure
printf '%s\n' 'PASS: invalid calendar date rejected'

write_fixture
sed "s/verified_at: '2026-09-12'/verified_at: '2026-09-24'/" "$WORK_DIR/sources/registry.yaml" > "$WORK_DIR/registry.tmp"
mv "$WORK_DIR/registry.tmp" "$WORK_DIR/sources/registry.yaml"
assert_failure
printf '%s\n' 'PASS: future verification date rejected'

awk '!/^    published_at:/' "$WORK_DIR/sources/registry.yaml" > "$WORK_DIR/registry.tmp"
mv "$WORK_DIR/registry.tmp" "$WORK_DIR/sources/registry.yaml"
assert_failure
printf '%s\n' 'PASS: missing published_at rejected'

write_fixture
awk '!/^    verified_at:/' "$WORK_DIR/sources/registry.yaml" > "$WORK_DIR/registry.tmp"
mv "$WORK_DIR/registry.tmp" "$WORK_DIR/sources/registry.yaml"
assert_failure
printf '%s\n' 'PASS: missing required field rejected'

write_fixture
sed "s/^  - id: 'GOOD-SOURCE'/  - level: 'S'/" "$WORK_DIR/sources/registry.yaml" > "$WORK_DIR/registry.tmp"
mv "$WORK_DIR/registry.tmp" "$WORK_DIR/sources/registry.yaml"
assert_failure
printf '%s\n' 'PASS: missing source ID rejected'

write_fixture
printf '%s\n' "  - id: 'GOOD-SOURCE'" "    level: 'S'" "    published_at: null" \
  "    verified_at: '2026-09-12'" "    url: 'https://example.com/duplicate'" \
  "    stability: 'stable'" "    status: 'active'" >> "$WORK_DIR/sources/registry.yaml"
assert_failure
printf '%s\n' 'PASS: duplicate source ID rejected'

write_fixture
printf '%s\n' '[source:SRC-MISSING]' >> "$WORK_DIR/README.md"
assert_failure
printf '%s\n' 'PASS: unknown source reference rejected'

write_fixture
printf '%s\n' '[broken](missing.md)' >> "$WORK_DIR/README.md"
assert_failure
printf '%s\n' 'PASS: broken relative link rejected'

printf '%s\n' 'PASS: verifier test suite'

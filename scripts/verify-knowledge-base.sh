#!/usr/bin/env bash
set -eu

fail() {
  printf 'FAIL: %s\n' "$1"
  exit 1
}

date_to_epoch() {
  local date_value=$1 parsed_epoch normalized_date
  [[ "$date_value" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || return 1
  if parsed_epoch=$(date -u -j -f '%Y-%m-%d %H:%M:%S' "$date_value 00:00:00" '+%s' 2>/dev/null); then
    :
  elif parsed_epoch=$(date -u -d "$date_value 00:00:00" '+%s' 2>/dev/null); then
    :
  else
    return 1
  fi
  case "$parsed_epoch" in
    ''|*[!0-9-]*) return 1 ;;
  esac
  if normalized_date=$(date -u -r "$parsed_epoch" '+%Y-%m-%d' 2>/dev/null); then
    :
  elif normalized_date=$(date -u -d "@$parsed_epoch" '+%Y-%m-%d' 2>/dev/null); then
    :
  else
    return 1
  fi
  [ "$normalized_date" = "$date_value" ] || return 1
  printf '%s\n' "$parsed_epoch"
}

ROOT=${1:-.}
[ -d "$ROOT" ] || fail "root directory not found: $ROOT"
ROOT=$(CDPATH= cd -- "$ROOT" && pwd -P)
today_value=${KNOWLEDGE_BASE_TODAY:-$(date -u '+%Y-%m-%d')}
today_epoch=$(date_to_epoch "$today_value") || fail "invalid current date: $today_value"

for required_file in \
  README.md \
  AGENTS.md \
  CHANGELOG.md \
  docs/maintenance.md \
  sources/registry.yaml \
  sources/review-log.md; do
  [ -f "$ROOT/$required_file" ] || fail "missing required file: $required_file"
done

agent_lines=$(wc -l < "$ROOT/AGENTS.md" | tr -d ' ')
[ "$agent_lines" -le 100 ] || fail "AGENTS.md exceeds 100 lines: $agent_lines"

for formal_file in \
  README.md \
  AGENTS.md \
  CHANGELOG.md \
  docs/maintenance.md \
  sources/review-log.md; do
  if grep -nE '\b(TODO|TBD)\b' "$ROOT/$formal_file"; then
    fail "unresolved placeholder in $formal_file"
  fi
  if grep -nEi "(^|[[:space:]])(api[_-]?key|secret|password|token)[[:space:]]*[:=][[:space:]]*[\"']?[A-Za-z0-9_./+=-]{8,}" "$ROOT/$formal_file"; then
    fail "possible example secret in $formal_file"
  fi
done

REGISTRY="$ROOT/sources/registry.yaml"
TEMP_DIR=$(mktemp -d)
cleanup() {
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT
RECORDS="$TEMP_DIR/records.tsv"

malformed_source_item=$(awk '/^  - / && $0 !~ /^  - id:[[:space:]]*/ { print $0; exit }' "$REGISTRY")
[ -z "$malformed_source_item" ] || fail "source item missing id: $malformed_source_item"

awk '
function clean_value(line) {
  quote = sprintf("%c", 39)
  sub(/^[^:]+:[[:space:]]*/, "", line)
  if (substr(line, 1, 1) == quote && substr(line, length(line), 1) == quote) {
    line = substr(line, 2, length(line) - 2)
  }
  return line
}
function emit_record() {
  if (!in_record) return
  print id "\t" level "\t" published_set "\t" published "\t" verified_set "\t" verified "\t" url_set "\t" url "\t" stability_set "\t" stability "\t" status_set "\t" status "\t" review_interval_set "\t" review_interval_days
}
/^  - id:[[:space:]]*/ {
  emit_record()
  in_record = 1
  id = clean_value($0)
  level = ""
  published = ""
  verified = ""
  url = ""
  stability = ""
  status = ""
  published_set = 0
  verified_set = 0
  url_set = 0
  stability_set = 0
  status_set = 0
  review_interval_days = ""
  review_interval_set = 0
  next
}
in_record && /^    level:/ { level = clean_value($0); next }
in_record && /^    published_at:/ { published = clean_value($0); published_set = 1; next }
in_record && /^    verified_at:/ { verified = clean_value($0); verified_set = 1; next }
in_record && /^    url:/ { url = clean_value($0); url_set = 1; next }
in_record && /^    stability:/ { stability = clean_value($0); stability_set = 1; next }
in_record && /^    status:/ { status = clean_value($0); status_set = 1; next }
in_record && /^    review_interval_days:/ { review_interval_days = clean_value($0); review_interval_set = 1; next }
END { emit_record() }
' "$REGISTRY" > "$RECORDS"

record_count=$(wc -l < "$RECORDS" | tr -d ' ')
[ "$record_count" -gt 0 ] || fail "registry has no sources"

duplicate_id=$(awk -F '\t' '{ if (seen[$1]++) { print $1; exit } }' "$RECORDS")
[ -z "$duplicate_id" ] || fail "duplicate source ID: $duplicate_id"

while IFS=$'\t' read -r source_id source_level published_set published_value verified_set verified_value url_set url_value stability_set stability_value status_set status_value review_interval_set review_interval_days; do
  [ -n "$source_id" ] || fail "source missing id"
  [ "$published_set" -eq 1 ] || fail "$source_id missing published_at"
  [ "$verified_set" -eq 1 ] || fail "$source_id missing verified_at"
  [ "$url_set" -eq 1 ] || fail "$source_id missing url"
  [ "$stability_set" -eq 1 ] || fail "$source_id missing stability"
  [ "$status_set" -eq 1 ] || fail "$source_id missing status"
  [ -n "$source_level" ] || fail "$source_id missing level"
  [ -n "$url_value" ] || fail "$source_id has empty url"
  case "$source_level" in
    S|A|B) ;;
    *) fail "$source_id has invalid level: $source_level" ;;
  esac
  case "$stability_value" in
    stable|volatile) ;;
    *) fail "$source_id has invalid stability: $stability_value" ;;
  esac
  case "$status_value" in
    active|review_due|contested|superseded) ;;
    *) fail "$source_id has invalid status: $status_value" ;;
  esac
  [ "$review_interval_set" -eq 1 ] || fail "$source_id missing review_interval_days"
  case "$review_interval_days" in
    30|90|180|365) ;;
    *) fail "$source_id has invalid review_interval_days: $review_interval_days" ;;
  esac
  verified_epoch=$(date_to_epoch "$verified_value") || fail "$source_id has invalid verified_at date: $verified_value"
  [ "$verified_epoch" -le "$today_epoch" ] || fail "$source_id has future verified_at date: $verified_value"
  if [ "$status_value" = 'active' ]; then
    age_days=$(((today_epoch - verified_epoch) / 86400))
    [ "$age_days" -le "$review_interval_days" ] || fail "source review overdue: $source_id (verified_at: $verified_value; interval: $review_interval_days days; age: $age_days days; status unchanged)"
  fi
done < "$RECORDS"

while IFS= read -r markdown_file; do
  while IFS= read -r source_ref; do
    [ -n "$source_ref" ] || continue
    [ "$source_ref" = "ID" ] && continue
    if ! awk -F '\t' -v wanted="$source_ref" '$1 == wanted { found = 1 } END { exit found ? 0 : 1 }' "$RECORDS"; then
      fail "unknown source reference in $markdown_file: $source_ref"
    fi
  done < <(grep -oE '\[source:[A-Z0-9][A-Z0-9-]*\]' "$markdown_file" | sed -E 's/^\[source:([^]]+)\]$/\1/' || true)

  markdown_dir=$(dirname "$markdown_file")
  while IFS= read -r relative_link; do
    [ -n "$relative_link" ] || continue
    case "$relative_link" in
      \#*|http://*|https://*|mailto:*|//*) continue ;;
    esac
    relative_link=${relative_link%%#*}
    relative_link=${relative_link%%[[:space:]]*}
    [ -n "$relative_link" ] || continue
    case "$relative_link" in
      /*) target="$ROOT$relative_link" ;;
      *) target="$markdown_dir/$relative_link" ;;
    esac
    [ -e "$target" ] || fail "broken relative link in $markdown_file: $relative_link"
  done < <(sed -nE 's/.*\]\(([^)]*)\).*/\1/p' "$markdown_file")
done < <(find "$ROOT" -type f -name '*.md' ! -path "$ROOT/.git/*" ! -path "$ROOT/.superpowers/*" | sort)

printf 'PASS: knowledge base verification\n'

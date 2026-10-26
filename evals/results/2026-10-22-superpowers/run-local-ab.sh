#!/usr/bin/env bash
set -uo pipefail

repo=/Users/chuanchuan/Work/codex
root=/private/tmp/superpowers-ab-20261023
auth_home=${CODEX_HOME:-$HOME/.codex}
auth_home=$(cd "$auth_home" && pwd -P)
variants=(baseline v7.0.0 v7.0.1)
tasks=(T02 T01)
resume_id=${SUPERPOWERS_AB_RESUME:-}
resume_baseline_t02=''
if [[ -n "$resume_id" ]]; then
  if [[ ! "$resume_id" =~ ^[0-9]{8}T[0-9]{6}Z-[0-9]+$ ]]; then
    echo "invalid SUPERPOWERS_AB_RESUME run id: $resume_id" >&2
    exit 2
  fi
  run_stamp=${resume_id%-*}
  summary="$root/summary-$run_stamp-${resume_id##*-}.tsv"
  runtime_profiles="$root/runtime-profiles/$resume_id"
else
  run_stamp=$(date -u +%Y%m%dT%H%M%SZ)
  summary="$root/summary-$run_stamp-$$.tsv"
  runtime_profiles="$root/runtime-profiles/$run_stamp-$$"
fi
system_skills_source="$root/profiles/baseline/codex-home/skills/.system"
overall_rc=0

has_superpowers_cache() {
  local codex_home=$1
  [[ -d "$codex_home/plugins/cache" ]] || return 1
  find "$codex_home/plugins/cache" -mindepth 2 -maxdepth 2 -type d -name superpowers -print -quit | grep -q .
}

has_skill_source_leak() {
  local events=$1
  local variant=$2
  local profile=$3
  python3 - "$events" "$variant" "$profile" "$root/manifest.json" <<'PY'
import json
import pathlib
import sys

events_path, variant, profile, manifest_path = sys.argv[1:]
manifest = json.load(open(manifest_path))
skill_names = {
    item["name"]
    for version in ("v7.0.0", "v7.0.1")
    for item in manifest["variants"][version]["skills"]
}
expected_root = pathlib.Path(profile, ".agents", "skills").resolve()
for line in open(events_path):
    if not line.strip():
        continue
    event = json.loads(line)
    item = event.get("item", {})
    if item.get("type") != "command_execution":
        continue
    for token in item.get("command", "").split():
        candidate = token.strip("\"'`,;()")
        if not candidate.endswith("/SKILL.md"):
            continue
        source = pathlib.Path(candidate).resolve()
        if source.parent.name not in skill_names:
            continue
        if variant == "baseline" or expected_root not in source.parents:
            print(candidate)
            raise SystemExit(0)
raise SystemExit(1)
PY
}

if ! command -v codex >/dev/null 2>&1; then
  echo 'codex was not found in PATH' >&2
  exit 2
fi
if [[ ! -d "$auth_home" ]]; then
  echo "CODEX_HOME does not exist: $auth_home" >&2
  exit 2
fi
if [[ ! -f "$auth_home/auth.json" ]]; then
  echo "CODEX_HOME/auth.json is not available: $auth_home" >&2
  exit 2
fi
if [[ ! -f "$root/skills-list.json" || ! -f "$root/manifest.json" ]]; then
  echo "prepared isolated profiles are missing under $root" >&2
  exit 2
fi

mkdir -p "$root/results" "$root/cases" "$runtime_profiles"
if [[ -n "$resume_id" ]]; then
  if [[ ! -f "$summary" ]]; then
    echo "cannot resume: summary is missing: $summary" >&2
    exit 2
  fi
else
  printf 'variant\ttask\tattempt\tmodel_exit\texisting_tests_exit\tacceptance_exit\telapsed_seconds\tresult_dir\n' > "$summary"
fi
if [[ ! -f "$root/codex-version-$run_stamp.txt" ]]; then
  codex --version > "$root/codex-version-$run_stamp.txt" 2>&1
fi

for variant in "${variants[@]}"; do
  source_profile="$root/profiles/$variant"
  profile="$runtime_profiles/$variant"
  temp_codex_home="$profile/codex-home"
  if [[ ! -d "$source_profile/.agents/skills" || ! -d "$system_skills_source" ]]; then
    echo "isolated skill snapshots are incomplete for $variant" >&2
    exit 2
  fi
  if [[ -n "$resume_id" ]]; then
    if [[ ! -d "$profile/.agents/skills" || ! -d "$temp_codex_home/skills/.system" || ! -f "$temp_codex_home/auth.json" ]]; then
      echo "cannot resume: runtime profile is incomplete: $profile" >&2
      exit 2
    fi
  else
    mkdir -p "$profile/.agents/skills" "$temp_codex_home/skills"
    if [[ -n "$(find "$source_profile/.agents/skills" -mindepth 1 -maxdepth 1 -print -quit)" ]]; then
      cp -R "$source_profile/.agents/skills/." "$profile/.agents/skills/"
    fi
    cp -R "$system_skills_source" "$temp_codex_home/skills/.system"
    ln -s "$auth_home/auth.json" "$temp_codex_home/auth.json"
    if [[ -e "$temp_codex_home/config.toml" || -d "$temp_codex_home/plugins" ]]; then
      echo "isolated CODEX_HOME contains user configuration or plugins: $temp_codex_home" >&2
      exit 2
    fi
  fi
  if [[ "$(readlink "$temp_codex_home/auth.json")" != "$auth_home/auth.json" ]]; then
    echo "auth symlink does not point to the current CODEX_HOME for $variant" >&2
    exit 2
  fi
done

preflight="$root/preflight/$run_stamp"
mkdir -p "$preflight"
if [[ -n "$resume_id" ]]; then
  if [[ ! -f "$preflight/final.txt" || ! -f "$preflight/exit-code.txt" || "$(cat "$preflight/exit-code.txt")" != 0 ]] || ! python3 -c 'import json,sys; rows=[json.loads(x) for x in open(sys.argv[1]) if x.strip()]; ok=any(x.get("type")=="item.completed" and x.get("item",{}).get("type")=="agent_message" and x["item"].get("text","").strip()=="OK" for x in rows); raise SystemExit(0 if ok else 1)' "$preflight/events.jsonl"; then
    echo "cannot resume: the saved preflight did not pass: $preflight" >&2
    exit 2
  fi
  resume_baseline_t02=$(python3 - "$summary" <<'PY'
import csv
import pathlib
import sys

rows = csv.DictReader(open(sys.argv[1]), delimiter="\t")
row = next((item for item in rows if item["variant"] == "baseline" and item["task"] == "T02"), None)
if row is None or any(row[key] != "0" for key in ("model_exit", "existing_tests_exit", "acceptance_exit")):
    raise SystemExit(1)
result = pathlib.Path(row["result_dir"])
if not all((result / name).is_file() for name in ("events.jsonl", "model-exit-code.txt", "existing-tests-exit-code.txt", "acceptance-exit-code.txt")):
    raise SystemExit(1)
print(result)
PY
  )
  if [[ -z "$resume_baseline_t02" ]] || has_skill_source_leak "$resume_baseline_t02/events.jsonl" baseline "$runtime_profiles/baseline"; then
    echo "cannot resume: baseline T02 is missing, failed, or read a Superpowers skill. summary=$summary" >&2
    exit 2
  fi
  printf 'resuming %s; reusing the completed baseline T02\n' "$resume_id"
else
  HOME="$runtime_profiles/baseline" CODEX_HOME="$runtime_profiles/baseline/codex-home" codex exec \
    --ignore-user-config --enable respect_system_proxy --ephemeral --skip-git-repo-check \
    -C "$root" -s read-only \
    -m gpt-6.1-sol -c model_reasoning_effort=medium \
    --json -o "$preflight/final.txt" '仅回复 OK，不调用任何工具。' \
    > "$preflight/events.jsonl" 2> "$preflight/stderr.log"
  preflight_rc=$?
  printf '%s\n' "$preflight_rc" > "$preflight/exit-code.txt"
  if [[ $preflight_rc -ne 0 ]] || ! python3 -c 'import json,sys; rows=[json.loads(x) for x in open(sys.argv[1]) if x.strip()]; ok=any(x.get("type")=="item.completed" and x.get("item",{}).get("type")=="agent_message" and x["item"].get("text","").strip()=="OK" for x in rows); raise SystemExit(0 if ok else 1)' "$preflight/events.jsonl"; then
    echo "isolated Codex preflight failed; no A/B task runs were started. details=$preflight" >&2
    exit 1
  fi
  printf 'isolated preflight passed; starting six A/B tasks\n'
fi

for task in "${tasks[@]}"; do
  case "$task" in
    T01)
      task_file="$repo/evals/model-upgrade/tasks/v1/T01-stock-underflow.md"
      evaluator="$repo/evals/model-upgrade/evaluator-tests/v1/T01-stock-underflow.test.js"
      ;;
    T02)
      task_file="$repo/evals/model-upgrade/tasks/v1/T02-inventory-filter.md"
      evaluator="$repo/evals/model-upgrade/evaluator-tests/v1/T02-inventory-filter.test.js"
      ;;
  esac

  for variant in "${variants[@]}"; do
    profile="$runtime_profiles/$variant"
    temp_codex_home="$profile/codex-home"
    if [[ ! -d "$profile/.agents/skills" ]]; then
      echo "missing isolated skills profile: $profile" >&2
      exit 2
    fi
    python3 - "$root/manifest.json" "$variant" "$profile/.agents/skills" <<'PY'
import hashlib
import json
import pathlib
import sys

manifest = json.load(open(sys.argv[1]))
variant = sys.argv[2]
skill_root = pathlib.Path(sys.argv[3])
expected = {item["name"]: item["sha256"] for item in manifest["variants"][variant]["skills"]}
actual = {}
for skill_dir in skill_root.iterdir():
    skill_file = skill_dir / "SKILL.md"
    if skill_file.is_file():
        actual[skill_dir.name] = hashlib.sha256(skill_file.read_bytes()).hexdigest()
if actual != expected:
    print(f"skill snapshot drift for {variant}: expected={sorted(expected)} actual={sorted(actual)}", file=sys.stderr)
    raise SystemExit(2)
PY
    if [[ $? -ne 0 ]]; then
      exit 2
    fi

    if [[ -n "$resume_id" && "$task" == T02 && "$variant" == baseline ]]; then
      if has_superpowers_cache "$temp_codex_home"; then
        cache_state=present
      else
        cache_state=absent
      fi
      printf 'superpowers_cache=%s\nout_of_profile_skill_read=none\n' "$cache_state" > "$resume_baseline_t02/skill-source-check.txt"
      printf 'reusing baseline T02 from %s (cache=%s; no Superpowers skill file read)\n' "$resume_baseline_t02" "$cache_state"
      continue
    fi

    attempt=1
    while [[ -e "$root/results/$variant/$task/attempt-$attempt" ]]; do
      attempt=$((attempt + 1))
    done
    case_dir="$root/cases/$variant/$task/attempt-$attempt"
    out="$root/results/$variant/$task/attempt-$attempt"
    mkdir -p "$case_dir" "$out"
    cp -R "$repo/evals/model-upgrade/core-v1/." "$case_dir/"

    started=$(date +%s)
    started_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    HOME="$profile" CODEX_HOME="$profile/codex-home" codex exec \
      --ignore-user-config --enable respect_system_proxy --ephemeral --skip-git-repo-check \
      -C "$case_dir" -s workspace-write \
      -m gpt-6.1-sol -c model_reasoning_effort=medium \
      --json -o "$out/final.txt" - < "$task_file" \
      > "$out/events.jsonl" 2> "$out/stderr.log"
    model_rc=$?
    ended=$(date +%s)
    ended_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    elapsed=$((ended - started))
    printf '%s\n' "$model_rc" > "$out/model-exit-code.txt"
    printf '%s\n' "$started_at" > "$out/started-at.txt"
    printf '%s\n' "$ended_at" > "$out/ended-at.txt"

    (cd "$case_dir" && node --test) > "$out/existing-tests.log" 2>&1
    existing_rc=$?
    printf '%s\n' "$existing_rc" > "$out/existing-tests-exit-code.txt"
    CORE_WORKSPACE="$case_dir" node --test "$evaluator" > "$out/acceptance-tests.log" 2>&1
    test_rc=$?
    printf '%s\n' "$test_rc" > "$out/acceptance-exit-code.txt"
    diff -ru "$repo/evals/model-upgrade/core-v1" "$case_dir" > "$out/changes.diff"
    diff_rc=$?
    printf '%s\n' "$diff_rc" > "$out/diff-exit-code.txt"
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
      "$variant" "$task" "$attempt" "$model_rc" "$existing_rc" "$test_rc" "$elapsed" "$out" >> "$summary"
    printf '%s %s model_exit=%s existing_tests_exit=%s acceptance_exit=%s elapsed=%ss result=%s\n' \
      "$variant" "$task" "$model_rc" "$existing_rc" "$test_rc" "$elapsed" "$out"
    if [[ $model_rc -ne 0 || $existing_rc -ne 0 || $test_rc -ne 0 ]]; then
      overall_rc=1
    fi
    if has_skill_source_leak "$out/events.jsonl" "$variant" "$profile"; then
      echo "Superpowers source isolation failed for $variant $task; an out-of-profile skill file was read. details=$out" >&2
      printf 'summary=%s\n' "$summary"
      exit 3
    fi
    if has_superpowers_cache "$temp_codex_home"; then
      cache_state=present
    else
      cache_state=absent
    fi
    printf 'superpowers_cache=%s\nout_of_profile_skill_read=none\n' "$cache_state" > "$out/skill-source-check.txt"
  done
done

printf 'summary=%s\n' "$summary"
exit "$overall_rc"

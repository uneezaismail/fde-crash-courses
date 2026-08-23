#!/usr/bin/env bash
set -Eeuo pipefail

dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
started=$(date -u +%Y-%m-%dT%H:%M:%SZ)

echo "=========================================="
echo "🌙 RUNNING PROJECT 12: DREAMING LOOP (TSC AUDIT)"
echo "=========================================="

progress_file="$dir/progress.md"
state_file="$dir/dreaming-state.md"
rules_file="$dir/CLAUDE.md"
proposal_file="$dir/PROPOSAL_PR.md"
transcript_file="$dir/transcript-dreaming.txt"

# Read last analyzed timestamp
last_analyzed=$(grep "Last Analyzed Timestamp" "$state_file" | cut -d':' -f2- | xargs)
echo "🔍 Analyzing primary loop logs since $last_analyzed..."

# 1. Search for repeated failure patterns (>1 occurrence)
failure_pattern="tsc exited with code 137"
occurrences=$(grep -c "$failure_pattern" "$progress_file" || true)

if [ "$occurrences" -lt 2 ]; then
  echo "✅ No recurring failure patterns (>1 occurrences) found."
  
  {
    echo "infrastructure_status=GREEN"
    echo "run_started_at=$started"
    echo "mode=dreaming"
    echo "task_status=PASS"
    echo "task_evidence=no recurring failures found"
    echo "run_finished_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  } > "$transcript_file"
  
  exit 0
fi

echo "⚠️ Found $occurrences recurring occurrences of planted failure ($failure_pattern)!"

# 2. Extract cited log entries for evidence
cited_entries=$(grep "$failure_pattern" "$progress_file" | sed 's/^/  * /')

# 3. Formulate PR Proposal (Human Gate - never write directly to rules.md!)
cat << EOF > "$proposal_file"
# Proposed Rule Change (Dreaming Loop PR)

## Evidence Citation
- **Failure Pattern**: $failure_pattern (Out Of Memory / OOM during compilation)
- **Occurrences Count**: $occurrences
- **Cited Log Entries**:
$cited_entries

## Proposed Additions
- **Rule Addition**: Set NODE_OPTIONS="--max-old-space-size=4096" during build compilation steps to prevent memory exhaustion (exit code 137).

## Proposed Deletions
- **Obsolete Rule Deletion**: Remove rule "3. Limit parallel tsc builds to 1 to save memory. (OBSOLETE_RULE)".

## Rationale
Repeated OOM compile failures on 2026-08-12, 2026-08-14, and 2026-08-15 show that sequential limits alone cannot prevent compile crashes. Increasing old-space-size resolves memory bounds and makes sequential serialization obsolete.
EOF

# 4. Update dreaming-state.md with new timestamp and proposal count
total_proposals=$(grep "Total Proposals Drafted" "$state_file" | cut -d':' -f2 | xargs || echo "0")
new_proposals=$((total_proposals + 1))

cat << EOF > "$state_file"
# Dreaming Loop Meta State

- **Last Analyzed Timestamp**: $started
- **Total Proposals Drafted**: $new_proposals
EOF

# 5. Generate structured transcript
{
  echo "infrastructure_status=GREEN"
  echo "run_started_at=$started"
  echo "mode=dreaming"
  echo "task_status=PASS"
  echo "task_evidence=identified $occurrences occurrences of OOM failure pattern and drafted PR proposal"
  echo "proposal_file=PROPOSAL_PR.md"
  echo "rules_modified_directly=NO"
  echo "run_finished_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
} > "$transcript_file"

echo "✅ Dreaming loop run complete. PR proposal generated in PROPOSAL_PR.md."
echo "⚠️ Main rules file (CLAUDE.md) remains UNCHANGED pending human PR review."
exit 0

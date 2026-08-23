#!/usr/bin/env bash
set -Eeuo pipefail

dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Trap to clean up generated proposal and transcript files on exit
trap 'rm -f "$dir/PROPOSAL_PR.md" "$dir/transcript-dreaming.txt"' EXIT

# Reset CLAUDE.md and dreaming-state.md initially
cat << 'EOF' > "$dir/CLAUDE.md"
# Project 12 Rules

## Active Rules
1. Always run tsc and lint before submitting any pull request.
2. Ensure test coverage is above 80% on all modified files.
3. Limit parallel tsc builds to 1 to save memory. (OBSOLETE_RULE)
EOF

cat << 'EOF' > "$dir/dreaming-state.md"
# Dreaming Loop Meta State

- **Last Analyzed Timestamp**: 2026-08-09T00:00:00Z
- **Total Proposals Drafted**: 0
EOF

echo "=========================================="
echo "🚀 Running Project 12 Verification Script"
echo "=========================================="

# Run Dreaming Loop
echo ""
echo "--- Running Dreaming Loop ---"
bash "$dir/run_dreaming_loop.sh"

echo ""
echo "--- Verifying Done When Conditions ---"

# Condition 1: PR Proposal created with cited evidence
if [[ -f "$dir/PROPOSAL_PR.md" ]] && \
   grep -Fq 'Evidence Citation' "$dir/PROPOSAL_PR.md" && \
   grep -Fq 'tsc exited with code 137' "$dir/PROPOSAL_PR.md" && \
   grep -Fq '2026-08-12' "$dir/PROPOSAL_PR.md"; then
  echo "✅ Done When 1 Passed: PR proposal correctly cites evidence from real log entries."
else
  echo "❌ Done When 1 FAILED: Proposal file or evidence citations missing."
  exit 1
fi

# Condition 2: Planted repeated failure caught and proposal includes deletion
if grep -Fq 'Obsolete Rule Deletion' "$dir/PROPOSAL_PR.md" && \
   grep -Fq 'OBSOLETE_RULE' "$dir/PROPOSAL_PR.md"; then
  echo "✅ Done When 2 Passed: Planted failure caught and obsolete rule deletion proposed."
else
  echo "❌ Done When 2 FAILED: Repeated failure or deletion proposal missing."
  exit 1
fi

# Condition 3: Main rules file remained UNCHANGED until human PR approval
if grep -Fq 'OBSOLETE_RULE' "$dir/CLAUDE.md"; then
  echo "✅ Done When 3 Passed: Main rules file (CLAUDE.md) was NOT changed directly."
else
  echo "❌ Done When 3 FAILED: Rules file was illegally modified directly without human PR merge."
  exit 1
fi

# Verify Transcript
if grep -Fq 'infrastructure_status=GREEN' "$dir/transcript-dreaming.txt" && \
   grep -Fq 'task_status=PASS' "$dir/transcript-dreaming.txt" && \
   grep -Fq 'rules_modified_directly=NO' "$dir/transcript-dreaming.txt"; then
  echo "✅ Transcript verification passed."
else
  echo "❌ Transcript verification FAILED!"
  exit 1
fi

echo ""
echo "=========================================="
echo "🎉 Project 12 automated verification PASSED!"
echo "=========================================="

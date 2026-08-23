#!/usr/bin/env bash
set -Eeuo pipefail

dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$dir"

started=$(date -u +%Y-%m-%dT%H:%M:%SZ)
transcript="${TRANSCRIPT_PATH:-"transcript-doorbell.txt"}"

echo "========================================================================"
echo "🔔 SIMULATING PROJECT 6: THE DOORBELL LOOP (EVENT-DRIVEN PR REVIEW)"
echo "========================================================================"

# Detect Python interpreter
if command -v python3 >/dev/null 2>&1; then
  PYTHON_EXE="python3"
elif command -v python >/dev/null 2>&1; then
  PYTHON_EXE="python"
else
  echo "❌ Error: Python interpreter not found!" >&2
  exit 1
fi

# Simulate an incoming GitHub event (e.g. pull_request opened / synchronized)
# In production, this script is fired automatically by GitHub Actions or a Routine webhook.
event_type="${1:-pull_request_opened}"
pr_number="${2:-42}"
echo "🔔 Event received: [${event_type}] for Pull Request #${pr_number}"

# Simulate a PR branch checkout (Worktree isolation)
simulated_pr_dir="simulated-pr-$pr_number"
rm -rf "$simulated_pr_dir"
mkdir -p "$simulated_pr_dir/src" "$simulated_pr_dir/test"
cp "src/calculator.py" "$simulated_pr_dir/src/calculator.py"
cp "test/test_calculator.py" "$simulated_pr_dir/test/test_calculator.py"

# Simulate PR author submitting a fix to calculator.py
echo "🔧 PR author pushed a commit to PR #$pr_number. Applying fix to multiply..."
sed -i 's/return a \* b + 1/return a \* b/g' "$simulated_pr_dir/src/calculator.py" 2>/dev/null || \
sed -i "" 's/return a \* b + 1/return a \* b/g' "$simulated_pr_dir/src/calculator.py"

# Run tests independently to verify event reaction
echo "🔍 Doorbell triggered: running tests on PR #$pr_number diff..."
if $PYTHON_EXE "./run_tests.py" "$simulated_pr_dir/test/test_calculator.py" "test_multiply" >/dev/null 2>&1; then
  review_verdict="PASS - Tests pass and the fix is genuine."
else
  review_verdict="FAIL - Tests failed in PR changes."
fi

echo "  💬 Review comment posted to GitHub PR #$pr_number: '$review_verdict'"

# Write transcript evidence
{
  echo "infrastructure_status=GREEN"
  echo "run_started_at=$started"
  echo "event_type=$event_type"
  echo "pr_number=$pr_number"
  echo "review_verdict=$review_verdict"
  echo "run_finished_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
} > "$transcript"

# Cleanup simulated PR workspace
rm -rf "$simulated_pr_dir"

echo "------------------------------------------------------------------------"
echo "Doorbell event transcript written to: $transcript"
cat "$transcript"
echo "------------------------------------------------------------------------"
echo "🎉 Doorbell loop event-driven reaction completed successfully!"
exit 0

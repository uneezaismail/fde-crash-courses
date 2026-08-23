#!/usr/bin/env bash
set -Eeuo pipefail

dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$dir"

# Trap to clean up transcript on exit
trap 'rm -f "$dir/transcript-doorbell.txt"' EXIT

echo "=========================================="
echo "🚀 Running Project 6 Verification Script (The Doorbell Loop)"
echo "=========================================="

echo "🔍 Checking file structure..."
files=(
  "src/calculator.py"
  "test/test_calculator.py"
  ".opencode/agents/pr-reviewer.md"
  ".opencode/skills/doorbell-review/SKILL.md"
  "run_doorbell.sh"
)

for file in "${files[@]}"; do
  if [ -f "$dir/$file" ]; then
    echo "  ✅ Found $file"
  else
    echo "  ❌ Missing $file!"
    exit 1
  fi
done

echo ""
echo "🔄 Simulating Event Trigger (Opening a Pull Request)..."
bash "$dir/run_doorbell.sh" pull_request_opened 101

echo ""
echo "🔬 Verifying Done-When Conditions..."

if [ -f "$dir/transcript-doorbell.txt" ]; then
  echo "  ✅ Done-When 1 Passed: Event triggered review without any manual prompt typed."
else
  echo "  ❌ Done-When 1 FAILED: Transcript not created."
  exit 1
fi

if grep -q "infrastructure_status=GREEN" "$dir/transcript-doorbell.txt" && \
   grep -q "event_type=pull_request_opened" "$dir/transcript-doorbell.txt" && \
   grep -q "review_verdict=PASS" "$dir/transcript-doorbell.txt"; then
  echo "  ✅ Done-When 2 Passed: Review successfully inspected PR and posted PASS verdict!"
else
  echo "  ❌ Done-When 2 FAILED: Transcript validation failed."
  exit 1
fi

echo ""
echo "=========================================="
echo "🎉 Project 6 automated verification PASSED!"
echo "=========================================="

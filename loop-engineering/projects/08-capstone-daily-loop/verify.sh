#!/usr/bin/env bash
set -Eeuo pipefail

dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$dir"

# Clean up generated transcript on exit
trap 'rm -f "$dir/transcript-capstone.txt"' EXIT

echo "=========================================="
echo "🚀 Running Project 8 Capstone Verification Script"
echo "=========================================="

# Reset progress.md
cat << 'EOF' > "$dir/progress.md"
# Daily Capstone Log — Progress Spine

## Done
- 2026-08-20: Initialized capstone daily maintenance loop.

## In progress
- Daily dependency audit and lint sweep across source files.

## Open / needs a human
- None. All safe maintenance sweeps operating normally.
EOF

echo "🔍 Checking file structure for all 6 Loop parts..."
files=(
  "progress.md"
  ".opencode/skills/daily-maintenance/SKILL.md"
  ".opencode/agents/capstone-reviewer.md"
  "run_capstone.sh"
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
echo "🔄 Executing Capstone Daily Loop Beat..."
bash "$dir/run_capstone.sh"

echo ""
echo "🔬 Verifying 6-Part Capstone Completion Criteria..."

# Condition 1: Transcript generated with green infrastructure
if [ -f "$dir/transcript-capstone.txt" ]; then
  echo "  ✅ Part 1 & 5 Passed: Heartbeat and Connector executed successfully."
else
  echo "  ❌ FAILED: Transcript missing."
  exit 1
fi

# Condition 2: Spine updated correctly
if grep -Fq "CAPSTONE DAILY BEAT SUCCESS" "$dir/progress.md"; then
  echo "  ✅ Part 6 Passed: Spine (progress.md) successfully updated at the end of the beat."
else
  echo "  ❌ FAILED: Spine update missing."
  exit 1
fi

# Condition 3: Reviewer & Subagents verified
if grep -q "maker_checker=passed" "$dir/transcript-capstone.txt" && \
   grep -q "infrastructure_status=GREEN" "$dir/transcript-capstone.txt"; then
  echo "  ✅ Part 2, 3 & 4 Passed: Worktree isolation, Skills, and Maker-Checker split validated."
else
  echo "  ❌ FAILED: Maker-checker or isolation check failed."
  exit 1
fi

echo ""
echo "=========================================="
echo "🎉 Project 8 Capstone automated verification PASSED!"
echo "=========================================="

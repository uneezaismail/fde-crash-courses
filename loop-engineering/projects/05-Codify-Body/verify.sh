#!/usr/bin/env bash
set -Eeuo pipefail

dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$dir"

# Trap to clean up generated workflow report on exit
trap 'rm -f "$dir/transcript-workflow.txt"' EXIT

echo "=========================================="
echo "🚀 Running Production Project 5 Verification Script"
echo "=========================================="

# Check required file structure
echo "🔍 Checking file structure..."
files=(
  "src/calculator.py"
  "test/test_calculator.py"
  ".opencode/agents/maker.md"
  ".opencode/agents/reviewer.md"
  ".opencode/skills/fix-bug/SKILL.md"
  ".claude/agents/maker.md"
  ".claude/agents/reviewer.md"
  ".claude/skills/fix-bug/SKILL.md"
  "run_workflow.sh"
)

for file in "${files[@]}"; do
  if [ -f "$dir/$file" ]; then
    echo "  ✅ Found $file"
  else
    echo "  ❌ Missing $file!"
    exit 1
  fi
done

# Run the workflow script
echo ""
echo "🔄 Running the main Workflow script..."
bash "$dir/run_workflow.sh"

# --- Verify Results ---
echo ""
echo "🔬 Verifying Production Done-When Conditions..."

# Condition 1: Check transcript exists and has green infrastructure
if [ -f "$dir/transcript-workflow.txt" ]; then
  echo "  ✅ Done-When 1 Passed: Workflow successfully executed and generated report transcript."
else
  echo "  ❌ Done-When 1 FAILED: Report transcript-workflow.txt was not created."
  exit 1
fi

# Condition 2: Verify candidate expected results (good=PASS, bad=FAIL, scope=FAIL) & engine_state=stateless
if grep -q "infrastructure_status=GREEN" "$dir/transcript-workflow.txt" && \
   grep -q "engine_state=stateless" "$dir/transcript-workflow.txt" && \
   grep -q "candidate_good_actual=PASS" "$dir/transcript-workflow.txt" && \
   grep -q "candidate_bad_actual=FAIL" "$dir/transcript-workflow.txt" && \
   grep -q "candidate_scope_actual=FAIL" "$dir/transcript-workflow.txt" && \
   grep -q "overall_workflow_result=PASS" "$dir/transcript-workflow.txt"; then
  echo "  ✅ Done-When 2 Passed: All candidates matched expectations (good=PASS, bad=FAIL, scope=FAIL)!"
else
  echo "  ❌ Done-When 2 FAILED: Transcript content verification failed."
  cat "$dir/transcript-workflow.txt"
  exit 1
fi

# Condition 3: Verify statelessness across a fresh second run
echo ""
echo "🔄 Executing second fresh run to verify stateless engine behavior..."
bash "$dir/run_workflow.sh"

if grep -q "engine_state=stateless" "$dir/transcript-workflow.txt" && \
   grep -q "overall_workflow_result=PASS" "$dir/transcript-workflow.txt"; then
  echo "  ✅ Done-When 3 Passed: Engine is completely stateless across multiple fresh runs!"
else
  echo "  ❌ Done-When 3 FAILED: Second run statelessness check failed."
  exit 1
fi

echo ""
echo "=========================================="
echo "🎉 Production Project 5 automated verification PASSED!"
echo "=========================================="

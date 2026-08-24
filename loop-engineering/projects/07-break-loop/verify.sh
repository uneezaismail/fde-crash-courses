#!/usr/bin/env bash
set -Eeuo pipefail

dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$dir"

# Clean up generated transcript on exit
trap 'rm -f "$dir/transcript-break.txt"' EXIT

echo "=========================================="
echo "🚀 Running Project 7 Verification Script (Break It on Purpose)"
echo "=========================================="

# Reset progress.md to standard 3-section spine structure (Done, In progress, Open / needs a human)
cat << 'EOF' > "$dir/progress.md"
# Morning Brief — Progress Log

## Done
- 2026-08-20: initialized morning brief loop and scanned initial TODO locations.

## In progress
- Dependency scan and TODO triage across source files.

## Open / needs a human
EOF

echo "🔍 Checking file structure..."
files=(
  "progress.md"
  ".opencode/skills/morning-brief-sabotaged/SKILL.md"
  "run_break_loop.sh"
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
echo "🔄 Executing Sabotaged Loop Beat..."
bash "$dir/run_break_loop.sh"

echo ""
echo "🔬 Verifying Done-When Conditions from Spine & Transcript..."

# Condition 1: Diagnose failure from spine alone under "Open / needs a human"
if grep -Fq "Open / needs a human" "$dir/progress.md" && \
   grep -Fq "SABOTAGED BEAT FAILED" "$dir/progress.md" && \
   grep -Fq "src_nonexistent" "$dir/progress.md"; then
  echo "  ✅ Done-When 1 Passed: Failure successfully diagnosed from the spine under 'Open / needs a human'."
else
  echo "  ❌ Done-When 1 FAILED: Spine did not record the failure under the correct heading."
  exit 1
fi

# Condition 2: Loop left a clear needs_human=true / needs a human note instead of failing silently
if grep -q "needs_human=true" "$dir/transcript-break.txt" && \
   grep -E -q "Needs Human: true|needs a human" "$dir/progress.md"; then
  echo "  ✅ Done-When 2 Passed: Loop failed loudly with explicit `needs_human=true` flag and escalation note."
else
  echo "  ❌ Done-When 2 FAILED: 'needs a human' flag or escalation note missing."
  exit 1
fi

# Condition 3: Token cost calculated
if grep -q "estimated_monthly_token_cost_usd" "$dir/transcript-break.txt"; then
  echo "  ✅ Done-When 3 Passed: Token cost calculated and recorded in the diagnostic report."
else
  echo "  ❌ Done-When 3 FAILED: Token cost calculation missing."
  exit 1
fi

echo ""
echo "=========================================="
echo "🎉 Project 7 automated verification PASSED!"
echo "=========================================="

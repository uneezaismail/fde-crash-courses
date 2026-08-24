#!/usr/bin/env bash
set -Eeuo pipefail

dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$dir"

started=$(date -u +%Y-%m-%dT%H:%M:%SZ)
transcript="${TRANSCRIPT_PATH:-"transcript-break.txt"}"
progress_file="progress.md"

echo "========================================================================"
echo "🔦 SIMULATING PROJECT 7: BREAK IT ON PURPOSE (OBSERVABILITY & SPINE)"
echo "========================================================================"

# 1. Token Cost Calculation (Concept 13 math)
# Example: ~40k input tokens, ~6k output tokens per beat -> ~$0.20/beat.
# At hourly cadence (720 beats/month) -> ~$144.00/month.
beats_per_month=720
cost_per_beat_usd=0.20
monthly_cost_estimate=$(echo "$beats_per_month * $cost_per_beat_usd" | bc)

echo "  💰 Estimated Token Cost at hourly cadence: \$$monthly_cost_estimate / month ($beats_per_month beats/mo)"

# 2. Simulate Sabotaged Run Execution (pointing to non-existent source directory)
echo "⚡ Running scheduled loop beat with sabotaged path (src_nonexistent)..."
target_dir="src_nonexistent"
needs_human=false

if [ ! -d "$target_dir" ]; then
  error_msg="CRITICAL: Source directory '$target_dir' not found. Unattended beat failed."
  echo "  ❌ $error_msg"
  
  needs_human=true
  
  # Fail loudly & leave a clear "Open / needs a human" note in the spine matching Project 3/Part 4 structure
  cat << EOF >> "$progress_file"

### $started (SABOTAGED BEAT FAILED)
- **Status**: FAIL
- **Needs Human**: $needs_human
- **Details**: $error_msg — Loop halted safely to prevent runaway token spend.
EOF

  task_status="FAIL - needs a human"
else
  task_status="PASS"
  needs_human=false
fi

# 3. Generate structured diagnostic transcript (incorporating token cost & needs_human boolean)
{
  echo "infrastructure_status=GREEN"
  echo "run_started_at=$started"
  echo "estimated_monthly_token_cost_usd=$monthly_cost_estimate"
  echo "sabotaged_target=$target_dir"
  echo "task_status=$task_status"
  echo "needs_human=$needs_human"
  echo "diagnostic_source=spine_and_logs_only"
  echo "run_finished_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
} > "$transcript"

echo "------------------------------------------------------------------------"
echo "Diagnostic report written to: $transcript"
cat "$transcript"
echo "------------------------------------------------------------------------"
echo "🎉 Project 7 simulation completed successfully!"
exit 0

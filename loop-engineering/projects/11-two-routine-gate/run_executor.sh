#!/usr/bin/env bash
set -Eeuo pipefail

dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
transcript="${TRANSCRIPT_PATH:-"$dir/transcript-executor.txt"}"
started=$(date -u +%Y-%m-%dT%H:%M:%SZ)

echo "=========================================="
echo "⚙️ RUNNING ROUTINE B: THE EXECUTOR"
echo "=========================================="

# Define the expected secure token (simulating B's bearer token)
EXPECTED_TOKEN="secure_approval_bearer_token_123"

# Check if the trigger/bearer token was explicitly provided in environment variables
if [[ -z "${APPROVE_TOKEN:-}" ]]; then
  echo "❌ ERROR: Unauthorized. APPROVE_TOKEN environment variable is missing."
  echo "⚠️ This simulates an un-fired or unauthorized Routine B."
  
  # Generate failing transcript
  {
    echo "infrastructure_status=GREEN"
    echo "run_started_at=$started"
    echo "mode=executor"
    echo "task_status=FAIL"
    echo "task_evidence=missing approval token"
    echo "run_finished_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  } > "$transcript"
  
  exit 0
fi

if [[ "$APPROVE_TOKEN" != "$EXPECTED_TOKEN" ]]; then
  echo "❌ ERROR: Unauthorized. APPROVE_TOKEN is invalid."
  echo "⚠️ This simulates an invalid attempt to fire Routine B."
  
  # Generate failing transcript
  {
    echo "infrastructure_status=GREEN"
    echo "run_started_at=$started"
    echo "mode=executor"
    echo "task_status=FAIL"
    echo "task_evidence=invalid approval token"
    echo "run_finished_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  } > "$transcript"
  
  exit 0
fi

# Verify there is a draft to promote
if [[ ! -f "$dir/DRAFT.md" ]]; then
  echo "❌ ERROR: No draft found to deploy. Run Routine A first."
  
  {
    echo "infrastructure_status=GREEN"
    echo "run_started_at=$started"
    echo "mode=executor"
    echo "task_status=FAIL"
    echo "task_evidence=no draft file found to promote"
    echo "run_finished_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  } > "$transcript"
  
  exit 0
fi

# Simulate the final execution (promote Draft to Production)
cp "$dir/DRAFT.md" "$dir/PRODUCTION.md"
rm -f "$dir/DRAFT.md"

echo "🚀 SUCCESS: Draft promoted to PRODUCTION.md!"

# Update the progress spine to state COMPLETED
sed -i 's/- \*\*Current State:\*\* .*/- \*\*Current State:\*\* `COMPLETED`/' "$dir/progress.md"
sed -i "s/- \*\*Last Updated:\*\* .*/- \*\*Last Updated:\*\* \`$started\`/" "$dir/progress.md"

# Append run to transcript log in progress.md
echo "- **$started**: 🚀 Routine B (Executor) ran. Human approved, promoted draft to PRODUCTION." >> "$dir/progress.md"

# Generate structured transcript
{
  echo "infrastructure_status=GREEN"
  echo "run_started_at=$started"
  echo "mode=executor"
  echo "task_status=PASS"
  echo "task_evidence=human approved, draft promoted to production"
  echo "run_finished_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
} > "$transcript"

echo "✅ Routine B completed successfully. State is now COMPLETED."
exit 0

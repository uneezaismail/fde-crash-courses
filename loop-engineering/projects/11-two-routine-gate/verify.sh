#!/usr/bin/env bash
set -Eeuo pipefail

dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Trap to clean up generated test files on exit
trap 'rm -f "$dir/transcript-drafter.txt" "$dir/transcript-executor.txt" "$dir/DRAFT.md" "$dir/PRODUCTION.md"' EXIT

# Reset progress state initially
cat << 'EOF' > "$dir/progress.md"
# Project 11: Two-Routine Gate Observability Spine

## Approval State
- **Current State:** `INITIAL`
- **Last Updated:** N/A

## Transcript Log
EOF

echo "=========================================="
echo "🚀 Running Project 11 Verification Script"
echo "=========================================="

# 1. Run Routine A (the Drafter)
echo -e "\n--- Step 1: Running Routine A (Drafter) ---"
bash "$dir/run_drafter.sh"

# Verify Draft was created and State updated to PENDING_APPROVAL
if [[ -f "$dir/DRAFT.md" ]] && grep -Fq 'Current State:** `PENDING_APPROVAL`' "$dir/progress.md"; then
  echo "✅ Step 1 passed: Draft created and state set to PENDING_APPROVAL."
else
  echo "❌ Step 1 FAILED: Draft or state incorrect."
  exit 1
fi

# 2. Run Routine B WITHOUT token (unauthorized firing)
echo -e "\n--- Step 2: Running Routine B without Token (Unauthorized) ---"
bash "$dir/run_executor.sh"

# Verify execution failed cleanly (task_status=FAIL, infrastructure_status=GREEN)
if grep -Fq 'infrastructure_status=GREEN' "$dir/transcript-executor.txt" && \
   grep -Fq 'task_status=FAIL' "$dir/transcript-executor.txt" && \
   grep -Fq 'task_evidence=missing approval token' "$dir/transcript-executor.txt"; then
  echo "✅ Step 2 passed: Executor rejected unauthorized execution while remaining infrastructure GREEN."
else
  echo "❌ Step 2 FAILED: Executor accepted empty token or infrastructure errored."
  exit 1
fi

# 3. Run Routine B WITH correct token (authorized firing)
echo -e "\n--- Step 3: Running Routine B with Correct Token (Authorized) ---"
export APPROVE_TOKEN="secure_approval_bearer_token_123"
bash "$dir/run_executor.sh"
unset APPROVE_TOKEN

# Verify execution succeeded (PRODUCTION.md exists, DRAFT.md is removed, state is COMPLETED)
if [[ -f "$dir/PRODUCTION.md" ]] && [[ ! -f "$dir/DRAFT.md" ]] && \
   grep -Fq 'Current State:** `COMPLETED`' "$dir/progress.md" && \
   grep -Fq 'task_status=PASS' "$dir/transcript-executor.txt" && \
   grep -Fq 'human approved, draft promoted to production' "$dir/transcript-executor.txt"; then
  echo "✅ Step 3 passed: Executor successfully authorized and draft promoted to production."
else
  echo "❌ Step 3 FAILED: Success scenario verification failed."
  exit 1
fi

echo -e "\n=========================================="
echo "🎉 Project 11 automated verification PASSED!"
echo "=========================================="

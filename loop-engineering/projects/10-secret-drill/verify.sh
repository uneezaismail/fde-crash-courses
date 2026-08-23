#!/usr/bin/env bash
set -Eeuo pipefail

dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Trap to clean up generated transcripts on exit
trap 'rm -f "$dir/transcript-dotenv.txt" "$dir/transcript-environment.txt" "$dir/.env_temp_backup"' EXIT

echo "=========================================="
echo "🚀 Running Project 10 Verification Script"
echo "=========================================="

# Ensure .env file exists initially
printf 'API_KEY=this_is_a_dummy_secret_from_dotenv\n' > "$dir/.env"

# Run failure scenario
echo ""
echo "--- Running Failure Scenario ---"
bash "$dir/run_failure.sh"

# Run success scenario
echo ""
echo "--- Running Success Scenario ---"
bash "$dir/run_success.sh"

# --- Verify Transcripts ---

echo ""
echo "--- Verifying Transcripts ---"

# Verify Failure Transcript
if grep -Fq 'infrastructure_status=GREEN' "$dir/transcript-dotenv.txt" && \
   grep -Fq 'task_status=FAIL' "$dir/transcript-dotenv.txt" && \
   grep -Fq 'missing file: .env' "$dir/transcript-dotenv.txt"; then
    echo "✅ Failure transcript (dotenv) verification passed."
else
    echo "❌ Failure transcript (dotenv) verification FAILED!"
    exit 1
fi

# Verify Success Transcript
if grep -Fq 'infrastructure_status=GREEN' "$dir/transcript-environment.txt" && \
   grep -Fq 'task_status=PASS' "$dir/transcript-environment.txt" && \
   grep -Fq 'read API_KEY from environment' "$dir/transcript-environment.txt" && \
   grep -Fq 'token_output=redacted' "$dir/transcript-environment.txt" && \
   ! grep -Fq 'this_is_a_dummy_secret_from_env_var' "$dir/transcript-environment.txt"; then
    echo "✅ Success transcript (environment) verification passed."
else
    echo "❌ Success transcript (environment) verification FAILED!"
    exit 1
fi

echo ""
echo "=========================================="
echo "🎉 Project 10 automated verification PASSED!"
echo "=========================================="

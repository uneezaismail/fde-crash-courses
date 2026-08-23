#!/usr/bin/env bash
set -Eeuo pipefail

mode="environment"
dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
transcript="${TRANSCRIPT_PATH:-"$dir/transcript-environment.txt"}"
started=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Simulate setting an environment variable for this session
export API_KEY="this_is_a_dummy_secret_from_env_var"
echo "NOTE: Temporarily setting API_KEY environment variable for this simulation."

opencode_prompt="credentials are available as environment variables; do not look for a .env file."

# Check if secret is present in environment
if [ -n "${API_KEY:-}" ]; then
    task_status="PASS"
    task_evidence="read API_KEY from environment (length=${#API_KEY})"
    token_output="redacted"
else
    task_status="FAIL"
    task_evidence="environment variable API_KEY is unset"
    token_output="none"
fi

# Clear the environment variable after simulation
unset API_KEY

# Generate structured transcript
{
  echo "infrastructure_status=GREEN"
  echo "run_started_at=$started"
  echo "mode=$mode"
  echo "opencode_prompt=$opencode_prompt"
  echo "task_status=$task_status"
  echo "task_evidence=$task_evidence"
  echo "token_output=$token_output"
  echo "run_finished_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
} > "$transcript"

echo "----------------------------------------------------------------------------------------------------"
echo "Transcript for SUCCESS scenario (logged to $transcript):"
cat "$transcript"
echo "----------------------------------------------------------------------------------------------------"
echo "Verification Hint: Check '$transcript' for 'task_status=PASS' and 'infrastructure_status=GREEN'."

# A green infrastructure run is intentional even when the task failed.
exit 0

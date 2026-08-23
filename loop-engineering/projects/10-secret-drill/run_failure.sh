#!/usr/bin/env bash
set -Eeuo pipefail

mode="dotenv"
dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
transcript="${TRANSCRIPT_PATH:-"$dir/transcript-dotenv.txt"}"
started=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Temporarily move the .env file to simulate it being absent in a fresh clone
if [ -f "$dir/.env" ]; then
    mv "$dir/.env" "$dir/.env_temp_backup"
    echo "NOTE: Temporarily moved .env to .env_temp_backup to simulate absence."
fi

# Determine task status based on whether .env is present
if [ ! -f "$dir/.env" ]; then
    task_status="FAIL"
    task_evidence="missing file: .env"
    diagnosis="gitignored files never reach the fresh GitHub clone"
else
    task_status="FAIL"
    task_evidence=".env exists only in local working copy; fresh clone must not rely on it"
    diagnosis="do not rely on local .env in cloud routines"
fi

# Restore the .env file
if [ -f "$dir/.env_temp_backup" ]; then
    mv "$dir/.env_temp_backup" "$dir/.env"
    echo "NOTE: Restored .env from .env_temp_backup."
fi

# Generate structured transcript
{
  echo "infrastructure_status=GREEN"
  echo "run_started_at=$started"
  echo "mode=$mode"
  echo "opencode_prompt=Attempt to read the secret API_KEY from a .env file or local configuration."
  echo "task_status=$task_status"
  echo "task_evidence=$task_evidence"
  echo "diagnosis=$diagnosis"
  echo "run_finished_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
} > "$transcript"

echo "----------------------------------------------------------------------------------------------------"
echo "Transcript for FAILURE scenario (logged to $transcript):"
cat "$transcript"
echo "----------------------------------------------------------------------------------------------------"
echo "Verification Hint: Check '$transcript' for 'task_status=FAIL' and 'infrastructure_status=GREEN'."

# A green infrastructure run is intentional even when the task failed.
exit 0

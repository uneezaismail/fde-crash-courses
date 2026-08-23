#!/usr/bin/env bash
set -Eeuo pipefail

dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
transcript="${TRANSCRIPT_PATH:-"$dir/transcript-drafter.txt"}"
started=$(date -u +%Y-%m-%dT%H:%M:%SZ)

echo "=========================================="
echo "🔄 RUNNING ROUTINE A: THE DRAFTER"
echo "=========================================="

# Create a draft of the proposed changes
echo "# Proposed Production Release" > "$dir/DRAFT.md"
echo "Release Version: 1.0.0" >> "$dir/DRAFT.md"
echo "Changes: Implemented secure environment-variable secret handling." >> "$dir/DRAFT.md"
echo "Drafted at: $started" >> "$dir/DRAFT.md"

echo "✅ Draft change written to DRAFT.md."

# Update the progress spine to state PENDING_APPROVAL
# Use sed to replace the current state with PENDING_APPROVAL
sed -i 's/- \*\*Current State:\*\* .*/- \*\*Current State:\*\* `PENDING_APPROVAL`/' "$dir/progress.md"
sed -i "s/- \*\*Last Updated:\*\* .*/- \*\*Last Updated:\*\* \`$started\`/" "$dir/progress.md"

# Append run to transcript log in progress.md
echo "- **$started**: 📝 Routine A (Drafter) ran. Draft created, awaiting human approval." >> "$dir/progress.md"

# Generate structured transcript
{
  echo "infrastructure_status=GREEN"
  echo "run_started_at=$started"
  echo "mode=drafter"
  echo "task_status=PASS"
  echo "task_evidence=draft created and progress updated to PENDING_APPROVAL"
  echo "run_finished_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
} > "$transcript"

echo "✅ Routine A completed successfully. State is now PENDING_APPROVAL."
exit 0

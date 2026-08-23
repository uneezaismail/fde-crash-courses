# Proposed Rule Change (Dreaming Loop PR)

## Evidence Citation
- **Failure Pattern**: tsc exited with code 137 (Out Of Memory / OOM during compilation)
- **Occurrences Count**: 4
- **Cited Log Entries**:
  * - **2026-08-12T09:00:00Z**: ❌ FAILURE - Build failed because memory exceeded on tsc compile (tsc exited with code 137).
  * - **2026-08-14T09:00:00Z**: ❌ FAILURE - Build failed because memory exceeded on tsc compile (tsc exited with code 137).
  * - **2026-08-15T09:00:00Z**: ❌ FAILURE - Build failed because memory exceeded on tsc compile (tsc exited with code 137).
  * - **2026-08-17 09:00:00Z**: ❌ FAILURE - Build failed because memory exceeded on tsc compile (tsc exited with code 137).

## Proposed Additions
- **Rule Addition**: Set NODE_OPTIONS="--max-old-space-size=4096" during build compilation steps to prevent memory exhaustion (exit code 137).

## Proposed Deletions
- **Obsolete Rule Deletion**: Remove rule "3. Limit parallel tsc builds to 1 to save memory. (OBSOLETE_RULE)".

## Rationale
Repeated OOM compile failures on 2026-08-12, 2026-08-14, and 2026-08-15 show that sequential limits alone cannot prevent compile crashes. Increasing old-space-size resolves memory bounds and makes sequential serialization obsolete.

---
name: morning-brief
description: >-
  Monitors TODO comments in source files using a location-based tracking system.
  Each run identifies new TODOs by comparing file:line positions against
  previously recorded locations in progress.md. Outputs a summary of changes
  and updates the memory file to prevent repeat reporting.
---

# Morning Brief: Location-Based TODO Tracker

This skill implements a scheduled loop that tracks the appearance and resolution
of TODO comments in your source code. Unlike simple text matching, it uses
file and line number as a unique identifier for each TODO, making it resilient
to comment text changes that don't actually resolve the underlying task.

## Core Concept: Location-Based Tracking

Each TODO is identified by its `filename:line_number` pair. This approach:
- Survives comment text edits (e.g., fixing typos in the TODO)
- Still catches when a TODO is moved to a different line
- Clearly shows when a TODO is removed (line deleted) vs resolved
- Works even if similar TODO text appears elsewhere

## Execution Steps

Follow these steps in order every time the skill is invoked:

### 1. Load Known Locations
- Read `progress.md`
- Parse the "Known TODO Locations" section to build a set of
  `filename:line_number` pairs that have been reported in previous runs
- If the file doesn't exist or the section is missing, treat as empty set

### 2. Scan Current TODOs
- Execute: `find src/ -name "*.py" -exec grep -n "TODO" {} \;`
- For each match, extract the `filename:line_number` (using the line number from grep -n)
- Store as the current set of TODO locations

### 3. Determine Changes
- **New TODOs**: current_locations − known_locations
  (TODOs appearing at locations not seen before)
- **Resolved TODOs**: known_locations − current_locations  
  (Previously seen locations that no longer contain a TODO)
- **Unchanged**: intersection of both sets

### 4. Generate Report
- If there are new TODOs:
  - Format as: "🆕 NEW: [count] new TODO(s) at:" followed by each `filename:line`
- If there are resolved TODOs:
  - Format as: "✅ RESOLVED: [count] TODO(s) no longer present at:" followed by each `filename:line`
- If both are empty:
  - Output exactly: "No changes in TODO locations since last run."
- If only one type exists, show only that section

### 5. Update Memory
- Regardless of changes found, append a new log entry to `progress.md`:
  ```
  ### YYYY-MM-DD
  [The exact report generated in step 4]
  ```
- Then overwrite the "Known TODO Locations" section with the current set:
  ```
  Known TODO Locations:
  - filename1.py:line_num
  - filename2.py:line_num
  (one per line, sorted alphabetically)
  ```

## Why This Approach?

- **Resilience to superficial edits**: Fixing a typo in a TODO comment doesn't make it "new"
- **Clear resolution signal**: When you fix a TODO and leave the comment, it still shows as resolved if you delete the line or move it
- **Precise tracking**: Knows exactly where changes occurred in the file structure
- **Minimal false positives**: Won't flag the same TODO twice due to spacing or comment reformatting

## Memory File Format

Your `progress.md` will contain two main sections:
1. **Chronological Log**: Dated entries showing what changed each run
2. **Known TODO Locations**: Current snapshot used for comparison (updated each run)

Example structure:
```
# Morning Brief — Progress Log

## Known TODO Locations:
- src/processor.py:5
- src/utils.py:12
- src/utils.py:25

## Log
### 2026-08-20
🆕 NEW: 3 new TODO(s) at:
- src/processor.py:5
- src/utils.py:12
- src/utils.py:25

### 2026-08-21
✅ RESOLVED: 1 TODO(s) no longer present at:
- src/utils.py:12
🆕 NEW: 2 new TODO(s) at:
- src/utils.py:30
- src/utils.py:35
```

## Rules

- Never report the same TODO location (file:line) as NEW if it was already recorded as known
- Never report the same TODO location as RESOLVED if it's currently present in the scan
- Always update both the "Known TODO Locations" and append to the "Log" section, even when there are no changes
- Keep each log entry concise: date followed by the change report
- The "Known TODO Locations" section must be kept sorted and without duplicates for reliable comparison

---
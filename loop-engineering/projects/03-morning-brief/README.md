# Project 3: The Morning Brief With a Memory

This project demonstrates how to create a scheduled loop with memory using Claude Code's skill system that remembers what it has already reported, preventing duplicate work while detecting real changes in your codebase.

## Overview

The exercise teaches **Concept 6: unattended schedule** combined with **Concept 12: spine/memory between runs** by building a system where:
1. A loop runs on a schedule (or on demand) to check for TODO comments in source files
2. The loop reads a memory file (`progress.md`) to see what TODOs were already reported
3. It reports only NEW TODOs (appearing at new locations) and RESOLVED TODOs (previously seen locations now missing TODOs)
4. It updates the memory file with current state so future runs know what's been seen
5. You can verify the spine works by running twice and seeing no changes the second time

This proves unattended operation with persistent memory while preparing you for combining loop concepts in later projects.

## Files in this Repository

- `src/` – Sample Python files containing TODO comments to monitor
- `progress.md` – The spine: tracks known TODO locations and maintains a change log
- `.claude/skills/morning-brief/SKILL.md` – The location-based tracking skill (invoked with `Run the morning-brief skill`)
- `README.md` – This file

> **Note:** The skill and progress file were created when you started this exercise. If you want to repeat the experiment, you can reset `progress.md` and edit the TODOs in `src/`.

## How to Run (for anyone)

1. **Start Claude Code in this folder**
   ```bash
   git init   # optional but recommended
   claude
   ```
   When Claude asks *“Do you trust this folder?”* click **Yes**.

2. **Run the morning‑brief skill manually**
   In the Claude chat, type exactly:
   ```
   Run the morning-brief skill.
   ```

3. **Observe the output**
   - **First run**: Lists all TODOs found as "NEW" (since no locations are recorded yet)
   - The skill updates `progress.md` with today's report and the current TODO locations
   - **Second run** (immediately after): Should report "No changes in TODO locations since last run." because nothing changed
   - **After fixing a TODO**: If you resolve a TODO (by removing the line or deleting the comment), the next run will show it as "RESOLVED"
   - **After adding a new TODO**: The next run will show only the newly added TODO(s) as "NEW"

4. **Verify the spine is working**
   - Open `progress.md` after a few runs and confirm you see:
     - A "Known TODO Locations" section with current file:line pairs
     - A "Log" section with dated entries showing what changed each run
   - Ensure the same location never appears as "NEW" in two different entries

## 📅 Schedule It for Unattended Runs

To make your morning brief run automatically every day (even when your laptop is closed), use Claude Code's scheduling system:

### Create a Daily Schedule
In the Claude chat, type exactly:
```
/schedule every day at 9am, run the morning-brief skill
```
This creates a cloud-hosted Routine that runs on Anthropic's servers every morning at 9am, whether your laptop is open, asleep, or in your bag.

### Test the Schedule Without Waiting
You don't need to wait until 9am to verify it works. Use a one-off schedule first:
```
/schedule in 2 minutes, run the morning-brief skill
```
This runs the skill once after 2 minutes (one-offs don't count toward your daily limit) so you can test the scheduling mechanism immediately.

### View and Manage Your Schedules
- To see all your scheduled routines: `/schedule list`
- To modify a routine's timing: `/schedule update [routine-name] every day at 10am, run the morning-brief skill`
- To delete a routine: `/schedule delete [routine-name]`

### How Scheduled Runs Work
1. At the scheduled time (e.g., 9am), Anthropic's servers start a fresh Claude session
2. The session loads your `progress.md` (the spine) to see what was already reported
3. It runs the morning-brief skill to check for NEW and RESOLVED TODOs
4. It updates `progress.md` with the results
5. The session ends, but the `progress.md` file remains in your repo for the next run

> 💡 **Pro tip**: Since scheduled runs happen in fresh sessions, they **must** rely on external state (like your `progress.md` file) to remember what happened in previous runs. This is exactly why Concept 12 (spine/memory) is essential for unattended loops.

## What You Learned

- **Heartbeat:** `/schedule` creates recurring checks (unattended via cloud or in-session)
- **Body:** The loop scans for TODOs, compares locations against known state, and identifies real changes
- **Maker‑Checker:** The skill acts as both, but the spine (location tracking) provides objective truth about what's actually new/resolved
- **Spine:** `progress.md` survives between runs using two sections: known locations for comparison + log for history
- **Verification:** You can distinguish between no changes vs. actual new/resolved TODOs
- **Human gate:** You could extend this to flag complex TODOs for your review before marking them resolved

## Adapting for Your Own Tasks

Replace:
- The `src/` folder with any files you want to monitor
- The `find src/ -name "*.py" -exec grep -n "TODO" {} \;` command in the skill with whatever produces location-based data (e.g., `grep -n "ERROR" logs/` for error patterns, or `git log --oneline` for commit tracking)
- Keep the skill structure: load known state → gather current state with locations → compute diffs → report → update both known state and log

## Reset to Original State

If you want to start over with a clean tracking state (for example, to practice again or let someone else try), you can reset `progress.md` to its initial empty state:

```bash
echo -e '# Morning Brief — Progress Log\n\n## Known TODO Locations:\n\n## Log' > progress.md
```

This clears both the known locations and the log, letting you begin fresh with whatever TODO state exists in your source files.

---

Your Project 3 now demonstrates:
- **Concept 6:** unattented heartbeat (via `/schedule` or manual invocation)
- **Concept 12:** spine/memory between runs (the `progress.md` file with dual-purpose tracking)
- **Original implementation:** location-based TODO tracking that avoids superficial text-matching limitations
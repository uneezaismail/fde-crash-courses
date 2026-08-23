# Watch Loop Project

This project demonstrates how to create an in-session heartbeat loop using Claude Code's `/loop` command to monitor a long-running task and get notified when it completes—without needing to watch the terminal continuously.

## Overview

The exercise teaches **Concept 4: in-session heartbeat** by building a system where:
1. A background task runs independently (e.g., a script that takes several minutes)
2. A loop checks every minute for a completion flag file
3. When the flag appears with expected content, the loop reports completion and cancels itself
4. You can walk away and return later to see the notification

This proves unattended operation while preparing you for cloud-based scheduled loops (Concepts 6-7).

## Files in this Repository

- `watch_task.sh` – Example background task (sleeps 30 seconds then creates `completion.flag`)
- `completion.flag` – Flag file created by the background task when finished
- `HOW_TO_RUN.md` – Detailed step‑by‑step instructions for running the exercise
- `README.md` – This file

> **Note:** The background task and flag were already created when you started this exercise. If you want to repeat the experiment with a different duration, edit `watch_task.sh`.

## How to Run (for anyone)

1. **Start Claude Code in this folder**
   ```bash
   git init   # optional but recommended
   claude
   ```
   When Claude asks *“Do you trust this folder?”* → click **Yes**.

2. **(Optional) Adjust the background task duration**  
   Edit `watch_task.sh` and change the `sleep` value (seconds) to a longer period (e.g., 180 for 3 minutes) if you want a more realistic walk‑away test.

3. **Set up the watch loop**  
   In the Claude chat, type exactly:
   ```
   /loop 1m check if completion.flag exists and contains "TASK_DONE". If yes, say "Task finished!" and then cancel this loop.
   ```

4. **Verify the loop is active**  
   Run:
   ```
   Show my running loops
   ```
   You should see one job with schedule `*/1 * * * *` (every minute).

5. **Walk away test**  
   - Stop interacting with the terminal.
   - Do something else for at least the duration of the background task (plus a minute).
   - Do **not** check files, processes, or re‑run “show my running loops”.

6. **Check for results**  
   After waiting, return to Claude. You should see an unprompted message:
   ```
   Task finished!
   ```
   (Claude may also add a note about cancelling the loop.)

7. **Confirm clean shutdown**  
   Run `Show my running loops` again—it should return an empty list, indicating the loop cancelled itself.

8. **Cleanup (optional)**  
   In Claude you can remove the temporary files:
   ```
   Remove watch_task.sh and completion.flag
   ```
   Then exit Claude and delete the folder if desired.

## What You Learned

- **Heartbeat:** `/loop 1m` creates a recurring check while the Claude session is open.
- **Body:** The loop looks for observable proof (`completion.flag` with “TASK_DONE”).
- **Verification:** Walking away proves the loop works unattended.
- **Limitation:** The loop stops when you close the Claude session—preparing you for cloud‑based scheduled loops (next concepts).

## Adapting for Your Own Tasks

Replace:
- The background task script (`watch_task.sh`) with any long‑running command or script.
- The flag file name/content (update the `/loop` command accordingly).
- Keep the interval at `1m` (or adjust if needed, noting cron limitations).

---
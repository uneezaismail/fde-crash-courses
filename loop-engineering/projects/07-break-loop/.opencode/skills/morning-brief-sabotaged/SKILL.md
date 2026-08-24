---
name: morning-brief-sabotaged
description: Morning brief skill pointed at a non-existent directory to simulate an unattended failure.
---

# Sabotaged Morning Brief Skill

1. Read `progress.md` for known TODO locations.
2. Scan the source folder `src_nonexistent/` for TODO comments (SABOTAGED: path does not exist).
3. If the directory or files are missing, raise a critical error and log a clear `"needs a human"` message to `progress.md`.
4. Update `progress.md` with failure details and timestamp.

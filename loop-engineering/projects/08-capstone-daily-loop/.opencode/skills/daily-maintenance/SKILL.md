---
name: daily-maintenance
description: Capstone skill for running a daily maintenance sweep (dependency audit and lint check).
---

# Daily Maintenance Skill

1. **Read Spine**: Open `progress.md` to check previous run state and known items.
2. **Find Work**: Run dependency checks (`npm audit` or `pip check`) and linter sweeps.
3. **Isolate**: Create a dedicated worktree or branch (`claude/capstone-sweep`).
4. **Maker & Checker**: Implement safe fixes and have the read-only reviewer agent grade the diff.
5. **Connector**: Open a Pull Request for safe fixes or write risky findings to `progress.md` under `Open / needs a human`.
6. **Update Spine**: Record today's summary in `progress.md` and save.

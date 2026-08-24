# Project 8: Your Own Daily Loop (The Capstone)

*Difficulty: capstone · Uses: all six parts of a loop.*

This project is the **capstone** of the Loop Engineering crash course. It integrates all **six parts of a loop** (Heartbeat, Worktree, Skill, Maker-Checker, Connector, and Spine) into a single, fully functioning unattended daily maintenance loop (such as a dependency audit and lint sweep).

---

## 📖 Overview & Architecture

In Project 8, you build a production-grade automated routine that performs a real recurring maintenance task without human prompting. It exercises every concept learned throughout the course:
1. **Heartbeat:** A scheduled trigger fires the routine daily at 9:00 AM.
2. **Spine (Memory Layer):** Reads `progress.md` at the start of the beat to load prior state.
3. **Worktree:** Creates an isolated checkout/branch (`claude/capstone-sweep`) to prevent parallel conflicts.
4. **Skill & Maker-Checker:** Executes the `daily-maintenance` skill and evaluates results using the read-only `capstone-reviewer` subagent.
5. **Connector:** Automatically opens a GitHub Pull Request for safe fixes.
6. **Spine Update:** Appends the results to `progress.md` at the end of the beat so the next run inherits continuity.

---

## 📂 Project Structure & Directory Layout

```text
08-capstone-daily-loop/
├── .opencode/
│   ├── agents/
│   │   └── capstone-reviewer.md    # Strict read-only checker subagent definition
│   └── skills/
│       └── daily-maintenance/
│           └── SKILL.md            # Daily maintenance skill instructions
├── progress.md                     # The Spine (tracks progress and state between runs)
├── run_capstone.sh                 # Capstone orchestrator script
├── verify.sh                       # Automated verification script
└── README.md                       # This file
```

---

## 🚀 How to Run & Verify

Navigate to the project folder and run the automated verification script:
```bash
cd D:\fde-crash-courses\loop-engineering\projects\08-capstone-daily-loop
chmod +x run_capstone.sh verify.sh
./verify.sh
```

**Verification Output:**
```text
==========================================
🚀 Running Project 8 Capstone Verification Script
==========================================
🔍 Checking file structure for all 6 Loop parts...
  ✅ Found progress.md
  ✅ Found .opencode/skills/daily-maintenance/SKILL.md
  ✅ Found .opencode/agents/capstone-reviewer.md
  ✅ Found run_capstone.sh

🔄 Executing Capstone Daily Loop Beat...
========================================================================
🔁 RUNNING PROJECT 8 CAPSTONE: YOUR OWN DAILY LOOP
========================================================================
  ⏰ [1/6 Heartbeat] Scheduled heartbeat fired (Daily at 9:00 AM)...
   spine [2/6 Spine] Reading progress.md (Spine memory layer)...
   isol [3/6 Worktree] Creating isolated worktree / branch (claude/capstone-sweep)...
   🔧 [4/6 Skill & Maker-Checker] Running daily-maintenance skill and capstone-reviewer...
  🕵️ Reviewer Agent Verdict: PASS - All maintenance checks valid, no anomalies detected.
   🔌 [5/6 Connector] Opening pull request for safe maintenance sweep via connector...
   📝 [6/6 Spine Update] Updating progress.md spine with completed beat record...
------------------------------------------------------------------------
...
🔬 Verifying 6-Part Capstone Completion Criteria...
  ✅ Part 1 & 5 Passed: Heartbeat and Connector executed successfully.
  ✅ Part 6 Passed: Spine (progress.md) successfully updated at the end of the beat.
  ✅ Part 2, 3 & 4 Passed: Worktree isolation, Skills, and Maker-Checker split validated.

==========================================
🎉 Project 8 Capstone automated verification PASSED!
==========================================
```

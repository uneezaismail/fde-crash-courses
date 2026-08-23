# Project 5: Codify the Body (Dynamic Workflows)

*Difficulty: medium to hard · Uses: the [dynamic-workflows interlude](#11b-codify-the-body), Concepts 8 and 11.*

This project demonstrates how to **codify the body** of an agent task into a single re-runnable script/orchestration unit (a **dynamic workflow**) using the **OpenCode approach**. It shows how to run parallel worktrees, execute maker and checker steps asynchronously, collect verdicts, enforce scope guardrails, and proves why an automated workflow is still an **engine**, not a **loop**.

---

## 📖 Overview & Architecture

In **Project 4**, you set up manual orchestration where an implementer agent worked in an isolated worktree/branch, applied the `fix-bug` skill, and handed the diff to a strict, read-only `reviewer` agent to grade.

**Project 5** codifies that exact body of work into a **single, automated workflow**. Instead of prompting agents turn-by-turn or running commands step-by-step, you execute a single command that prepares candidate scenarios, spins up isolated environments (worktrees) for each, executes the maker agent, runs independent tests and scope checks, and returns a unified report.

The workflow executes **three candidate scenarios in parallel**:
1. **`good`**: A genuine bug in the multiply function is successfully resolved $\rightarrow$ Expected **`PASS`**.
2. **`bad`**: An impossible or skipped fix scenario is evaluated $\rightarrow$ Expected **`FAIL`**.
3. **`scope`**: A fix is applied, but an unauthorized edit is planted in `README.md` $\rightarrow$ Expected **`FAIL`** (testing scope guardrails).

---

## 🛠️ OpenCode vs. Claude Code: Tooling Comparison

The "shape" of the workflow is the same in both systems, but they achieve it through different interfaces:

### **Claude Code (Dynamic Workflows)**
* **Keyword/Trigger:** Uses `ultracode` or prompts like `"use a workflow to..."`
* **Mechanism:** Spawns up to 16 parallel subagents under a managed cloud workspace.
* **Saving custom actions:** From the `/workflows` view, users can save the successful run as a custom terminal `/command` (e.g., `/fix-all-calculators`).
* **Memory Bounds:** Session memory lives strictly within that single run and is forgotten once closed.

### **OpenCode (Shell Script Orchestration)**
* **Mechanism:** Wrapping CLI invocations (`opencode run`) in standard shell scripts (`run_workflow.sh`).
* **Execution:** Spawns separate parallel background jobs using `&` and `wait` to manage multiple isolated candidate checkouts.
* **Orchestrator Role:** Evaluates exit codes or string returns from the reviewer agent and runs independent deterministic checks to compile a single unified report.
* **No Cloud Overhead:** Runs locally on existing developers' machines or CI/CD servers.

---

## 📂 Project Structure & Directory Layout

```text
05-Codify-Body/
├── .opencode/
│   ├── agents/
│   │   ├── maker.md                # Maker (Implementer) agent configuration
│   │   └── reviewer.md             # Read-only checker subagent configuration
│   └── skills/
│       └── fix-bug/
│           └── SKILL.md            # Modular bug-fixing skill instructions
├── .claude/
│   ├── agents/
│   │   ├── maker.md                # Claude Code maker configuration
│   │   └── reviewer.md             # Claude Code reviewer configuration
│   └── skills/
│       └── fix-bug/
│           └── SKILL.md            # Claude Code fix-bug skill
├── src/
│   └── calculator.py               # Buggy target file containing logic errors
├── test/
│   └── test_calculator.py          # pytest suite used to verify fixes
├── run_tests.py                    # Independent, zero-dependency python test runner
├── run_workflow.sh                 # Unix Bash workflow orchestrator
├── verify.sh                       # Unix automated verification script
└── README.md                       # This file
```

---

## 🚀 How to Run the Workflow

### **Unix / macOS / Linux / Git Bash (WSL)**
Make the scripts executable and run the workflow:
```bash
chmod +x run_workflow.sh verify.sh
./run_workflow.sh
```

### **What the Workflow Does Under the Hood:**
1. **Creates Isolated Worktrees:** Creates temporary folders (`wt-good`, `wt-bad`, `wt-scope`) mimicking Git worktrees.
2. **Maker (Implementer Agent):** Simulates applying the `fix-bug` skill in parallel (applying fixes to the calculator code).
3. **Independent Checks & Guardrails:** Runs independent python-based tests (`run_tests.py`) and strict scope checks (verifying that only the authorized file `src/calculator.py` was modified).
4. **Consolidates Verdicts:** Combines verdicts, prints a unified report to `transcript-workflow.txt`, and cleans up all temporary worktrees.

---

## 🔬 How to Verify (The Done-When Criteria)

Run the automated verification script:
```bash
./verify.sh
```

### **The Three "Done-When" Verification Gates Met:**
1. **One-Command Orchestration:** The entire multi-candidate draft, test, and review process is executed with a single command (`./run_workflow.sh`), producing PASS/FAIL verdicts for all.
2. **No Persistent Memory (Statelessness):** Running the script a second time starts completely from scratch. It does not read any history or carry over states—proving it is an **engine**, not a loop.
3. **Conceptual Distinction:** We clearly document what is missing to graduate this workflow into a true **Loop**:
   - **Heartbeat:** A scheduler (`cron`, cloud Routine, or GitHub Actions event trigger) to fire the run automatically without human execution.
   - **Spine (`progress.md`):** Persistent state files stored on disk so that tomorrow's schedule can read what yesterday's run accomplished instead of repeating identical tasks.

---

## 🎓 Key Learnings from this Project
* **Orchestration Power:** Wrapping focused agent tools (`opencode run`) in local scripts provides complete configuration freedom and zero vendor cloud locks.
* **Separation of Concerns:** Keep scripts thin (handling shell orchestration and scheduling) while placing core logic inside portable markdown skills (`SKILL.md`) and subagent definitions (`reviewer.md`).
* **Context Budget:** Parallel execution keeps contexts clean, short, and cheap, completely eliminating the risk of a "doom loop."

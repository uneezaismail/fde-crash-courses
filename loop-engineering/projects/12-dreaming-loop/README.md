# Project 12: Build a Dreaming Loop (TypeScript Audit)

This project demonstrates how to build an out-of-band meta-improvement loop (a "Dreaming Loop") that reads the execution history of your primary loops, identifies recurring failures, and drafts rule and skill updates as Pull Requests—without ever committing directly to `main`.

## Overview

The exercise teaches key capstone concepts (**Concept 12: spine & improvement loop**, **Concept 11: maker-checker**, **Concept 6: schedule**, **Part 5: human gate**) by building a system where:
1. **Primary Log Inspection (`progress.md`):** The dreaming loop reads the dated execution history left by primary loops. In this project, the primary loop experiences recurring Out Of Memory (OOM) failures during compilation (`tsc exited with code 137`).
2. **Meta-State Tracking (`dreaming-state.md`):** Tracks `Last Analyzed Timestamp` so analysis is incremental.
3. **Evidence-Based Proposal Generation (`PROPOSAL_PR.md`):** Searches for recurring failure patterns (>1 occurrence), cites exact log dates and evidence, and drafts minimal rule additions (increasing old space size) and obsolete rule deletions.
4. **Human Gate via PR:** The proposed changes are written to a draft PR file (`PROPOSAL_PR.md`) instead of modifying `CLAUDE.md` directly. A human must review and merge the PR.
5. **Automated Verification:** A validation script (`verify.sh` / `verify.ps1`) confirms that all three "Done when" conditions from the course pass.

This proves that self-improving loops must rely on real cited log evidence and strict human PR approval rather than guessing or making unreviewed direct edits.

## Files in this Repository

- `CLAUDE.md` – Operating rules file containing active rules and an obsolete rule
- `progress.md` – Primary loop history spine containing 1+ week of dated entries with a planted recurring OOM compilation failure
- `dreaming-state.md` – Meta-state tracking last analyzed timestamp and total proposal count
- `run_dreaming_loop.sh` – Bash script executing the dreaming meta-loop pass
- `run_dreaming_loop.ps1` – PowerShell script executing the dreaming meta-loop pass
- `verify.sh` – Automated Bash verification script
- `verify.ps1` – Automated PowerShell verification script
- `README.md` – This file

## How to Run (for anyone)

1. **Navigate to this folder**
   ```bash
   cd "D:/loop-engeneering/projects/12-dreaming-loop"
   ```

2. **Make scripts executable (Linux / WSL / Git Bash)**
   ```bash
   chmod +x run_dreaming_loop.sh verify.sh
   ```

3. **Run the Dreaming Loop**
   - **Using Bash:**
     ```bash
     ./run_dreaming_loop.sh
     ```
   - **Using PowerShell:**
     ```powershell
     powershell -ExecutionPolicy Bypass ./run_dreaming_loop.ps1
     ```
   - **Expected Outcome:** Analyzes `progress.md`, finds recurring timeouts, and drafts `PROPOSAL_PR.md` citing evidence. Leaves `CLAUDE.md` unchanged pending human PR review.

4. **Run Automated Verification**
   - **Using Bash:**
     ```bash
     ./verify.sh
     ```
   - **Using PowerShell:**
     ```powershell
     powershell -ExecutionPolicy Bypass ./verify.ps1
     ```
   - ✅ **CORRECT OUTCOME:** Outputs `🎉 Project 12 automated verification PASSED!` confirming all 3 "Done when" criteria.

## What You Learned

- **Out-of-Band Dreaming:** Memory consolidation and rule refinement happen asynchronously (e.g. weekly), keeping primary execution loops fast and focused.
- **Evidence Over Speculation:** Rule changes must trace directly to cited log entries (`progress.md`). Guesses deteriorate system behavior.
- **Rule Pruning:** Dreaming loops should delete obsolete or unused rules alongside adding new ones to keep context windows clean.
- **Human Gate for Rules:** Autonomous agents must never overwrite their own core operating rules directly; changes must be submitted as PRs for human approval.

## Adapting for Your Own Tasks

When implementing dreaming loops in production:
- Trigger the dreaming loop on a weekly schedule (e.g., GitHub Actions `on: schedule` or cron).
- Have the loop create a `claude/dreaming-proposal` branch and open a PR.
- Require PR review before merging any changes to `CLAUDE.md` or `.claude/rules.md`.

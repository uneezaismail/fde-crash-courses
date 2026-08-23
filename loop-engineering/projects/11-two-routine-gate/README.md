# Project 11: Build the Two-Routine Gate

This project demonstrates how to build and verify a **two-routine human approval gate** using the OpenCode / GitHub Actions equivalent approach. It shows how to split automated actions into a drafting phase and an execution phase, linked together by an explicit human decision.

## Overview

The exercise teaches **Concept A3 (API trigger)** and **Concept A4 (two-routine gate)** by building a system where:
1. **Routine A (The Drafter):** Runs automatically (on a schedule or event), writes proposed changes to a `DRAFT.md` file, updates the observability spine (`progress.md`) state to `PENDING_APPROVAL`, and exits cleanly.
2. **A Human Decides:** You review the generated `DRAFT.md` and the status in `progress.md`. If satisfied, you approve the release by firing Routine B.
3. **Routine B (The Executor):** Has an API trigger requiring a secure bearer token (`APPROVE_TOKEN`). 
   - If executed **without** the token or with an invalid token, it refuses to perform the action and logs `task_status=FAIL` while keeping `infrastructure_status=GREEN`.
   - If executed **with** the valid token, it promotes `DRAFT.md` to `PRODUCTION.md`, updates the observability spine state to `COMPLETED`, and logs `task_status=PASS`.
4. **Automated Verification:** A validation script (`verify.sh`) exercises the entire gate lifecycle and validates that permissions, states, and transcripts are correctly managed.

This ensures that high-risk actions (e.g., merging to main, deploying to production, transferring funds) are never performed autonomously by an agent without an explicit human checkpoint.

## Files in this Repository

- `run_drafter.sh` – Simulates Routine A (the Drafter) by creating a draft and updating status to `PENDING_APPROVAL`
- `run_executor.sh` – Simulates Routine B (the Executor) requiring a secure bearer token to promote draft to production
- `verify.sh` – Automated test script verifying the entire approval gate and permissions lifecycle
- `progress.md` – Observability spine tracking the approval states (`INITIAL` → `PENDING_APPROVAL` → `COMPLETED`)
- `README.md` – This file

## How to Run (for anyone)

1. **Navigate to this folder**
   ```bash
   cd "D:/loop-engeneering/projects/11-two-routine-gate"
   ```

2. **Make scripts executable (Linux / WSL / Git Bash)**
   ```bash
   chmod +x run_drafter.sh run_executor.sh verify.sh
   ```

3. **Step 1: Run the Drafter (Routine A)**
   ```bash
   ./run_drafter.sh
   ```
   - **Expected Outcome:** `DRAFT.md` is created. `progress.md` state changes to `PENDING_APPROVAL`.
   - **Transcript Created:** `transcript-drafter.txt`

4. **Step 2: Try to Run the Executor Without Approval (Routine B)**
   ```bash
   ./run_executor.sh
   ```
   - **Expected Outcome:** Fails with `missing approval token`.
   - **Transcript Created:** `transcript-executor.txt` (`task_status=FAIL`, `infrastructure_status=GREEN`)

5. **Step 3: Approve and Run the Executor (Routine B)**
   ```bash
   export APPROVE_TOKEN="secure_approval_bearer_token_123"
   ./run_executor.sh
   unset APPROVE_TOKEN
   ```
   - **Expected Outcome:** `DRAFT.md` is promoted to `PRODUCTION.md`. `progress.md` state changes to `COMPLETED`.
   - **Transcript Updated:** `transcript-executor.txt` (`task_status=PASS`, `infrastructure_status=GREEN`)

6. **Step 4: Run Automated Verification**
   ```bash
   ./verify.sh
   ```
   - ✅ **CORRECT OUTCOME:** Outputs `🎉 Project 11 automated verification PASSED!` showing correct state transitions and unauthorized block handling.

## What You Learned

- **No Mid-Run Approvals:** AI routines run from start to finish without pausing. High-risk decisions must be designed as a gate *between* two routines, rather than inside one.
- **API Trigger Tokens:** API-triggered routines rely on secure bearer tokens. Senders must authenticate their requests to trigger execution.
- **The Drafter-Executor Pattern:** Routine A drafts the work and places it in a reviewable space (draft branches, PRs, or draft files). Routine B is fired only after human approval is granted.
- **observability Spine:** Progress logs (`progress.md`) keep the shared state between separate asynchronous routine runs.

## Adapting for Your Own Tasks

When implementing human gates in production:
- Write Routine A to push its draft to a `claude/` branch and open a Draft PR.
- Use GitHub Actions repository secrets to secure Routine B's API trigger token.
- Only trigger the API call to Routine B (`curl` POST to `/fire`) once you or a designated checker merges the PR or clicks a custom approval button.

# Project 9: Rehearse a Routine for Free

This project demonstrates how to test and prove a routine's prompt using one-off test runs before committing it to a schedule, proving why a **Green (Exit Code 0)** CI/platform status does not guarantee task success.

## Overview

The exercise teaches key concepts of **routine rehearsal and observability (Concepts A1, A3, A5)** by building a system where:
1. **Run 1 (Normal Execution - Success):** The routine reads an existing input file (`input.txt`), counts its lines, and writes `output_success.txt`. The task succeeds (`output_success.txt` is created with the correct line count) and the execution status is **GREEN**.
2. **Run 2 (Forced Failure - Task Failure):** The routine attempts to read a non-existent file (`non_existent.txt`). The task fails (no `output_failure.txt` is created and an error is reported in transcript output), yet the execution status remains **GREEN**.
3. **The Core Lesson:** Green status means only that the platform session or runner finished without an infrastructure crash. True task outcome must be verified by inspecting transcript logs and generated output artifacts.

## Files in this Repository

- `input.txt` – Sample target file containing 5 lines of text
- `opencode_success.sh` – Script running the one-off rehearsal for the successful task scenario
- `opencode_failure.sh` – Script running the one-off rehearsal for the failing task scenario
- `output_success.txt` – Generated output artifact verifying task success
- `README.md` – This file

## How to Run (for anyone)

1. **Navigate to this folder**
   ```bash
   cd "D:/loop-engeneering/projects/09-Rehearse-routine"
   ```

2. **Make scripts executable (Linux / WSL / Git Bash)**
   ```bash
   chmod +x opencode_success.sh opencode_failure.sh
   ```

3. **Run the Success Rehearsal**
   ```bash
   ./opencode_success.sh
   ```
   - **Expected Outcome:** `opencode` reads `input.txt` (5 lines) and creates `output_success.txt` containing `The file input.txt has 5 lines`.
   - **Status:** **GREEN (Exit Code 0)**

4. **Run the Failure Rehearsal**
   ```bash
   ./opencode_failure.sh
   ```
   - **Expected Outcome:** `opencode` attempts to read `non_existent.txt`, reports an error in the transcript, and does NOT create `output_failure.txt`.
   - **Status:** **GREEN (Exit Code 0)**

5. **Compare the Outcomes**
   - Check `output_success.txt` → File exists with correct line count (Task Succeeded).
   - Check `output_failure.txt` → File does NOT exist (Task Failed).
   - Both runs reported a **GREEN** exit code from the platform shell runner.

## What You Learned

- **Rehearsal Before Schedule:** Always prove a prompt with one-off test runs before committing it to a recurring schedule.
- **Green Status vs. Task Success:** A green status (exit code 0) means the runner process finished without an infrastructure crash. It does **not** prove that the internal task logic succeeded.
- **Artifact Verification:** Always verify task completion by checking generated output files or transcript logs rather than relying solely on job status indicators.

## Adapting for Your Own Tasks

When designing new routines:
- Always run a manual one-off rehearsal first (`opencode run` or one-off trigger).
- Test both positive (happy path) and negative (error handling) scenarios.
- Require observable output artifacts (e.g., summary branch, output log file) so checkers can independently verify task success.

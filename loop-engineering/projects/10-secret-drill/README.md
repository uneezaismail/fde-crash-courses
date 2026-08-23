# Project 10: The Secrets Drill

This project demonstrates how to properly manage credentials and secrets in automated AI routines, proving why git-ignored `.env` files fail in fresh cloud execution environments and how environment variable injection ensures reliable, secure runs.

## Overview

The exercise teaches key concepts of **unattended routines and secret management** by building a system where:
1. **First Run (Intentional Failure):** A routine attempts to read credentials from a `.env` file. Because `.env` is git-ignored, a fresh cloud clone lacks this file, resulting in a task failure (`task_status=FAIL`) even though the infrastructure runner exits cleanly (`infrastructure_status=GREEN`).
2. **Second Run (Correct Success):** The secret is injected via a process environment variable (`API_KEY`). The routine reads credentials directly from the environment, producing `task_status=PASS` with token values redacted (`token_output=redacted`).
3. **Observability Spine:** Both runs write structured key-value transcripts to record evidence and diagnosis.
4. **Automated Verification:** A verification script (`verify.sh`) validates transcript outputs, proving both scenarios work as expected.

This proves that **Green (Exit Code 0)** only means the runner finished without infrastructure crashes, while true task success depends on inspecting transcript artifacts and properly injected secrets.

## Files in this Repository

- `.gitignore` – Configured to ignore `.env` so secrets are never committed to version control
- `.env` – Local dummy credentials file (simulates local development setup)
- `run_failure.sh` – Script simulating the failure scenario (temporarily removes `.env` to mimic a fresh clone)
- `run_success.sh` – Script simulating the success scenario (injects `API_KEY` via environment variable)
- `verify.sh` – Automated test script that runs both scenarios and verifies transcript evidence
- `progress.md` – Observability spine logging run outcomes and verification results
- `README.md` – This file

## How to Run (for anyone)

1. **Navigate to this folder**
   ```bash
   cd "D:/loop-engeneering/projects/10-secret-drill"
   ```

2. **Make scripts executable (Linux / WSL / Git Bash)**
   ```bash
   chmod +x run_failure.sh run_success.sh verify.sh
   ```

3. **Run the Failure Scenario**
   ```bash
   ./run_failure.sh
   ```
   - **Expected Output:** `infrastructure_status=GREEN`, `task_status=FAIL`, `task_evidence=missing file: .env`
   - **Transcript Created:** `transcript-dotenv.txt`

4. **Run the Success Scenario**
   ```bash
   ./run_success.sh
   ```
   - **Expected Output:** `infrastructure_status=GREEN`, `task_status=PASS`, `task_evidence=read API_KEY from environment`
   - **Transcript Created:** `transcript-environment.txt`

5. **Run Automated Verification**
   ```bash
   ./verify.sh
   ```
   - ✅ **CORRECT OUTCOME:** Outputs `🎉 Project 10 automated verification PASSED!` confirming both transcripts match expected infrastructure and task statuses.

## What You Learned

- **Git-Ignored Files:** Git-ignored files (`.env`) never reach fresh cloud clones (such as GitHub Actions or cloud runners). Routines relying on local `.env` files will fail in CI/CD.
- **Green Status vs. Task Status:** Shell exit code 0 (`infrastructure_status=GREEN`) proves only that the process completed without a crash. True task outcome (`task_status=PASS` / `FAIL`) must be read from transcript evidence.
- **Environment Variable Injection:** Credentials must be passed into automated routines via process environment variables and explicitly referenced in prompts.
- **Secret Redaction:** Automated scripts and transcripts must redact actual token values (`token_output=redacted`) to prevent secret leakage.

## Adapting for Your Own Tasks

When moving routines to cloud automations or CI/CD pipelines:
- Store secrets in repository settings / secret managers (e.g., GitHub Repository Secrets), never in `.env`.
- Access credentials as environment variables in your runner environment.
- Explicitly tell your prompt: `"Credentials are available as environment variables; do not look for a .env file."`
- Always verify transcripts, not just exit codes, when auditing routine runs.

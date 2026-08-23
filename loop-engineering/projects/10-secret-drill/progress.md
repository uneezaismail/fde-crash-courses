# Project 10 Observability Spine

## Transcript Log

### Run 1: Failure Scenario (dotenv mode)
- **Infrastructure Status:** `GREEN`
- **Task Status:** `FAIL`
- **Task Evidence:** `missing file: .env`
- **Diagnosis:** Git-ignored `.env` files never reach a fresh cloud clone.

### Run 2: Success Scenario (environment mode)
- **Infrastructure Status:** `GREEN`
- **Task Status:** `PASS`
- **Task Evidence:** Read `API_KEY` directly from process environment (`length=35`).
- **Security Check:** Secret output redacted; secret value never printed.

### Automated Verification
- Ran `./verify.sh`: **PASSED**

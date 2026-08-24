# Project 7: Break It on Purpose (Observability & Cost Control)

*Difficulty: medium · Uses: Observability, Concept 13 (cost), Concept 14.*

This project demonstrates how to **sabotage an unattended loop** deliberately, calculate its monthly token cost, and **diagnose the failure using only what the loop left behind in its spine (`progress.md`) and logs**—without replaying the full run.

---

## 📖 Overview & Architecture

When running loops unattended (overnight or on a schedule), silent failures are the worst hazard. If a loop breaks and says nothing, tokens are wasted and work halts unnoticed. 

**Project 7** teaches you to build robust observability by:
1. **Calculating Token Cost (Concept 13):** Multiplying token consumption per beat by your cadence to determine monthly expenses.
2. **Failing Loudly:** Ensuring that when an unattended beat hits an unrecoverable error, it never fails silently.
3. **The Spine as a Diagnosis Log:** Recording failure timestamps, exact error causes, and explicit `"needs a human"` notes inside `progress.md` so you can diagnose issues from disk alone.

---

## 📂 Project Structure & Directory Layout

```text
07-break-loop/
├── .opencode/
│   └── skills/
│       └── morning-brief-sabotaged/
│           └── SKILL.md            # Sabotaged skill pointing to non-existent folder
├── progress.md                     # The Spine (tracks known state + failure escalation logs)
├── run_break_loop.sh               # Simulated scheduled runner executing the sabotaged beat
├── verify.sh                       # Automated verification script
└── README.md                       # This file
```

---

## 🚀 How to Run & Verify

Navigate to the project folder and run the automated verification script:
```bash
cd D:\fde-crash-courses\loop-engineering\projects\07-break-loop
chmod +x run_break_loop.sh verify.sh
./verify.sh
```

### **What Happens During Execution:**
1. **Cost Calculation:** Computes the estimated monthly token expenditure based on cadence.
2. **Sabotaged Execution:** Fires a scheduled loop beat configured with a broken path (`src_nonexistent`).
3. **Loud Failure & Escalation:** The loop catches the error, refuses to fail silently, and appends a detailed diagnostic entry + `"needs a human"` note to `progress.md`.
4. **Spine Diagnosis:** `verify.sh` successfully diagnoses the exact failure point by reading `progress.md` alone.

---

## 🔬 How to Verify (The Done-When Criteria)
1. **Diagnosed from Spine Alone:** You can state what failed and when simply by inspecting `progress.md`.
2. **No Silent Failures:** The loop left an explicit `"needs a human"` note.
3. **Cost Awareness:** The monthly token expenditure at the current cadence is recorded.

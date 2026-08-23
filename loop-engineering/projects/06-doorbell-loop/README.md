# Project 6: The Doorbell Loop (Production GitHub Integration)

*Difficulty: medium · Uses: Concept 7 (event-driven), Concept 10 (connectors).*

This project contains both the **local simulator** (for instant offline verification) and the **official GitHub Actions workflow** (`.github/workflows/project-06-opencode-review.yml`) to make the doorbell loop work live on GitHub.

---

## 📂 Project Structure & Layout

```text
06-doorbell-loop/
├── .opencode/
│   ├── agents/
│   │   └── pr-reviewer.md          # Read-only PR reviewer agent
│   └── skills/
│       └── doorbell-review/
│           └── SKILL.md            # Pull request review skill instructions
├── src/
│   └── calculator.py               # Target module
├── test/
│   └── test_calculator.py          # pytest suite
├── run_tests.py                    # Independent Python test runner
├── run_doorbell.sh                 # Local event-driven simulator script
├── verify.sh                       # Local automated verification script
├── PLANT_BUG_GUIDE.md              # Guide for testing live on GitHub
└── README.md                       # This file

root-level:
└── .github/
    └── workflows/
        └── project-06-opencode-review.yml  # Live GitHub Actions trigger for Event-Driven loop
```

---

## 🚀 How to Run Local Verification

To test the event-driven reaction locally:
```bash
cd D:\fde-crash-courses\loop-engineering\projects\06-doorbell-loop
chmod +x run_doorbell.sh verify.sh
./verify.sh
```

---

## 🌐 How to Make It Live on GitHub (Real Production Workflow)

To connect this project to real GitHub pull requests:
1. **Push your repository** to GitHub.
2. **Add Repository Secrets:** Go to your GitHub repository settings under **Secrets and variables → Actions**, and add:
   * `ANTHROPIC_API_KEY`: Your Anthropic API key.
3. **Open a Pull Request:** 
   * Create a new branch: `git checkout -b feature/test-bug`
   * Edit `src/calculator.py` to break a test.
   * Push and open a Pull Request.
4. **The Event Heartbeat Fires:** The `project-06-opencode-review` GitHub Action will automatically trigger on the `pull_request` event (`opened` / `synchronize`), run the reviewer agent, and post a review comment on your PR with **zero typed prompts**.

---
name: plant-bug
description: Plant a deliberate bug in src/calculator.py to test the doorbell loop reviewer.
---

# Plant Bug Script / Instruction

To test your live GitHub doorbell loop:
1. Create a new branch: `git checkout -b feature/test-bug`
2. Introduce an off-by-one error or modify `src/calculator.py` so tests fail.
3. Commit and push the branch: `git push origin feature/test-bug`
4. Open a Pull Request on GitHub.
5. Watch the `project-06-opencode-review` GitHub Action fire automatically on the `pull_request` event and post an unprompted review comment!

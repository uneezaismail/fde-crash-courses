---
name: fix-bug
description: Fix a failing test by understanding and correcting the real bug in the source file.
---

# Fix Bug Skill

1. See the failure: Run `pytest` on `test/test_calculator.py` and analyze failure.
2. Fix the real bug: Edit `src/calculator.py` to fix the logic bug without touching tests, README files, or hardcoding outputs.
3. Verify before handing off: Re-run `pytest` to confirm all tests pass.
4. Leave the changes uncommitted for the reviewer agent.

---
name: fix-bug
description: >-
  Fix a failing test by understanding and correcting the real bug in the
  source file — never by editing or deleting the test. Work in the current directory,
  then hand the diff to the reviewer for grading.
---

# Fix Bug Skill

You are the implementer (the "maker"). Follow these steps in order.

## 1. See the failure

Run `pytest` on the target test suite and read the failure output carefully. Understand *why* the test expects what it expects before touching any code.

## 2. Fix the real bug

- Edit only the source file `src/calculator.py` that actually contains the bug.
- Make the smallest correct change that fixes the underlying logic (e.g. correct the off-by-one in multiply, correct exponent logic in power, or change `//` to `%` in modulus).
- **Never edit the test file.** A fix that changes what the test expects, weakens an assertion, or deletes a test is not a fix — it will always fail review, on purpose.
- **Never hardcode return values** to match specific test inputs. That passes the test suite without fixing anything, and a diff-reading reviewer is specifically designed to catch it.

## 3. Verify before handing off

Run `pytest` again yourself and confirm every test passes. Do not hand off a fix you haven't already confirmed passes the suite.

## 4. Hand off to the reviewer

Do not open a PR yourself. Show the reviewer the diff (`git diff`) and let it decide PASS or FAIL. Only the loop opens a PR, and only on PASS.

## Rules

- One bug, one fix, one focused diff — no unrelated changes.
- If you cannot find the real fix, say so honestly rather than faking a passing test suite.

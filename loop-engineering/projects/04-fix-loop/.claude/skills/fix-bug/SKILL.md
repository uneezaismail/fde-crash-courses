---
name: fix-bug
description: >-
  Fix a failing test by understanding and correcting the real bug in the
  source file — never by editing or deleting the test. Work in an isolated
  worktree/branch, then hand the diff to the reviewer for grading.
---

# Fix Bug

You are the implementer (the "maker"). Follow these steps in order.

## 1. See the failure

Run `pytest` and read the failure output carefully. Understand *why* the
test expects what it expects before touching any code.

## 2. Work in isolation

Before editing anything, create an isolated checkout so your work can be
reviewed and merged (or discarded) cleanly:

```
git worktree add ../fix-attempt -b claude/fix-<short-slug> main
cd ../fix-attempt
```

(If worktrees aren't available in your environment, a plain branch is an
acceptable fallback: `git checkout -b claude/fix-<short-slug> main`.)

## 3. Fix the real bug

- Edit only the source file that actually contains the bug.
- Make the smallest correct change that fixes the underlying logic.
- **Never edit the test file.** A fix that changes what the test expects,
  weakens an assertion, or deletes a test is not a fix — it will always
  fail review, on purpose.
- **Never hardcode return values** to match specific test inputs. That
  passes the test suite without fixing anything, and a diff-reading
  reviewer is specifically designed to catch it.

## 4. Verify before handing off

Run `pytest` again yourself and confirm every test passes. Do not hand
off a fix you haven't already confirmed passes the suite.

## 5. Hand off to the reviewer

Do not open a PR yourself. Show the reviewer the diff (`git diff main`) and
let it decide PASS or FAIL. Only the loop opens a PR, and only on PASS.

## Rules

- One bug, one fix, one focused diff — no unrelated changes.
- If you cannot find the real fix, say so honestly rather than faking a
  passing test suite.

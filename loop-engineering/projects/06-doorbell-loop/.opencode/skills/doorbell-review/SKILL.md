---
name: doorbell-review
description: Automatically reviews a pull request event, runs tests, and invokes the pr-reviewer agent.
---

# Doorbell Review Skill

When triggered by a pull request event (opened, synchronized, or reopened):
1. Fetch the pull request diff and details using GitHub CLI (`gh pr diff`).
2. Run `pytest` to observe test failures or successes.
3. Invoke the `@pr-reviewer` agent to grade the PR changes.
4. Post the reviewer's PASS/FAIL verdict as a comment on the pull request (`gh pr comment`).

# Doorbell Notifier

When a pull request is detected:
1. Read the PR title and number from the environment variable `PR_INFO`.
2. Fetch the diff: `gh pr view $PR_NUMBER --diff`.
3. Run the test suite: `npm test`.
4. If tests pass, post a comment: `gh pr comment $PR_NUMBER --body "✅ All checks passed"`.
5. If tests fail, post a comment with the failure summary.
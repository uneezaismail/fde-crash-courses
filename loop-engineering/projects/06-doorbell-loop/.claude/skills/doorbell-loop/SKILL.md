---name: doorbell-loop
description: Reviews pull requests for planted bugs and quality issues. Designed for Project 6: The Doorbell Loop.
--- 
# Doorbell Loop Skill

This skill implements the core functionality for Project 6: The Doorbell Loop from the Loop Engineering crash course.

## Purpose
To automatically review pull requests and detect whether they properly address planted bugs or introduce new issues.

## How It Works
When invoked (typically via a GitHub pull-request triggered Routine), this skill:

1. **Gets PR Information**: Uses GitHub CLI to fetch the PR title, number, and description
2. **Examines Changes**: Reviews the actual code changes in the pull request
3. **Runs Tests**: Executes the test suite to verify the changes work correctly
4. **Checks for Specific Issues**: Looks for common bug patterns like:
   - Off-by-one errors
   - Improper exception handling
   - Logic errors in mathematical functions
   - Security vulnerabilities
5. **Provides Feedback**: Returns PASS with verification details or FAIL with specific reasons

## Implementation Notes
This skill is designed to work with:
- GitHub CLI (`gh`) for PR operations
- Standard test runners (pytest, npm test, etc.)
- The buggy calculator.py implementation found in the 05-clarify-the-body project

## Expected Behavior
- **PASS**: When the PR correctly fixes all identified issues without introducing new problems
- **FAIL**: When the PR misses bugs, introduces new issues, or doesn't properly solve the problems

The skill should be invoked by a Claude Code Routine configured with a GitHub pull-request trigger.
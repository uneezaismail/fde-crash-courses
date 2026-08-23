# Project 2: Make the Tests Pass, Then Stop

This project demonstrates how to create a conditional loop (run-until-done) using Claude Code's `/goal` command that continues working until tests pass, letting the test runner (command) decide when the work is done—not the agent.

## Overview

The exercise teaches **Concept 5: conditional loop (run-until-done)** combined with **Concept 11: maker-checker** by building a system where:
1. A loop keeps attempting to fix code until tests pass
2. The test runner (command), not the agent, decides when work is complete
3. A limit prevents infinite looping if the condition can't be met
4. You verify that the loop stopped due to actual success, not just hitting the cap

This proves conditional looping with proper maker-checker separation while preparing you for combining loop concepts in later projects.

## Files in this Repository

- `algorithms.py` – Python module with three functions containing deliberate bugs
- `test_algorithms.py` – pytest tests that currently fail due to those bugs
- `README.md` – This file

> **Note:** The background task and flag were already created when you started this exercise. If you want to repeat the experiment with different bugs or functions, edit `algorithms.py` and `test_algorithms.py`.

## How to Run (for anyone)

1. **Start Claude Code in this folder**
   ```bash
   git init   # optional but recommended
   claude
   ```
   When Claude asks *“Do you trust this folder?”* → click **Yes**.

2. **Set the conditional loop with limit**
   In the Claude chat, type exactly:
   ```
   /goal Run pytest on test_algorithms.py and all tests pass OR stop after 6 attempts
   ```

3. **Let Claude work**
   - Claude will:
     1. Read the failing tests
     2. Attempt to fix the code in `algorithms.py`
     3. Run the tests as evidence for the checker
     4. Continue trying until tests pass OR limit reached
     5. Stop when the test runner (command) confirms success

4. **Verify completion**
   - ✅ **CORRECT OUTCOME:** The loop stops because the tests actually passed (exit code 0), **NOT** because it hit the attempt limit.
   - ❌ **IF IT KEEPS HITTING THE CAP:** Your stop condition or prompt needs work - the tests should be passing before reaching the limit.

5. **Confirm clean termination**
   After completion, you should see Claude's output indicating the goal was achieved and the session will auto-clear.

## What You Learned

- **Heartbeat:** `/goal` creates a conditional loop that runs until a specific condition becomes true.
- **Body:** The loop attempts to fix code → runs tests (providing observable evidence for the checker).
- **Maker-Checker:** The agent writes code, but the test runner (command) decides when the work is done.
- **Verification:** You can distinguish between success-based stopping vs limit-based stopping.
- **Limit importance:** Prevents infinite loops when the condition can't be met, protecting against runaway token usage.
- **Preparation:** Gets you ready for Concepts 6-7 (scheduled loops) where you'll combine different heartbeat types.

## Adapting for Your Own Tasks

Replace:
- The `algorithms.py` module with any code you want to iteratively improve
- The `test_algorithms.py` file with any test suite that defines when your code is "done"
- Keep the `/goal` command structure: `[test command] and all tests pass OR stop after [reasonable number] attempts`

## Reset to Original Buggy State

If you want to start over with the original broken code (for example, to practice again or let someone else try), you can reset the files to their initial buggy state:

### algorithms.py (original buggy version)
```python
def fibonacci(n):
    """Return the nth Fibonacci number."""
    if n <= 0:
        return 0
    elif n == 1:
        return 0  # BUG: should return 1
    else:
        return fibonacci(n-1) + fibonacci(n-2)


def is_leap_year(year):
    """Return True if year is a leap year, False otherwise."""
    # BUG: Missing the "except if divisible by 100" rule
    if year % 4 == 0:
        return True
    else:
        return False


def sum_list(numbers):
    """Return the sum of all numbers in the list."""
    total = 1  # BUG: should start at 0
    for num in numbers:
        total += num
    return total
```

### test_algorithms.py (original test file)
```python
import algorithms

def test_fibonacci():
    """Test Fibonacci function."""
    assert algorithms.fibonacci(0) == 0
    assert algorithms.fibonacci(1) == 1  # This will fail due to bug
    assert algorithms.fibonacci(2) == 1
    assert algorithms.fibonacci(3) == 2
    assert algorithms.fibonacci(4) == 3
    assert algorithms.fibonacci(5) == 5


def test_is_leap_year():
    """Test leap year function."""
    # These should be leap years
    assert algorithms.is_leap_year(2000) == True  # divisible by 400
    assert algorithms.is_leap_year(2004) == True  # divisible by 4, not 100
    assert algorithms.is_leap_year(2020) == True  # divisible by 4, not 100

    # These should NOT be leap years
    assert algorithms.is_leap_year(1900) == False  # divisible by 100 but not 400 - BUG: will return True
    assert algorithms.is_leap_year(2100) == False  # divisible by 100 but not 400 - BUG: will return True
    assert algorithms.is_leap_year(2019) == False  # not divisible by 4
    assert algorithms.is_leap_year(2021) == False  # not divisible by 4


def test_sum_list():
    """Test sum list function."""
    assert algorithms.sum_list([]) == 0  # BUG: will return 1
    assert algorithms.sum_list([1, 2, 3]) == 6  # BUG: will return 7
    assert algorithms.sum_list([-1, 0, 1]) == 0  # BUG: will return 1
    assert algorithms.sum_list([10]) == 10  # BUG: will return 11
```

You can copy-paste these blocks over the current files to reset.

---
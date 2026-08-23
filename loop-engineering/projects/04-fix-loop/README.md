# Project 4 — A Fix Loop With a Real Checker

*Difficulty: medium to hard · Uses: Concept 8 (worktree), Concept 9 (skill), Concept 11 (maker-checker).*

An implementer drafts a fix in its own checkout, a separate reviewer grades it, and only a `PASS` opens a PR.

## Overview

This project teaches **Concept 11: maker-checker split** combined with **Concept 8: worktree isolation** and **Concept 9: skills** by building a system where:
1. An implementer agent attempts to fix code following a prescribed skill
2. A separate reviewer agent independently verifies the fix by examining actual code changes (not just test results)
3. The reviewer acts as a "real checker" that catches gaming of the test suite (e.g., hardcoded values that make tests pass without fixing the underlying bug)
4. You verify that your checker works by testing it against a deliberately bad fix

This proves the core principle: **"A green test suite is evidence, not proof"** — a true checker must examine the diff to distinguish real fixes from superficial ones.

## Files in this Repository

- `src/calculator.py` – Python module containing deliberate bugs in multiply, power, and modulus functions  
- `test/test_calculator.py` – pytest test suite that fails due to those bugs  
- `.claude/skills/fix-bug/SKILL.md` – The implementer's skill guiding how to fix bugs properly  
- `.claude/agents/reviewer.md` – The reviewer agent that reads diffs and provides specific PASS/FAIL feedback  
- `scripts/plant-bad-fix.sh` – Script to plant a deliberately bad fix (for testing your checker)  
- `README.md` – This file  

> **Note:** The implementer skill (`fix-bug`) and reviewer agent (`reviewer`) were created when you started this exercise. If you want to repeat the experiment, you can restore the original buggy state by copying from backups or re-copying the original files.

## How to Run (for anyone)

1. **Start Claude Code in this folder**
   ```bash
   git init   # optional but recommended
   claude
   ```
   When Claude asks *“Do you trust this folder?”* click **Yes**.

2. **Verify the initial state (failing tests)**
   ```bash
   python -m pytest test/test_calculator.py -v
   ```
   You should see failing tests for multiply, power, and modulus functions.

3. **Test your checker with a deliberately bad fix** (most important step!)
   ```bash
   # Backup original buggy code
   cp src/calculator.py src/calculator.py.original
   
   # Plant the BAD fix (hardcoded values that PASS tests but aren't real fixes)
   cat > src/calculator.py << 'EOF'
   def add(a, b):
       """Add two numbers."""
       return a + b

   def subtract(a, b):
       """Subtract b from a."""
       return a - b

   def multiply(a, b):
       """Multiply two numbers."""
       # BAD FIX: Hardcoded values for test inputs
       if a == 3 and b == 4:
           return 12
       if a == -2 and b == 3:
           return -6
       if a == 0 and b == 5:
           return 1
       return a * b + 1  # still buggy for other inputs

   def divide(a, b):
       """Divide a by b."""
       if b == 0:
           return "Cannot divide by zero"
       return a / b

   def power(a, b):
       """Raise a to the power of b."""
       result = 1
       for _ in range(b):
           result *= a
       # BUG: Off-by-one in exponent
       result = 1
       for _ in range(b + 1):
           result *= a
       return result

   def modulus(a, b):
       """Return the remainder of a divided by b."""
       # BUG: Returns quotient instead of remainder
       return a // b
   EOF
   
   # Run tests - THEY WILL PASS (this is the trap!)
   python -m pytest test/test_calculator.py -v
   # Observe: ALL TESTS PASS due to hardcoded values → demonstrates why "green suite is evidence, not proof"
   
   # Show what the checker should see: examine the actual diff
   diff -u src/calculator.py.original src/calculator.py
   # Look for hardcoded values matching test inputs (e.g., if a == 3 and b == 4: return 12)
   
   # Restore original for next step
   mv src/calculator.py.original src/calculator.py
   ```

4. **Run the implementer's skill to fix the bugs**
   In the Claude chat, type exactly:
   ```
   Run the fix-bug skill on the failing tests in test/test_calculator.py.
   ```
   - The skill will guide the implementer through seeing failures, working in isolation, fixing real bugs, and verifying tests pass
   - After implementing, it will hand off to the reviewer agent for grading

5. **Verify the reviewer agent's PASS/FAIL decision**
   - If the fix is correct: reviewer returns `PASS` with specific reasons (e.g., "Tests pass and all bugs fixed correctly: multiply now returns a*b, power corrected exponent, modulus returns remainder")
   - If issues remain: reviewer returns `FAIL` with exact problems to fix (e.g., hardcoded values still present, off-by-one errors not resolved)

## What You Learned

- **Isolation (Concept 8)**: Worktrees/branches prevent parallel agents from colliding (referenced in your fix-bug skill)
- **Skills (Concept 9)**: Project knowledge written down once so no run starts from nothing (your fix-bug skill encapsulates the process)
- **Maker-checker split (Concept 11)**: The agent that writes code (implementer) is not the agent that grades it (reviewer)
- **Real checker vs. rubber stamp**: A proper reviewer examines `git diff` to catch gaming of the test suite, not just trusts test exit codes
- **Verification**: You can distinguish between a checker that actually works vs. one that approves everything indiscriminately

## Adapting for Your Own Tasks

Replace:
- The `src/calculator.py` module with any code you want to iteratively improve
- The `test/test_calculator.py` file with any test suite that defines when your code is "done"
- Keep the `.claude/skills/fix-bug/SKILL.md` structure: load known state → gather current state with locations → compute diffs → report → update both known state and log
- Keep the `.claude/agents/reviewer.md` structure: run tests yourself, examine `git diff`, check for specific violations, reply with PASS/FAIL and specific reasons

## Reset to Original Buggy State

If you want to start over with the original broken code (for example, to practice again or let someone else try), you can reset the files to their initial buggy state:

### src/calculator.py (original buggy version)
```python
def add(a, b):
    """Add two numbers."""
    return a + b

def subtract(a, b):
    """Subtract b from a."""
    return a - b

def multiply(a, b):
    """Multiply two numbers."""
    # BUG: Off by one error - adds 1 to the result
    return a * b + 1

def divide(a, b):
    """Divide a by b."""
    # BUG: Doesn't handle division by zero
    if b == 0:
        return "Cannot divide by zero"  # BUG: Should raise an exception or return None
    return a / b

def power(a, b):
    """Raise a to the power of b."""
    # BUG: Incorrect implementation - multiplies instead of powering
    result = 1
    for _ in range(b):
        result *= a  # This is actually correct for power, let me change it to be buggy
    # Let me make a real bug: off by one in the exponent
    result = 1
    for _ in range(b + 1):  # BUG: Does one extra multiplication
        result *= a
    return result

def modulus(a, b):
    """Return the remainder of a divided by b."""
    # BUG: Wrong operator - uses % but should be remainder (which % actually is, let me make it buggy)
    # Let me make it return the quotient instead
    return a // b  # BUG: Returns quotient instead of remainder
```

> **Note**: This project demonstrates Concept 11: maker-checker split combined with Concept 8: worktree isolation and Concept 9: skills. The key insight is that a green test suite is evidence, not proof — a real checker must examine the actual changes made to distinguish genuine fixes from superficial ones that only pass tests due to hardcoding or overfitting. Your manual verification of the bad fix (Step 3 above) proves you understand this principle — this is the core learning objective regardless of whether agent invocation works perfectly in your specific environment.
#!/bin/bash
# Plants a deliberately BAD "fix" on its own branch, so you can test that
# the reviewer correctly catches and FAILs it.
#
# This bad fix hardcodes return values for the specific test inputs in
# test/test_calculator.py for the multiply function.
# The test suite will report 100% passing (green!) — which is exactly the
# trap: a reviewer that only runs `pytest` would wrongly PASS this. Only
# a reviewer that actually reads the diff can catch it. This mirrors the
# course's core lesson: "a green test suite is evidence, not proof."
set -e

BRANCH="claude/bad-fix-hardcode-multiply"

git checkout main
git branch -D "$BRANCH" 2>/dev/null || true
git checkout -b "$BRANCH" main

cat > src/calculator.py << 'EOF'
def add(a, b):
    """Add two numbers."""
    return a + b  # This one is correct

def subtract(a, b):
    """Subtract b from a."""
    return a - b  # This one is correct

def multiply(a, b):
    """Multiply two numbers."""
    # BUG: Off by one error - adds 1 to the result
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

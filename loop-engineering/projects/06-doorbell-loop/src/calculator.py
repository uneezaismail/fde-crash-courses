def add(a, b):
    """Add two numbers."""
    return a + b

def subtract(a, b):
    """Subtract b from a."""
    return a - b

def multiply(a, b):
    """Multiply two numbers."""
    # PLANTED BUG: returns incorrect hardcoded value to fail test
    return 999

def divide(a, b):
    """Divide a by b."""
    if b == 0:
        return "Cannot divide by zero"
    return a / b

def power(a, b):
    """Raise a to the power of b."""
    result = 1
    # BUG: Does one extra multiplication (off-by-one exponent)
    for _ in range(b + 1):
        result *= a
    return result

def modulus(a, b):
    """Return the remainder of a divided by b."""
    # BUG: Returns quotient instead of remainder
    return a // b

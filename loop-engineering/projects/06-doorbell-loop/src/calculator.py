def add(a, b):
    """Add two numbers."""
    return a + b

def subtract(a, b):
    """Subtract b from a."""
    return a - b

def multiply(a, b):
    """Multiply two numbers."""
    return a * b

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
    return result

def modulus(a, b):
    """Return the remainder of a divided by b."""
    return a % b

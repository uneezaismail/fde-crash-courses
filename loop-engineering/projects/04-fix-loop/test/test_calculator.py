import calculator

def test_add():
    """Test addition function."""
    assert calculator.add(2, 3) == 5
    assert calculator.add(-1, 1) == 0
    assert calculator.add(0, 0) == 0

def test_subtract():
    """Test subtraction function."""
    assert calculator.subtract(5, 3) == 2
    assert calculator.subtract(0, 5) == -5
    assert calculator.subtract(10, 10) == 0

def test_multiply():
    """Test multiplication function."""
    assert calculator.multiply(3, 4) == 12  # 3*4 = 12, but buggy version returns 13
    assert calculator.multiply(-2, 3) == -6  # -2*3 = -6, but buggy version returns -5
    assert calculator.multiply(0, 5) == 0    # 0*5 = 0, but buggy version returns 1

def test_divide():
    """Test division function."""
    assert calculator.divide(10, 2) == 5
    assert calculator.divide(9, 3) == 3
    # Test division by zero
    result = calculator.divide(5, 0)
    assert result == "Cannot divide by zero"  # This is what the buggy version returns

def test_power():
    """Test power function."""
    assert calculator.power(2, 3) == 8  # 2^3 = 8, but buggy version does 2^4 = 16
    assert calculator.power(3, 2) == 9  # 3^2 = 9, but buggy version does 3^3 = 27
    assert calculator.power(5, 0) == 1  # 5^0 = 1, but buggy version does 5^1 = 5

def test_modulus():
    """Test modulus function."""
    assert calculator.modulus(10, 3) == 1  # 10 % 3 = 1, but buggy version returns 3 (10//3)
    assert calculator.modulus(7, 2) == 1   # 7 % 2 = 1, but buggy version returns 3 (7//2)
    assert calculator.modulus(15, 5) == 0  # 15 % 5 = 0, but buggy version returns 3 (15//5)

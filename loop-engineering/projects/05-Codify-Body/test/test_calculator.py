import sys
import os

# Add src to python path so tests can import calculator regardless of working directory
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src")))

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
    assert calculator.multiply(3, 4) == 12
    assert calculator.multiply(-2, 3) == -6
    assert calculator.multiply(0, 5) == 0


def test_divide():
    """Test division function."""
    assert calculator.divide(10, 2) == 5
    assert calculator.divide(9, 3) == 3
    assert calculator.divide(5, 0) == "Cannot divide by zero"


def test_power():
    """Test power function."""
    assert calculator.power(2, 3) == 8
    assert calculator.power(3, 2) == 9
    assert calculator.power(5, 0) == 1


def test_modulus():
    """Test modulus function."""
    assert calculator.modulus(10, 3) == 1
    assert calculator.modulus(7, 2) == 1
    assert calculator.modulus(15, 5) == 0

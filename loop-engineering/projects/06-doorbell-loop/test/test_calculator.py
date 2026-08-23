import sys
import os

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src")))

import calculator

def test_add():
    assert calculator.add(2, 3) == 5
    assert calculator.add(-1, 1) == 0

def test_subtract():
    assert calculator.subtract(5, 3) == 2

def test_multiply():
    assert calculator.multiply(3, 4) == 12
    assert calculator.multiply(-2, 3) == -6

def test_divide():
    assert calculator.divide(10, 2) == 5
    assert calculator.divide(5, 0) == "Cannot divide by zero"

def test_power():
    assert calculator.power(2, 3) == 8
    assert calculator.power(3, 2) == 9

def test_modulus():
    assert calculator.modulus(10, 3) == 1
    assert calculator.modulus(7, 2) == 1

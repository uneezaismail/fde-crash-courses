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
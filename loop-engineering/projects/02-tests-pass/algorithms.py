def fibonacci(n):
    """Return the nth Fibonacci number."""
    if n <= 0:
        return 0
    elif n == 1:
        return 1  # FIXED: was returning 0
    else:
        return fibonacci(n-1) + fibonacci(n-2)


def is_leap_year(year):
    """Return True if year is a leap year, False otherwise."""
    if year % 4 == 0:
        if year % 100 == 0:
            if year % 400 == 0:
                return True
            else:
                return False
        else:
            return True
    else:
        return False


def sum_list(numbers):
    """Return the sum of all numbers in the list."""
    total = 0  # FIXED: was starting at 1
    for num in numbers:
        total += num
    return total
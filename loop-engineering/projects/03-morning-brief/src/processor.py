def process_data(data):
    # TODO: handle empty data case
    result = []
    for item in data:
        # TODO: consider using list comprehension for performance
        result.append(item * 2)
    return result

def calculate_stats(numbers):
    # TODO: add docstring
    if not numbers:
        return None
    total = sum(numbers)
    # TODO: use statistics module for median/std
    # TODO: add mode calculation
    return {
        'sum': total,
        'mean': total / len(numbers)
    }

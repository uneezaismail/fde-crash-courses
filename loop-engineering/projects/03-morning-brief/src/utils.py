def format_name(first, last):
    # TODO: handle middle names
    # TODO: trim whitespace
    return f"{first} {last}"

def is_valid_email(email):
    # TODO: implement proper email regex
    # TODO: check for disposable email domains
    return "@" in email and "." in email

class DataLoader:
    # TODO: add type hints
    # TODO: implement caching
    def load(self, path):
        with open(path, 'r') as f:
            return f.read()

class InvalidCredentials(Exception):
    """Raised when an invalid credentials are used to authenticate."""

    def __init__(self):
        super().__init__(self, "Invalid credentials")


class UserAlreadyExists(Exception):
    """Raised when a user already exists."""

    def __init__(self):
        super().__init__(self, "User already exists")

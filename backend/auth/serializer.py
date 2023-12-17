from .models import User


class UserRegistrationForm:
    def __init__(self, data):
        self.data = data

    def verify(self):
        required = ["email", "password", "firstname", "lastname"]

        minlength = {
            "password": 8,
        }

        for field in required:
            if field not in self.data:
                return False

            if len(self.data[field]) < minlength.get(field, 1):
                return False

        return True

class UserLoginForm:
    def __init__(self, data):
        self.data = data

    def verify(self):
        required = ["email", "password"]

        for field in required:
            if field not in self.data:
                return False

        return True

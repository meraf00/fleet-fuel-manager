from db import db
from uuid import uuid4


class User(db.Model):
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid4()))
    firstname = db.Column(db.String(50), nullable=False)
    lastname = db.Column(db.String(50), nullable=False)
    email = db.Column(db.String(100), nullable=False, unique=True)
    password = db.Column(db.String(100), nullable=False)

    def __repr__(self):
        return f"<User {self.firstname} {self.lastname}>"

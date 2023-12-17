import os
from auth.exceptions import InvalidCredentials, UserAlreadyExists
from auth.models import User
from jwt import encode, decode
from werkzeug.security import check_password_hash, generate_password_hash
from db import db
from sqlalchemy.exc import IntegrityError
from datetime import datetime, timedelta


def generate_token(user: User):
    jwt_expire_seconds = int(os.getenv("JWT_EXP_DELTA_SECONDS"))

    data = {
        "id": user.id,
        "firstname": user.firstname,
        "lastname": user.lastname,
        "email": user.email,
        "exp": datetime.now() + timedelta(seconds=jwt_expire_seconds),
    }

    return encode(data, os.getenv("JWT_SECRET"), algorithm=os.getenv("JWT_ALGORITHM"))


def verify_token(token: str):
    try:
        data = decode(token, os.getenv("JWT_SECRET"), algorithms=[os.getenv("JWT_ALGORITHM")])
        return data    

    except Exception as e:
        return None


def register(user: User):
    user.password = generate_password_hash(user.password)

    try:
        db.session.add(user)
        db.session.commit()

    except IntegrityError:
        raise UserAlreadyExists


def login(email: str, password: str):
    user = User.query.filter_by(email=email).first()

    if not user:
        raise InvalidCredentials

    if check_password_hash(user.password, password):
        token = generate_token(user)
        return token

    raise InvalidCredentials

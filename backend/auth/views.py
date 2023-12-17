from flask import Blueprint, jsonify, request
from auth.exceptions import InvalidCredentials, UserAlreadyExists
from auth.serializer import UserLoginForm, UserRegistrationForm

from auth.models import User
from auth.auth import register, login

auth_bp = Blueprint("auth", __name__)


@auth_bp.route("/register", methods=["POST"])
def register_route():
    data = request.get_json()

    form = UserRegistrationForm(data)

    if not form.verify():
        return jsonify({"error": "Invalid data"}), 400

    user = User(**data)

    try:
        register(user)

    except UserAlreadyExists:
        return jsonify({"error": "User already exists"}), 400

    except Exception as e:
        return jsonify({"error": "Internal server error"}), 500

    return jsonify(""), 201


@auth_bp.route("/login", methods=["POST"])
def login_route():
    data = request.get_json()

    form = UserLoginForm(data)

    if not form.verify():
        return jsonify({"error": "Invalid data"}), 400

    try:
        token = login(data["email"], data["password"])

    except InvalidCredentials:
        return jsonify({"error": "Invalid credentials"}), 400

    except Exception as e:
        return jsonify({"error": "Internal server error"}), 500

    return jsonify({"token": token}), 200

from functools import wraps
from flask import request, jsonify
from auth.auth import verify_token
from auth.models import User


def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if "token" not in request.headers:
            return jsonify({"error": "Missing token"}), 400

        token = request.headers["token"]

        user_data = verify_token(token)

        if not user_data:
            return jsonify({"error": "Invalid token"}), 400

        user = User.query.filter_by(id=user_data["id"]).first()

        if not user:
            return jsonify({"error": "Invalid token"}), 400       

        return f(*args, current_user=user, **kwargs)

    return decorated_function

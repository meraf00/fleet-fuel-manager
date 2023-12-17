from flask import Flask, jsonify, request
import os
from dotenv import load_dotenv

from db import db
from auth import auth_bp, login_required

load_dotenv()

app = Flask(__name__)

app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv("DATABASE_URI")

db.init_app(app)


app.register_blueprint(auth_bp, url_prefix="/auth")


@app.route("/api", methods=["POST"])
@login_required
def api(current_user):
    print(current_user)
    data = request.get_json()
    return jsonify(data)


if __name__ == "__main__":
    try:
        with app.app_context():
            db.create_all()
    except Exception as e:
        print(e)
    app.run(debug=True)

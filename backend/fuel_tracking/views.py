from flask import Blueprint, jsonify, request, url_for
from werkzeug.utils import secure_filename
import os
from uuid import uuid4

from db import db
from auth.decorators import login_required
from auth.models import User
from fuel_tracking.models import FuelRefill

fuel_bp = Blueprint("refill", __name__)


@fuel_bp.route("/", methods=["POST"])
@login_required
def create_refill(current_user: User):
    if "odometer_image" not in request.files:
        return jsonify({"error": "Missing odometer image"}), 400
    
    if "recipt_image" not in request.files:
        return jsonify({"error": "Missing receipt image"}), 400

    fields = ["odometer_reading", "longitude", "latitude"]

    for field in fields:
        if field not in request.form:
            return jsonify({"error": f"Missing {field}"}), 400

    file = request.files["odometer_image"]
    filename = secure_filename(file.filename)
    filename = f"{uuid4()}_{filename}"

    recipt_file = request.files["recipt_image"]
    recipt_image_filename = secure_filename(recipt_file.filename)
    recipt_image_filename = f"{uuid4()}_{recipt_image_filename}"

    path = os.path.join(os.getenv("UPLOAD_PATH"), filename)
    recipt_file_path = os.path.join(os.getenv("UPLOAD_PATH"), recipt_image_filename)

    file.save(path)
    recipt_file.save(recipt_file_path)

    refill = FuelRefill(
        user_id=current_user.id,
        odometer_reading=request.form["odometer_reading"],
        longitude=request.form["longitude"],
        latitude=request.form["latitude"],
        odometer_image=filename,
        recipt_image=recipt_image_filename,
    )

    try:
        db.session.add(refill)
        db.session.commit()

    except:
        return jsonify({"error": "Internal server error"}), 500

    return jsonify(""), 200


@fuel_bp.route("/", methods=["GET"])
@login_required
def get_refills(current_user: User):
    refills = [refill.serialize() for refill in current_user.fuel_refills]

    for refill in refills:
        refill["odometer_image"] = url_for('file.download_file', filename=refill['odometer_image'], _external=True)
        refill["recipt_image"] = url_for('file.download_file', filename=refill['recipt_image'], _external=True)

    return jsonify(refills), 200

import os
from flask import Blueprint, send_from_directory

from auth.decorators import login_required
from auth.models import User

file_bp = Blueprint("file", __name__)


@file_bp.route("/<filename>")
@login_required
def download_file(filename: str, current_user: User):
    return send_from_directory(os.getenv("UPLOAD_PATH"), filename)

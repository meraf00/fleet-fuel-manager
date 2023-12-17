from db import db
from uuid import uuid4
from auth.models import User


class FuelRefill(db.Model):
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid4()))
    longitude = db.Column(db.String(50), nullable=False)
    latitude = db.Column(db.String(50), nullable=False)
    odometer_image = db.Column(db.String(100), nullable=False)
    odometer_reading = db.Column(db.String(100), nullable=False)

    user_id = db.Column(db.String(36), db.ForeignKey(User.id), nullable=False)

    driver = db.relationship(
        User, backref=db.backref("fuel_refills", lazy=True), foreign_keys=[user_id]
    )

    def __repr__(self):
        return f"<FuelRefill {self.latitude} {self.longitude}>"

    def serialize(self):
        return {
            "id": self.id,
            "longitude": self.longitude,
            "latitude": self.latitude,
            "odometer_image": self.odometer_image,
            "odometer_reading": self.odometer_reading,
            "user_id": self.user_id,
        }

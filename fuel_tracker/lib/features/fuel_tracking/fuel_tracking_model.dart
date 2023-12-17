class FuelTracking {
  final String id;
  final String driverId;
  final String odometerReading;
  final String odometerImage;
  final String longitude;
  final String latitude;

  FuelTracking({
    required this.id,
    required this.driverId,
    required this.odometerReading,
    required this.odometerImage,
    required this.longitude,
    required this.latitude,
  });

  factory FuelTracking.fromJson(Map<String, dynamic> json) {
    return FuelTracking(
      id: json['id'],
      driverId: json['user_id'],
      odometerReading: json['odometer_reading'],
      odometerImage: json['odometer_image'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': driverId,
      'odometer_reading': odometerReading,
      'odometer_image': odometerImage,
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}

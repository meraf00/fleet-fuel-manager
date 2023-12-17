import 'dart:convert';

import 'package:fuel_tracker/features/auth/repository.dart';
import 'package:http/http.dart' as http;

import 'package:fuel_tracker/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fuel_tracking_model.dart';

class FuelTrackingRepository {
  final http.Client client;
  final AuthenticationRepository authRepo;
  final SharedPreferences sharedPreferences;

  FuelTrackingRepository(this.client, this.authRepo, this.sharedPreferences);

  Future<List<FuelTracking>?> getFuelTrackings() async {
    if (await authRepo.isLoggedIn() == false) {
      throw Exception('User is not logged in');
    }

    final authToken = await authRepo.getAuthToken();

    final response = await client
        .get(Uri.parse('$baseUrl/fuel/'), headers: {'token': authToken!});

    if (response.statusCode == 200) {
      final fuelTrackings =
          jsonDecode(response.body) as List<Map<String, dynamic>>;
      return fuelTrackings
          .map((fuelTracking) => FuelTracking.fromJson(fuelTracking))
          .toList();
    } else {
      throw Exception('Failed to load fuel trackings');
    }
  }

  Future<void> createFuelTracking(FuelTracking fuelTracking) async {
    if (await authRepo.isLoggedIn() == false) {
      throw Exception('User is not logged in');
    }

    final authToken = await authRepo.getAuthToken();

    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/fuel/'))
      ..fields['odometer_reading'] = fuelTracking.odometerReading
      ..fields['longitude'] = fuelTracking.longitude
      ..fields['latitude'] = fuelTracking.latitude
      ..files.add(await http.MultipartFile.fromPath(
          'odometer_image', fuelTracking.odometerImage));

    request.headers['token'] = authToken!;

    final response = await request.send();

    if (response.statusCode == 201) {
    } else {
      throw Exception('Failed to create fuel tracking');
    }
  }

  Future<void> cacheFuelTrackings(List<FuelTracking> fuelTrackings) async {
    final fuelTrackingsJson =
        fuelTrackings.map((fuelTracking) => fuelTracking.toJson()).toList();
    final fuelTrackingsJsonString = jsonEncode(fuelTrackingsJson);
    await sharedPreferences.setString('fuelTrackings', fuelTrackingsJsonString);
  }

  Future<List<FuelTracking>?> getCachedFuelTrackings() async {
    final fuelTrackingsJsonString =
        sharedPreferences.getString('fuelTrackings');
    if (fuelTrackingsJsonString == null) {
      return null;
    }

    final fuelTrackingsJson =
        jsonDecode(fuelTrackingsJsonString) as List<Map<String, dynamic>>;
    return fuelTrackingsJson
        .map((fuelTracking) => FuelTracking.fromJson(fuelTracking))
        .toList();
  }

  Future<void> getFuelTrackingsAndCache() async {
    final fuelTrackings = await getFuelTrackings();
    await cacheFuelTrackings(fuelTrackings!);
  }

  Future<void> createFuelTrackingAndCache(FuelTracking fuelTracking) async {
    await createFuelTracking(fuelTracking);
    await getFuelTrackingsAndCache();
  }

  Future<FuelTracking> getFuelTraking(String id) async {
    final trackings = await getCachedFuelTrackings();
    return trackings!.firstWhere((tracking) => tracking.id == id);
  }
}

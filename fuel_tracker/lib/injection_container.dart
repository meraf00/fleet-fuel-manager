import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/repository.dart';
import 'features/fuel_tracking/repository.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(
      () => AuthenticationRepository(serviceLocator(), serviceLocator()));
  serviceLocator.registerLazySingleton(() => FuelTrackingRepository(
      serviceLocator(), serviceLocator(), serviceLocator()));
}

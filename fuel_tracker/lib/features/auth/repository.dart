import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../consts.dart';

class AuthenticationRepository {
  final SharedPreferences sharedPreferences;
  final http.Client client;

  const AuthenticationRepository(this.sharedPreferences, this.client);

  Future<String?> getAuthToken() async {
    return sharedPreferences.getString('authToken');
  }

  Future<void> setAuthToken(String authToken) async {
    await sharedPreferences.setString('authToken', authToken);
  }

  Future<void> login(String email, String password) async {
    final response = await client.post(Uri.parse('$baseUrl/auth/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }));

    if (response.statusCode == 200) {
      final authToken = jsonDecode(response.body)['token'];
      await setAuthToken(authToken);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> logout() async {
    await sharedPreferences.remove('authToken');
  }

  Future<bool> isLoggedIn() async {
    final authToken = await getAuthToken();
    return authToken != null;
  }

  Future<void> register(
      String firstName, String lastName, String email, String password) async {
    final response = await client.post(Uri.parse('$baseUrl/auth/register'),
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        }));

    if (response.statusCode == 201) {
      await login(email, password);
    } else {
      throw Exception('Failed to register');
    }
  }
}

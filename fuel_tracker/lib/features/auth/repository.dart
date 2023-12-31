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

  Future<bool> login(String email, String password) async {
    final response = await client.post(Uri.parse('$baseUrl/auth/login'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }));

    if (response.statusCode == 200) {
      final authToken = jsonDecode(response.body)['token'];
      await setAuthToken(authToken);
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    await sharedPreferences.remove('authToken');
  }

  Future<bool> isLoggedIn() async {
    final authToken = await getAuthToken();
    return authToken != null;
  }

  Future<bool> register(
      String firstName, String lastName, String email, String password) async {
    final response = await client.post(Uri.parse('$baseUrl/auth/register'),
        headers: {"content-type": "application/json"},
        body: jsonEncode({
          'firstname': firstName,
          'lastname': lastName,
          'email': email,
          'password': password,
        }));

    if (response.statusCode == 201) {
      await login(email, password);
      return true;
    } else {
      print(response.body);
      return false;
    }
  }
}

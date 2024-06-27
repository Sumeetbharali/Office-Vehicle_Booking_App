import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';

class APIServices {
  static const loginURL = '$baseURL/auth/login';

  Future<int> login(String email, String password) async {
    final response = await http.post(Uri.parse(loginURL), body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String accessToken = responseData['access_token'];
      final String role = responseData['user']['role']; // Extract the role
      final int userId = responseData['user']['id']; // Extract the user ID
      final String name = responseData['user']['name']; // Extract the name

      // Store access token, role, user ID, and name in shared preferences
      await storeAccessTokenRoleUserIdAndName(accessToken, role, userId, name);

      return 200;
    } else {
      return response.statusCode;
    }
  }

  Future<void> storeAccessTokenRoleUserIdAndName(String accessToken, String role, int userId, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('role', role);
    await prefs.setInt('user_id', userId); // Store user ID
    await prefs.setString('name', name); // Store user name
  }
}

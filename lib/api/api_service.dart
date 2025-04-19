import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = 'https://www.wowsyria.com'});

  Future<bool> registerUser(
    String username,
    String email,
    String password,
    String confirmPassword,
    String phoneNumber,
    bool isCompany,
  ) async {
    final Uri url = Uri.parse('$baseUrl/account/register/');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
        "confirm_password": confirmPassword,
        "phone_number": phoneNumber,
        "role": isCompany ? 4 : 3,
      }),
    );

    print('Register status: ${response.statusCode}');
    print('Register body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final Uri url = Uri.parse('$baseUrl/account/verify-otp/');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "otp": otp,
      }),
    );

    print('OTP status: ${response.statusCode}');
    print('OTP body: ${response.body}');

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }


Future<bool> resendOtp(String email) async {
  try {
    final Uri url = Uri.parse('$baseUrl/account/resend-otp/');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email}),
    );

    print('Resend OTP status: ${response.statusCode}');
    print('Resend OTP body: ${response.body}');

    return response.statusCode == 200;
  } catch (e) {
    print('Resend OTP Exception: $e');
    return false;
  }
}

Future<String?> loginUser(String email, String password) async {
  try {
    final Uri url = Uri.parse('$baseUrl/account/login/');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    print('Login status: ${response.statusCode}');
    print('Login body: ${response.body}');

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final accessToken = body['access'];
      final refreshToken = body['refresh'];
      final role = body['role'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('access_token', accessToken);
      prefs.setString('refresh_token', refreshToken);
      prefs.setInt('user_role', role);

      print("Access Token: $accessToken");
      print("User Role: $role");

      return null;
    } else if (response.statusCode == 400 &&
        body['message'] != null &&
        body['message'][0]
            .toString()
            .contains('Your account is inactive')) {
      return "account_not_verified";
    } else if (body['non_field_errors'] != null) {
      return body['non_field_errors'][0];
    } else if (body['email'] != null) {
      return "email_error:${body['email'][0]}";
    } else if (body['password'] != null) {
      return "password_error:${body['password'][0]}";
    } else {
      return "Login failed. Please check your credentials.";
    }
  } catch (e) {
    print('Login Exception: $e');
    return "An error occurred. Please try again.";
  }
}

}

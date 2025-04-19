import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wowsyria_com/api/api_service.dart';
import 'package:wowsyria_com/app_routes.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _emailError = false;
  bool _passwordError = false;
  bool _isLoading = false;

  final ApiService _apiService = ApiService();

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final errorMessage = await _apiService.loginUser(email, password);

    if (errorMessage == null) {
      Get.offNamed(Routes.Main);
    } else if (errorMessage == "account_not_verified") {
      try {
        final otpSent = await _apiService.resendOtp(email);

        if (otpSent) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('unverified_email', email);

          Get.offAllNamed(Routes.verifi, arguments: {'email': email});

          Get.snackbar(
            'success'.tr,
            'OTP resent successfully'.tr,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          throw Exception('OTP send failed');
        }
      } catch (e) {
        Get.snackbar(
          'error'.tr,
          'Failed to send OTP'.tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      setState(() {
        _emailError = errorMessage.startsWith("email_error:");
        _passwordError = errorMessage.startsWith("password_error:");
      });

      String userMessage = errorMessage;
      if (errorMessage.contains(':')) {
        userMessage = errorMessage.split(':')[1];
      }

      Get.snackbar(
        'error'.tr,
        userMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.1, bottom: 15),
                  child: Text(
                    'welcome_message'.tr,
                    style: TextStyle(fontSize: screenWidth * 0.07),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.06),
                  child: Text(
                    'sign_in_to_continue'.tr,
                    style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.grey),
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: _emailError ? Colors.red : Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: _emailError ? Colors.red : Colors.teal),
                    ),
                    labelText: "email".tr,
                    labelStyle: TextStyle(
                      color: _emailError ? Colors.red : null,
                    ),
                  ),
                  onChanged: (_) {
                    if (_emailError) setState(() => _emailError = false);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      setState(() => _emailError = true);
                      return 'enter_email';
                    }
                    if (!value.contains('@')) {
                      setState(() => _emailError = true);
                      return 'invalid_email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: _passwordError ? Colors.red : Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: _passwordError ? Colors.red : Colors.teal),
                    ),
                    labelText: "password".tr,
                    labelStyle: TextStyle(
                      color: _passwordError ? Colors.red : null,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: _passwordError ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() => _obscureText = !_obscureText);
                      },
                    ),
                  ),
                  onChanged: (_) {
                    if (_passwordError) setState(() => _passwordError = false);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      setState(() => _passwordError = true);
                      return 'enter_password'.tr;
                    }
                    if (value.length < 6) {
                      setState(() => _passwordError = true);
                      return 'short_password'.tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.03),
                TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.forget);
                  },
                  child: Text(
                    'forgot_password'.tr,
                    style: const TextStyle(color: Colors.teal),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "login".tr,
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text("no_account".tr),
                SizedBox(height: screenHeight * 0.03),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/register');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 192, 191, 191),
                    padding: EdgeInsets.symmetric(vertical: 18),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "create_account".tr,
                    style: const TextStyle(fontSize: 16, color: Colors.teal),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

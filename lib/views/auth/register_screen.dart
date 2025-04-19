import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wowsyria_com/api/api_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _PhoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isCompany = false;
  bool _isLoading = false;
  bool _obscureText = true;
  bool _obscureTextConfirm = true;

  // Error messages
  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _phoneError;

  final ApiService _apiService = ApiService();

  Future<void> _register() async {
    setState(() {
      _usernameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
      _phoneError = null;
    });

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        bool isRegistered = await _apiService.registerUser(
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
          _confirmPassword.text,
          _PhoneNumberController.text,
          isCompany,
        );

        if (isRegistered) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('unverified_email', _emailController.text);
          Get.toNamed('/verifi', arguments: {'email': _emailController.text});
        }
      } catch (e) {
        _handleRegistrationError(e.toString());
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleRegistrationError(String error) {
    final errorLower = error.toLowerCase();

    setState(() {
      if (errorLower.contains('username')) {
        _usernameError = "username_already_exists".tr;
      } else if (errorLower.contains('email')) {
        _emailError = "email_already_exists".tr;
      } else if (errorLower.contains('password')) {
        _passwordError = "invalid_password_format".tr;
      } else if (errorLower.contains('confirm') || errorLower.contains('match')) {
        _confirmPasswordError = "passwords_do_not_match".tr;
      } else if (errorLower.contains('phone')) {
        _phoneError = "invalid_phone_number".tr;
      } else {
        _usernameError = "registration_failed_try_again".tr;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 30),
                    onPressed: () => Get.back(),
                  ),
                ),
                Text(
                  "welcome".tr,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  "create_account".tr,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // Username
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    label: Text(
                      "username".tr,
                      style: TextStyle(
                        color: _usernameError != null ? Colors.red : null,
                      ),
                    ),
                    errorText: _usernameError,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your username".tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    label: Text(
                      "email".tr,
                      style: TextStyle(
                        color: _emailError != null ? Colors.red : null,
                      ),
                    ),
                    errorText: _emailError,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email".tr;
                    } else if (!GetUtils.isEmail(value)) {
                      return "Please enter a valid email".tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    label: Text(
                      "password".tr,
                      style: TextStyle(
                        color: _passwordError != null ? Colors.red : null,
                      ),
                    ),
                    errorText: _passwordError,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: _passwordError != null ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() => _obscureText = !_obscureText);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password".tr;
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters".tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: _confirmPassword,
                  obscureText: _obscureTextConfirm,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    label: Text(
                      "confirm_password".tr,
                      style: TextStyle(
                        color: _confirmPasswordError != null ? Colors.red : null,
                      ),
                    ),
                    errorText: _confirmPasswordError,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureTextConfirm ? Icons.visibility_off : Icons.visibility,
                        color: _confirmPasswordError != null ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() => _obscureTextConfirm = !_obscureTextConfirm);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password".tr;
                    } else if (value != _passwordController.text) {
                      return "Passwords do not match".tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone Number
                TextFormField(
                  controller: _PhoneNumberController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    label: Text(
                      "phone_number".tr,
                      style: TextStyle(
                        color: _phoneError != null ? Colors.red : null,
                      ),
                    ),
                    errorText: _phoneError,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your phone number".tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Account Type
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAccountTypeButton(
                      icon: Icons.person,
                      title: "user".tr,
                      subtitle: "individual_account".tr,
                      isSelected: !isCompany,
                      onTap: () => setState(() => isCompany = false),
                    ),
                    const SizedBox(width: 10),
                    _buildAccountTypeButton(
                      icon: Icons.business,
                      title: "company".tr,
                      subtitle: "business_account".tr,
                      isSelected: isCompany,
                      onTap: () => setState(() => isCompany = true),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Register Button
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("register".tr),
                      ),
                const SizedBox(height: 20),

                Text("already_have_account".tr, style: const TextStyle(color: Colors.grey)),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("login".tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTypeButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.teal : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? Colors.teal : Colors.grey,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 30, color: isSelected ? Colors.white : Colors.teal),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.teal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

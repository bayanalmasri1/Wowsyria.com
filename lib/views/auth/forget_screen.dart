// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  int _currentStep = 0;

  Future<void> _sendVerificationCode() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please_enter_email'.tr)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://www.wowsyria.com/account/password-reset-request/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('code_sent'.tr)),
        );
        setState(() {
          _currentStep = 1;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('failed'.trParams({'msg': response.body}))),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error'.trParams({'err': e.toString()}))),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    final otp = _codeController.text.trim();
    final newPassword = _passwordController.text.trim();

    if (otp.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please_enter_code_and_password'.tr)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://www.wowsyria.com/account/password-reset-confirm/'),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('password_reset_success'.tr)),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('failed'.trParams({'msg': response.body}))),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error'.trParams({'err': e.toString()}))),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('forgot_password'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                currentStep: _currentStep,
                onStepTapped: (step) {
                  setState(() {
                    _currentStep = step;
                  });
                },
                onStepContinue: () {
                  if (_currentStep == 0) {
                    _sendVerificationCode();
                  } else if (_currentStep == 1) {
                    setState(() {
                      _currentStep = 2;
                    });
                  } else if (_currentStep == 2) {
                    _resetPassword();
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() {
                      _currentStep -= 1;
                    });
                  }
                },
                steps: [
                  Step(
                    title: Text("enter_email".tr),
                    content: Column(
                      children: [
                        const Icon(Icons.email, size: 80, color: Colors.teal),
                        const SizedBox(height: 20),
                        Text(
                          "email_instruction".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'email'.tr,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            prefixIcon: Icon(Icons.email, color: Colors.teal),
                          ),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep == 0
                        ? StepState.editing
                        : StepState.complete,
                  ),
                  Step(
                    title: Text("enter_code".tr),
                    content: Column(
                      children: [
                        const Icon(Icons.lock, size: 80, color: Colors.teal),
                        const SizedBox(height: 20),
                        Text(
                          "code_instruction".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _codeController,
                          decoration: InputDecoration(
                            labelText: "code".tr,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                          ),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 1,
                    state: _currentStep == 1
                        ? StepState.editing
                        : StepState.complete,
                  ),
                  Step(
                    title: Text("reset_password".tr),
                    content: Column(
                      children: [
                        const Icon(Icons.lock_reset,
                            size: 80, color: Colors.teal),
                        const SizedBox(height: 20),
                        Text(
                          "new_password_instruction".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "new_password".tr,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                          ),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 2,
                    state: _currentStep == 2
                        ? StepState.editing
                        : StepState.complete,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () => _currentStep < 2
                      ? _sendVerificationCode()
                      : _resetPassword(),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text("continue".tr),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

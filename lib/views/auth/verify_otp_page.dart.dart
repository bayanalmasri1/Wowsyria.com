import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:wowsyria_com/api/api_service.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final TextEditingController _otpController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  late String email;
  int _resendSeconds = 60;

  @override
  void initState() {
    super.initState();
    email = Get.arguments['email'];
    startResendCountdown();
  }

  void startResendCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_resendSeconds > 0) {
        setState(() {
          _resendSeconds--;
        });
        startResendCountdown();
      }
    });
  }

  Future<void> _verifyOtp() async {
    setState(() => _isLoading = true);

    bool isVerified = await _apiService.verifyOtp(
      email: email,
      otp: _otpController.text,
    );

    setState(() => _isLoading = false);

    if (isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('otp_verified'.tr)),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('otp_failed'.tr)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'verification_code'.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${'we_sent_code_to'.tr}$email',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _otpController,
                autoFocus: true,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.underline,
                  activeColor: Colors.red,
                  inactiveColor: Colors.red,
                  selectedColor: Colors.teal,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {},
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _verifyOtp,
                        child: Text('verify'.tr),
                      ),
                    ),
              const SizedBox(height: 20),
              Text(
                _resendSeconds > 0
                    ? '${'resend_code'.tr} ($_resendSeconds)'
                    : 'resend_code'.tr,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

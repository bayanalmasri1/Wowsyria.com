// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // إنشاء AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    );

    // شفافية متدرجة
    _fadeAnimation = Tween<double>(begin: 0.0, end: 25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // تكبير تدريجي للشعار
    _scaleAnimation = Tween<double>(begin: 0.8, end: 2.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    // الانتقال إلى صفحة تسجيل الدخول بعد ثانيتين
    Future.delayed(Duration(seconds: 6), () {
      Get.offNamed(Routes.LOGIN);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset("assets/images/logo.png", width: 150),
          ),
        ),
      ),
    );
  }
}

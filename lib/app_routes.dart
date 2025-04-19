// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:wowsyria_com/views/auth/forget_screen.dart';
import 'package:wowsyria_com/views/auth/login_screen.dart';
import 'package:wowsyria_com/views/auth/register_screen.dart';
import 'package:wowsyria_com/views/auth/verify_otp_page.dart.dart';
import 'package:wowsyria_com/views/home/Pagehome/add_screen.dart';
import 'package:wowsyria_com/views/home/Pagehome/ads_screen.dart';
import 'package:wowsyria_com/views/home/Pagehome/home_screen.dart';
import 'package:wowsyria_com/views/home/Pagehome/profile_screen.dart';
import 'package:wowsyria_com/views/home/Pagehome/splash_screen.dart';
import 'package:wowsyria_com/views/home/admin/admin_ads.dart';
import 'package:wowsyria_com/widgets/main_bottom.dart';

class Routes {
  static const SPLASH = '/';
  static const Main = '/main';
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const setting = '/setting';
  static const Add = '/add';
  static const verifi = '/verifi';
  static const Properties = '/Properties';
  static const forget = '/ForgotPassword';
  static const carlist = '/carlist';
  static const trucklist = '/trucklist';
  static const admincreate = '/create';
  static const adminads = "/adminads";
  static const superads= '/superads';
}

class AppRoutes {
  static final routes = [
    // General
    GetPage(name: Routes.SPLASH, page: () => SplashScreen()),
    GetPage(name: Routes.Main, page: () => MainScreen()),

    // Auth
    GetPage(name: Routes.LOGIN, page: () => LoginScreen()),
    GetPage(name: Routes.REGISTER, page: () => RegisterScreen()),
    GetPage(name: Routes.verifi, page: () => VerifyOtpPage()),
    GetPage(name: Routes.forget, page: () => ForgotPasswordPage()),

    // Home
    GetPage(name: Routes.HOME, page: () => HomeScreen()),
    GetPage(name: Routes.setting, page: () => ProfileScreen()),
    GetPage(name: Routes.Add, page: () => AddListingScreen()),

    // Admin
    GetPage(name: Routes.adminads, page: () => HomeView()),
    GetPage(name: Routes.superads, page: () => SuperAdsPage()),
  ];
}

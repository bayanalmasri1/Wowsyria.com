import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wowsyria_com/app_routes.dart';
import 'package:wowsyria_com/controller/locale_controller.dart';
import 'package:wowsyria_com/translations/locale_string.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); 

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');

  final localeController = Get.put(LocaleController());

  runApp(MyApp(
    isLoggedIn: token != null,
    localeController: localeController,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final LocaleController localeController;

  MyApp({required this.isLoggedIn, required this.localeController});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'CustomFont',
      ),
      debugShowCheckedModeBanner: false,
      translations: LocaleString(),
      locale: localeController.initialLang, 
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: isLoggedIn ? Routes.SPLASH : Routes.Main,
      getPages: AppRoutes.routes,
    );
  }
}

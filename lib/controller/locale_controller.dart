import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleController extends GetxController {
  final GetStorage boxStorage = GetStorage();
  Locale? initialLang;

  @override
  void onInit() {
    String? langCode = boxStorage.read('lang');
    if (langCode != null) {
      initialLang = Locale(langCode);
    } else {
      initialLang =const Locale('en', 'US');
    }
    super.onInit();
  }

  void changeLang(String langCode) {
    Locale locale = Locale(langCode);
    Get.updateLocale(locale);
    boxStorage.write('lang', langCode);
  }
}

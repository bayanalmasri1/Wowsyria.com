// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:wowsyria_com/controller/locale_controller.dart';


// ignore: use_key_in_widget_constructors
class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final LocaleController localeController = Get.find();

    return Drawer(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: CloseButton(
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                Center(
                  child: Image.asset(
                    "assets/images/logo2.png",
                    width: 400,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

             ElevatedButton(
  onPressed: () async {
    bool loggedIn = await isUserLoggedIn();
    if (loggedIn) {
      Get.snackbar(
        "تم تسجيل الدخول", 
        "لقد قمت بتسجيل الدخول مسبقًا.",
        backgroundColor: Colors.green[100],
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.toNamed('/login');
    }
  },
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
    backgroundColor: Colors.grey[200],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
  child: Text("login".tr,
      style: TextStyle(fontSize: 18, color: Colors.black)),
),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () => Get.toNamed('/register'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text("register".tr,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(thickness: 1, color: Colors.grey[300]),
       /*   ListTile(
            leading: Icon(Icons.language),
            title: Text(localeController.initialLang?.languageCode == 'ar'
                ? "عربي"
                : "English"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              String newLang =
                  localeController.initialLang?.languageCode == 'ar'
                      ? 'en'
                      : 'ar';
              localeController.changeLang(newLang);
            },
          ),*/
        ],
      ),
    );
  }
}

Future<bool> isUserLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  return token != null;
}

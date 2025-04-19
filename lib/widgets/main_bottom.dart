// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wowsyria_com/views/home/Pagehome/home_screen.dart';
import 'package:wowsyria_com/views/home/Pagehome/notfication_screen.dart';
import 'package:wowsyria_com/views/home/Pagehome/profile_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    Container(), // Placeholder - سيتم استبداله بناءً على الدور
    NotificationScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) async {
    if (index == 1) {
      // عند الضغط على أيقونة الفئات
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? role = prefs.getInt('user_role');
      
      if (role == 1 || role == 2) {
        Get.toNamed("/adminads"); // صفحة خاصة بالأدوار 1 و 2
      } else if (role == 3 || role == 4) {
        Get.toNamed('/superads'); // صفحة خاصة بالأدوار 3 و 4
      } else {
        Get.snackbar('خطأ', 'الدور غير معروف أو لم يتم تسجيل الدخول');
        return;
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
        floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        shape: const CircleBorder(),
        onPressed: () {
          Get.toNamed('/add');
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.teal,
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? Colors.orange : Colors.white,
                size: 35,
              ),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(
                Icons.category,
                color: _selectedIndex == 1 ? Colors.orange : Colors.white,
                size: 35,
              ),
              onPressed: () => _onItemTapped(1),
            ),
            const SizedBox(width: 40), // مساحة للزر العائم
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: _selectedIndex == 2 ? Colors.orange : Colors.white,
                size: 35,
              ),
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: Icon(
                Icons.person,
                color: _selectedIndex == 3 ? Colors.orange : Colors.white,
                size: 35,
              ),
              onPressed: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }
}
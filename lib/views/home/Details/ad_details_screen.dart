import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ListingDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> listing;

 


  void _launchWhatsApp(String phoneNumber) async {
    final url = 'https://wa.me/$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open WhatsApp';
    }
  }

  const ListingDetailsScreen({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listing['name']),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              listing['name'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('${"year".tr}: ${listing['year']}',
                style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 10),
            Text('${"price".tr}: \$${listing['price']}',
                style: const TextStyle(fontSize: 18, color: Colors.teal)),
            const SizedBox(height: 20),
            Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _launchWhatsApp(listing['phone_number']),
                      icon: const Icon(Icons.chat, color: Colors.white), // أيقونة داخل الزر
                      label: Text("confirm_booking".tr, style: const TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, // تغيير لون الزر إلى teal
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

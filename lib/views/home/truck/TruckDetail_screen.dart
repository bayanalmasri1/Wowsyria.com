import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class TruckDetailsPage extends StatelessWidget {
  final int truckId;

  TruckDetailsPage({required this.truckId});

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final url = "https://wa.me/$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  Future<Map<String, dynamic>> fetchTruckDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('https://www.wowsyria.com/truck/trucks/$truckId/'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load truck details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('truck_details'.tr),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchTruckDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${'error'.tr}: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('no_data'.tr));
          }

          var truck = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    truck['image'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  truck['title'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.teal),
                    SizedBox(width: 8),
                    Text('${'location'.tr}: ${truck['location']}'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.car_repair, color: Colors.teal),
                    SizedBox(width: 8),
                    Text('${'model'.tr}: ${truck['model']}'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.teal),
                    SizedBox(width: 8),
                    Text('${'year'.tr}: ${truck['year']}'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.attach_money, color: Colors.teal),
                    SizedBox(width: 8),
                    Text('${'price'.tr}: \$${truck['price']}'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.phone, color: Colors.teal),
                    SizedBox(width: 8),
                    Text('${'phone'.tr}: ${truck['phone_number']}'),
                  ],
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _launchWhatsApp(truck['phone_number']);
                    },
                    icon: Icon(Icons.chat, color: Colors.white),
                    label: Text('confirm_booking'.tr, style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

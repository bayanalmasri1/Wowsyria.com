import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:wowsyria_com/api/car_api.dart'; // استيراد GetX

class CarDetailsPage extends StatefulWidget {
  final int carId;
  CarDetailsPage({required this.carId});

  @override
  _CarDetailsPageState createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  late Future<Map<String, dynamic>> _carDetails;

  @override
  void initState() {
    super.initState();
    _carDetails = fetchCarDetails(widget.carId);
  }

  void _launchWhatsApp(String phoneNumber) async {
    final url = 'https://wa.me/$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('car_details'.tr)), // استخدام tr
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _carDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final car = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(car['image']),
                    SizedBox(height: 16),
                    Text(car['title'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.car_repair, color: Colors.teal),
                        SizedBox(width: 8),
                        Text( "${'brand'.tr}: ${car['brand']} ", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.model_training, color: Colors.teal),
                        SizedBox(width: 8),
                        Text("${'model'.tr}: ${car['model']}", style: TextStyle(fontSize: 18)), // استخدام tr
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.teal),
                        SizedBox(width: 8),
                        Text('year'.tr + ': ${car['year']}', style: TextStyle(fontSize: 18)), // استخدام tr
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.teal),
                        SizedBox(width: 8),
                        Text('location'.tr + ': ${car['location']}', style: TextStyle(fontSize: 18)), // استخدام tr
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.attach_money, color: Colors.teal),
                        SizedBox(width: 8),
                        Text('price'.tr+ ': \$${car['price']}', style: TextStyle(fontSize: 18)), // استخدام tr
                      ],
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => _launchWhatsApp(car['phone_number']),
                        icon: Icon(Icons.chat, color: Colors.white),
                        label: Text('confirm_booking'.tr, style: TextStyle(color: Colors.white)), // استخدام tr
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('No data available'.tr));
            }
          },
        ),
      ),
    );
  }
}

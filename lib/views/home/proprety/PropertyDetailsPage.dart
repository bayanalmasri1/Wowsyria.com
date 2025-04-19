// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:wowsyria_com/api/proptaty_api.dart';

class PropertyDetailPage extends StatefulWidget {
  final int propertyId;

  PropertyDetailPage({required this.propertyId});

  @override
  _PropertyDetailPageState createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  late Future<Map<String, dynamic>> _property;

  @override
  void initState() {
    super.initState();
    _property = fetchPropertyDetails(widget.propertyId);
  }

  void _launchWhatsApp(String phoneNumber) async {
    final Uri url = Uri.parse('https://wa.me/$phoneNumber');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not open WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('property_details'.tr),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _property,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('error'.tr + ': ${snapshot.error}'));
            }

            final property = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () async {
                await fetchPropertyDetails(widget.propertyId);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.title, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${'title'.tr}: ${property['title']}',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Image.network(property['image']),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.description, size: 20, color: Colors.teal),
                        SizedBox(width: 10),
                        Expanded(
                            child: Text('${'description'.tr}: ${property['description']}')),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.bed, size: 20, color: Colors.teal),
                        SizedBox(width: 10),
                        Text('${'bedrooms'.tr}: ${property['bedrooms']}'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.bathtub, size: 20, color: Colors.teal),
                        SizedBox(width: 10),
                        Text('${'bathrooms'.tr}: ${property['bathrooms']}'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.area_chart, size: 20, color: Colors.teal),
                        SizedBox(width: 10),
                        Text('${'area'.tr}: ${property['area']} m²'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 20, color: Colors.teal),
                        SizedBox(width: 10),
                        Text('${'location'.tr}: ${property['location']}'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.attach_money, size: 20, color: Colors.teal),
                        SizedBox(width: 10),
                        Text('${'price'.tr}: \$${property['price']}'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.visibility, size: 20, color: Colors.teal),
                        SizedBox(width: 10),
                        Text('${'views'.tr}: ${property['views']}'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 20, color: Colors.teal),
                        SizedBox(width: 10),
                        Text('${'phone'.tr}: ${property['phone_number']}'),
                      ],
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _launchWhatsApp(property['phone_number']);
                        },
                        icon: Icon(Icons.chat, color: Colors.white),
                        label: Text('confirm_booking'.tr,
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

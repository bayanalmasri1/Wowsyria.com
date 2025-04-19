import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart';

class ListingService {
  static Future<void> submitListing({
    required BuildContext context,
    required String category,
    required String title,
    required String description,
    required String location,
    required String price,
    required String saleType,
    File? imageFile, // تعديل: استقبال ملف صورة حقيقي
    String? brand,
    String? model,
    int? year,
    String? area,
    int? bedrooms,
    int? bathrooms,
  }) async {
    String url = '';
    final fields = <String, String>{};
    String saleTypeValue = saleType == 'For Sale' ? 'sale' : 'rent';

    if (category == 'Car') {
      url = 'https://www.wowsyria.com/car/cars/create/';
      fields.addAll({
        "title": title,
        "description": description,
        "brand": brand ?? '',
        "model": model ?? '',
        "year": (year ?? 0).toString(),
        "location": location,
        "price": price,
        "sale_type": saleTypeValue,
        "views": '0', // ثابت بناءً على البيانات المقدمة
      });
    } else if (category == 'Apartment') {
      url = 'https://www.wowsyria.com/property/properties/create/';
      fields.addAll({
        "title": title,
        "description": description,
        "area": area ?? '-52', // ثابت بناءً على البيانات المقدمة
        "bedrooms": bedrooms?.toString() ?? '2147483647',
        "bathrooms": bathrooms?.toString() ?? '2147483647',
        "location": location,
        "price": price,
        "sale_type": saleTypeValue,
        "views": '0', // ثابت بناءً على البيانات المقدمة
      });
    } else if (category == 'Truck') {
      url = 'https://www.wowsyria.com/truck/trucks/create/';
      fields.addAll({
        "title": title,
        "description": description,
        "brand": brand ?? '',
        "model": model ?? '',
        "year": (year ?? 0).toString(),
        "location": location,
        "price": price,
        "sale_type": saleTypeValue,
        "views": '0', // ثابت بناءً على البيانات المقدمة
      });
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No authentication token found')),
        );
        return;
      }

      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers.addAll({
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        })
        ..fields.addAll(fields);

      // إضافة الصورة إن وُجدت
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          filename: basename(imageFile.path),
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing added successfully')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response.statusCode}\n${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wowsyria_com/model/propraty_model.dart';
Future<List<Property>> fetchProperties(String saleType) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final url = Uri.parse(
      'https://www.wowsyria.com/property/properties/?sale_type=$saleType');

  final response = await http.get(
    url,
    headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    final List propertiesJson = body['results'];
    return propertiesJson.map((json) => Property.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load properties');
  }
}


Future<Map<String, dynamic>> fetchPropertyDetails(int id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');
  final url = 'https://www.wowsyria.com/property/properties/$id/';
  final response = await http.get(Uri.parse(url), headers: {
    'accept': 'application/json',
    'Authorization': 'Bearer $token'
  });

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load property details');
  }
}

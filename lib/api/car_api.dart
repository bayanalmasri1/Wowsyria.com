import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wowsyria_com/model/Car_model.dart';

Future<List<CarModel>> fetchCars(String saleType) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final response = await http.get(
    Uri.parse('https://www.wowsyria.com/car/cars/?sale_type=$saleType'),
    headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List carsJson = data['results'];
    return carsJson.map((json) => CarModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load cars');
  }
}

Future<Map<String, dynamic>> fetchCarDetails(int id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');
  final response = await http.get(
    Uri.parse('https://www.wowsyria.com/car/cars/$id/'),
    headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load car details');
  }
}

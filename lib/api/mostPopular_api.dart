import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wowsyria_com/model/Car_model.dart';
import 'package:wowsyria_com/model/Truck_model.dart';
import 'package:wowsyria_com/model/propraty_model.dart';

Future<List<CarModel>> fetchPopularCars() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final response = await http.get(
    Uri.parse('https://www.wowsyria.com/car/cars/most-popular/'),
    headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final List results = jsonData['results'];
    return results.map((item) => CarModel.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load popular cars');
  }
}

  
Future<List<Property>> fetchPopularProperties() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final response = await http.get(
    Uri.parse('https://www.wowsyria.com/property/properties/most-popular/'),
    headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List results = data['results'];
    return results.map<Property>((item) => Property.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load popular properties');
  }
}


Future<List<TruckModel>> fetchPopularTrucks() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final response = await http.get(
    Uri.parse('https://www.wowsyria.com/truck/trucks/most-popular/'),
    headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List results = data['results'];
    return results.map<TruckModel>((item) => TruckModel.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load popular trucks');
  }
}

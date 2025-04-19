import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wowsyria_com/model/Truck_model.dart';

Future<List<TruckModel>> fetchTrucks(String saleType) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final response = await http.get(
    Uri.parse('https://www.wowsyria.com/truck/trucks/?sale_type=$saleType'),
    headers: {'accept': 'application/json','Authorization': 'Bearer $token',},
  ); 

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List trucksJson = data['results'];
    return trucksJson.map((json) => TruckModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load trucks');
  }
}



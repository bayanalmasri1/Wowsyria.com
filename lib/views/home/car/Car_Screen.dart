import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wowsyria_com/api/adminadsApi.dart';
import 'package:wowsyria_com/api/car_api.dart';

import 'package:wowsyria_com/model/Car_model.dart';
import 'package:wowsyria_com/views/home/car/Car_details.dart';

class CarListScreen extends StatelessWidget {
  final String saleType;
  const CarListScreen({super.key, required this.saleType});

  Future<void> deleteCar(int id) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http.delete(
      Uri.parse('https://www.wowsyria.com/car/cars/delete/$id/'),
      headers: headers,
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete car');
    }
  }

  Future<int?> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_role');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Cars for ${saleType == "sale" ? "Sale" : "Rent"}'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<CarModel>>(
        future: fetchCars(saleType),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No cars found."));
          }

          final cars = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              await fetchCars(saleType);
            },
            child: ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return FutureBuilder<int?>(
                  future: _getUserRole(),
                  builder: (context, roleSnapshot) {
                    final userRole = roleSnapshot.data ?? 0;
                    return InkWell(
                      onTap: () {
                        Get.to(() => CarDetailsPage(carId: car.id));
                      },
                      child: Card(
                        margin: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  car.image,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        car.title,
                                        style: const TextStyle(
                                            fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      Text("Location: ${car.location}"),
                                      Text("Model: ${car.model}"),
                                      Text("Price: ${car.price} \$"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (userRole == 1 || userRole == 2)
                              Positioned(
                                top: 10,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () async {
                                    final confirm = await Get.dialog<bool>(
                                      AlertDialog(
                                        title: const Text('Delete Car'),
                                        content: const Text('Are you sure you want to delete this car?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Get.back(result: false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Get.back(result: true),
                                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      try {
                                        await deleteCar(car.id);
                                        Get.snackbar(
                                          'Success',
                                          'Car deleted successfully.',
                                          backgroundColor: Colors.green.withOpacity(0.8),
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                        Get.off(() => CarListScreen(saleType: saleType));
                                      } catch (e) {
                                        Get.snackbar(
                                          'Error',
                                          'Failed to delete the car.',
                                          backgroundColor: Colors.red.withOpacity(0.8),
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

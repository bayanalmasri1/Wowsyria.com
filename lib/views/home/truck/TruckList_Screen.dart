import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wowsyria_com/api/adminadsApi.dart';
import 'package:wowsyria_com/api/truck_api.dart';
import 'package:wowsyria_com/model/Truck_model.dart';
import 'package:wowsyria_com/views/home/truck/TruckDetail_screen.dart';
import 'package:http/http.dart' as http;

class TruckListScreen extends StatefulWidget {
  final String saleType;
  const TruckListScreen({super.key, required this.saleType});

  @override
  State<TruckListScreen> createState() => _TruckListScreenState();
}

class _TruckListScreenState extends State<TruckListScreen> {
  late Future<List<TruckModel>> _truckFuture;
  int? userRole;

  @override
  void initState() {
    super.initState();
    _truckFuture = fetchTrucks(widget.saleType);
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getInt('user_role');
    });
  }

  Future<void> deleteTruck(int id) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http.delete(
      Uri.parse('https://www.wowsyria.com/property/properties/delete/$id/'),
      headers: headers,
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete truck');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Trucks for ${widget.saleType == "sale" ? "Sale" : "Rent"}'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<TruckModel>>(
        future: _truckFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No trucks found."));
          }

          final trucks = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _truckFuture = fetchTrucks(widget.saleType);
              });
            },
            child: ListView.builder(
              itemCount: trucks.length,
              itemBuilder: (context, index) {
                final truck = trucks[index];
                return Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => TruckDetailsPage(truckId: truck.id));
                      },
                      child: Card(
                        margin: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              truck.image,
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
                                    truck.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, color: Colors.teal),
                                      const SizedBox(width: 8),
                                      Text("Location: ${truck.location}"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.car_repair, color: Colors.teal),
                                      const SizedBox(width: 8),
                                      Text("Model: ${truck.model}"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.attach_money, color: Colors.teal),
                                      const SizedBox(width: 8),
                                      Text("Price: ${truck.price} \$"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (userRole == 1 || userRole == 2)
                      Positioned(
                        top: 20,
                        right: 20,
                        child: GestureDetector(
                          onTap: () async {
                            final confirm = await Get.dialog<bool>(
                              AlertDialog(
                                title: const Text('Delete Truck'),
                                content: const Text('Are you sure you want to delete this truck?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(result: false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Get.back(result: true),
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              try {
                                await deleteTruck(truck.id);
                                Get.snackbar(
                                  'Success',
                                  'Truck deleted successfully.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green.withOpacity(0.8),
                                  colorText: Colors.white,
                                );
                                setState(() {
                                  _truckFuture = fetchTrucks(widget.saleType);
                                });
                              } catch (e) {
                                Get.snackbar(
                                  'Error',
                                  'Failed to delete the truck.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red.withOpacity(0.8),
                                  colorText: Colors.white,
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
                );
              },
            ),
          );
        },
      ),
    );
  }
}

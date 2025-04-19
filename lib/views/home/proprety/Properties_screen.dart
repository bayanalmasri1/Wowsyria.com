import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wowsyria_com/api/adminadsApi.dart';
import 'package:wowsyria_com/api/proptaty_api.dart';
import 'package:wowsyria_com/model/propraty_model.dart';
import 'package:wowsyria_com/views/home/proprety/PropertyDetailsPage.dart';
import 'package:http/http.dart' as http;

class PropertyListScreen extends StatelessWidget {
  final String saleType;

  const PropertyListScreen({super.key, required this.saleType});

  Future<void> deleteProperty(int id) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http.delete(
      Uri.parse('https://www.wowsyria.com/property/properties/delete/$id/'),
      headers: headers,
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete property');
    }
  }

  Future<int?> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_role');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: _getUserRole(),
      builder: (context, roleSnapshot) {
        final userRole = roleSnapshot.data ?? 0;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text('Properties for ${saleType == "sale" ? "Sale" : "Rent"}'),
            centerTitle: true,
          ),
          body: FutureBuilder<List<Property>>(
            future: fetchProperties(saleType),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No properties found."));
              }

              final properties = snapshot.data!;
              return RefreshIndicator(
                onRefresh: () async {
                  await fetchProperties(saleType);
                },
                child: ListView.builder(
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    final property = properties[index];
                    return InkWell(
                      onTap: () {
                        Get.to(() => PropertyDetailPage(propertyId: property.id));
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
                                  property.image,
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
                                        property.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text("Location: ${property.location}"),
                                      Text("Area: ${property.area} m²"),
                                      Text("Price: \$${property.price}"),
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
                                        title: const Text('Delete Property'),
                                        content: const Text('Are you sure you want to delete this property?'),
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
                                        await deleteProperty(property.id);
                                        Get.snackbar(
                                          'Success',
                                          'Property deleted successfully.',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.green.withOpacity(0.8),
                                          colorText: Colors.white,
                                        );
                                        Get.off(() => PropertyListScreen(saleType: saleType));
                                      } catch (e) {
                                        Get.snackbar(
                                          'Error',
                                          'Failed to delete the property.',
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
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

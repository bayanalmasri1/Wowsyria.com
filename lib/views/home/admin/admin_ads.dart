import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowsyria_com/controller/adminads_controller.dart';
import 'package:wowsyria_com/views/home/admin/admincreate.dart';
import 'package:wowsyria_com/views/home/admin/admindetails.dart';

class HomeView extends StatelessWidget {
  final SuperAdController controller = Get.put(SuperAdController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Ads'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchSuperAds(),
          child: ListView.builder(
            itemCount: controller.superAds.length,
            itemBuilder: (context, index) {
              final ad = controller.superAds[index];
              return Card(
                margin: const EdgeInsets.all(8),
                elevation: 2,
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      ad.imagePath??'',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                  title: Text(
                    ad.description.length > 30
                        ? '${ad.description.substring(0, 30)}...'
                        : ad.description,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('ID: ${ad.id}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    controller.selectedAd.value = ad;
                    Get.to(() => AdDetailView());
                  },
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => CreateAdView()),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}


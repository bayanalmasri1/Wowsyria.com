import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowsyria_com/api/mostPopular_api.dart';
import 'package:wowsyria_com/model/Truck_model.dart';

class PopularTrucksPage extends StatelessWidget {
  const PopularTrucksPage({Key? key}) : super(key: key);

  void _onImageTap(BuildContext context, TruckModel truck) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.teal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(truck.image, fit: BoxFit.cover),
              const SizedBox(height: 12),
              Text(truck.title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 8),
              Text("${'brand'.tr}: ${truck.brand}",
                  style: const TextStyle(color: Colors.white)),
              Text("${'model'.tr}: ${truck.model}",
                  style: const TextStyle(color: Colors.white)),
              Text("${'year'.tr}: ${truck.year}",
                  style: const TextStyle(color: Colors.white)),
              Text("${'location'.tr}: ${truck.location}",
                  style: const TextStyle(color: Colors.white)),
              Text("${'price'.tr}: \$${truck.price}",
                  style: const TextStyle(color: Colors.white)),
              Text("${'saleType'.tr}: ${truck.saleType}",
                  style: const TextStyle(color: Colors.white)),
              Text("${'views'.tr}: ${truck.views}",
                  style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('close'.tr), // ترجمة النص
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            'mostPopularTruck'.tr, // ترجمة النص
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        FutureBuilder<List<TruckModel>>(
          future: fetchPopularTrucks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text("errorLoadingProperties".tr)); // ترجمة النص
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("noPropertiesFound".tr)); // ترجمة النص
            }

            final trucks = snapshot.data!;
            return CarouselSlider(
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                aspectRatio: 16 / 9,
                autoPlayInterval: const Duration(seconds: 3),
              ),
              items: trucks.map((truck) {
                return GestureDetector(
                  onTap: () => _onImageTap(context, truck),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        truck.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

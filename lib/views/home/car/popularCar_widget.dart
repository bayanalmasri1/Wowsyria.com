import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowsyria_com/api/mostPopular_api.dart';
import 'package:wowsyria_com/model/Car_model.dart';

class PopularCarsPage extends StatelessWidget {
  const PopularCarsPage({Key? key}) : super(key: key);

  void _onImageTap(BuildContext context, CarModel car) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.teal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(car.image, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(car.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 5),
            Text("${'brand'.tr} ${car.brand}", style: const TextStyle(color: Colors.white)),
            Text("${"model".tr}: ${car.model}", style: const TextStyle(color: Colors.white)),
            Text("${'year'.tr}:: ${car.year}", style: const TextStyle(color: Colors.white)),
            Text("${'location'.tr} ${car.location}", style: const TextStyle(color: Colors.white)),
            Text("${'price'.tr} \$${car.price}", style: const TextStyle(color: Colors.white)),
        
            const SizedBox(height: 9),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
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
          padding: EdgeInsets.all(12),
          child: Text(
           "most_popular_car".tr,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
        FutureBuilder<List<CarModel>>(
          future: fetchPopularCars(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return  Center(child: Text("error".tr));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return  Center(child: Text("empty".tr));
            }

            final cars = snapshot.data!;
            return CarouselSlider(
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                aspectRatio: 16 / 9,
                autoPlayInterval: const Duration(seconds: 3),
              ),
              items: cars.map((car) {
                return GestureDetector(
                  onTap: () => _onImageTap(context, car),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(car.image, fit: BoxFit.cover, width: double.infinity),
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

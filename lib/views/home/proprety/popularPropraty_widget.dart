import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowsyria_com/api/mostPopular_api.dart';
import 'package:wowsyria_com/model/propraty_model.dart';

class PopularPropretyPage extends StatelessWidget {
  const PopularPropretyPage({Key? key}) : super(key: key);

  void _onImageTap(BuildContext context, Property property) {
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
            Image.network(property.image, fit: BoxFit.cover),
            const SizedBox(height: 9),
            Text(property.title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 8),
            Text("${"model".tr}: ${property.bedrooms}",
                style: const TextStyle(color: Colors.white)),
            Text("${"year".tr}: ${property.bathrooms}",
                style: const TextStyle(color: Colors.white)),
            Text("${"location".tr}: ${property.area}",
                style: const TextStyle(color: Colors.white)),
            Text("${"price".tr}: \$${property.price}",
                style: const TextStyle(color: Colors.white)),
            Text("${"sale_type".tr}: ${property.saleType}",
                style: const TextStyle(color: Colors.white)),
            Text("${"views".tr}: ${property.views}",
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text( "close".tr),
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
            "most_popular_properties".tr,
            style:const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        FutureBuilder<List<Property>>(
          future: fetchPopularProperties(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return  Center(child: Text("error_loading_properties".tr));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return  Center(child: Text( "no_properties_found".tr));
            }

            final properties = snapshot.data!;
            return CarouselSlider(
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                aspectRatio: 16 / 9,
                autoPlayInterval: const Duration(seconds: 3),
              ),
              items: properties.map((property) {
                return GestureDetector(
                  onTap: () => _onImageTap(context, property),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        property.image,
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

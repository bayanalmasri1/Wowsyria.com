import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowsyria_com/views/home/car/Car_Screen.dart';
import 'package:wowsyria_com/views/home/proprety/Properties_screen.dart';
import 'package:wowsyria_com/views/home/truck/TruckList_Screen.dart';

Widget buildOptionsSheet(BuildContext context, String category) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              category, 
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 20,
          children: [
            _buildOption(context, 'WOWSYRIA.COM', 'For Sale', category, 'sale'),
            _buildOption(context, 'WOWSYRIA.COM', 'For Rent', category, 'rent'),
            // تم تعليق خيارات الترتيب لأنها غير مفعلة حالياً
            // _buildOption(context, 'WOWSYRIA.COM', 'Price High to Low', category, ''),
            // _buildOption(context, 'WOWSYRIA.COM', 'Price Low to High', category, ''),
          ],
        ),
      ],
    ),
  );
}

Widget _buildOption(
    BuildContext context, String title, String subtitle, String category, String saleType) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);

      if (category ==  "properties".tr) {
        Get.to(() => PropertyListScreen(saleType: saleType));
      } else if (category ==  "cars".tr) {
        Get.to(() => CarListScreen(saleType: saleType));
      } else if (category ==  "trucks".tr) {
       Get.to(() => TruckListScreen(saleType: saleType));
      }
    },
    child: Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

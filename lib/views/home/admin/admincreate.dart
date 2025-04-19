import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowsyria_com/controller/adminads_controller.dart';

class CreateAdView extends StatelessWidget {
  final SuperAdController controller = Get.find();

  CreateAdView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Ad'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() => controller.imagePath.value != null
                  ? Image.file(
                      File(controller.imagePath.value!),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(child: Icon(Icons.image, size: 50)),
                    )),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => controller.pickImage(),
                child: const Text('Select Image'),
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) => controller.description(value),
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Obx(() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        controller.isLoading.value = true;
                        await controller.createAd();
                        controller.isLoading.value = false;
                        Get.snackbar('Success', 'Ad created successfully',
                            backgroundColor: Colors.green,
                            colorText: Colors.white);
                        controller.fetchSuperAds(); // لإعادة تحميل الصفحة
                        Get.back(); // للرجوع إلى الصفحة الرئيسية
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Create Ad',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              Obx(() => controller.errorMessage.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : const SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}

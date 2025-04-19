import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wowsyria_com/controller/adminads_controller.dart';

class AdDetailView extends StatelessWidget {
  final SuperAdController controller = Get.find();

  AdDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ad Details'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Obx(() {
        final ad = controller.selectedAd.value;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'ad-image-${ad.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    ad.imagePath ?? '',
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 250,
                      color: Colors.grey[200],
                      child: const Center(
                          child: Icon(Icons.broken_image, size: 50)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Description:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ad.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                'ID: ${ad.id}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this ad?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await controller.deleteAd(controller.selectedAd.value.id!);
              Get.back(); // إغلاق الـ Dialog
              Get.back(); // الرجوع من صفحة التفاصيل
              controller.fetchSuperAds(); // تحديث الصفحة الرئيسية
              Get.snackbar('Deleted', 'Ad deleted successfully',
                  backgroundColor: Colors.red, colorText: Colors.white);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

 void _showEditDialog(BuildContext context) {
  final ad = controller.selectedAd.value;
  final descriptionController = TextEditingController(text: ad.description);
  File? newImageFile;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Ad'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          // Show current image thumbnail
          if (ad.imagePath != null)
            Column(
              children: [
                const Text('Current Image:'),
                const SizedBox(height: 8),
                Image.network(
                  ad.imagePath!,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.broken_image),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ElevatedButton(
            onPressed: () async {
              final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                newImageFile = File(pickedFile.path);
                Get.snackbar('Success', 'New image selected');
              }
            },
            child: const Text('Change Image'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
          onPressed: () async {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            try {
              scaffoldMessenger.showSnackBar(
                const SnackBar(
                  content: Text('Updating ad...'),
                  duration: Duration(seconds: 2),
              ));

              await controller.updateAd(
                ad.id!,
                descriptionController.text,
                imageFile: newImageFile, // Pass the new image or null
              );

              Get.back(); // Close dialog
              Get.back(); // Go back to previous screen

              scaffoldMessenger.showSnackBar(
                const SnackBar(
                  content: Text('Updated successfully'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );

              await controller.fetchSuperAds();
            } catch (e) {
              print('💥 Error: $e');
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text('Update failed: ${e.toString()}'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 5),
                ),
              );
            }
          },
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
}


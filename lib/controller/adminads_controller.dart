import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:wowsyria_com/api/adminadsApi.dart';

// Controllers
class SuperAdController extends GetxController {
  final SuperAdRepository _repository = SuperAdRepository();

  var isLoading = true.obs;
  var superAds = <SuperAd>[].obs;
  var selectedAd = SuperAd(id: 0, description: '', imagePath: '').obs;
  final description = ''.obs;
  final imagePath = Rx<String?>(null);
  final uploadProgress = Rx<double?>(null);
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSuperAds();
  }

  Future<void> fetchSuperAds() async {
    try {
      isLoading(true);
      final headers = await AuthService.getAuthHeaders();
      final response = await http.get(
          Uri.parse('https://www.wowsyria.com/super-ads/super-ads/'),
          headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final ads = (data['results'] as List)
            .map((ad) => SuperAd.fromJson(ad))
            .toList();
        superAds.assignAll(ads); // ✅ هنا التعديل المهم
      } else {
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        _showError('Failed to load ads');
      }
    } catch (e) {
      _showError('Error fetching ads: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteAd(int id) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http.delete(
      Uri.parse('https://www.wowsyria.com/super-ads/super-ads/$id/delete/'),
      headers: headers, // ✅ أضف الهيدر
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete ad');
    }
  }

  Future<SuperAd> updateAd(int id, String description,
      {File? imageFile}) async {
    try {
      final headers = await AuthService.getAuthHeaders();
      final uri =
          Uri.parse('https://www.wowsyria.com/super-ads/super-ads/$id/edit/');

      final request = http.MultipartRequest('PATCH', uri)
        ..headers.addAll(headers)
        ..fields['description'] = description;

      // If no new image is provided, use the existing image path
      if (imageFile == null && selectedAd.value.imagePath != null) {
        final existingImage = File(selectedAd.value.imagePath!);
        if (await existingImage.exists()) {
          request.files.add(
              await http.MultipartFile.fromPath('image', existingImage.path));
        } else {
          throw Exception('Existing image file not found');
        }
      } else if (imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imageFile.path));
      } else {
        throw Exception('Image is required for update');
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return SuperAd.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update ad: ${response.body}');
      }
    } catch (e) {
      throw Exception('Update error: $e');
    }
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );

      if (image != null) {
        final file = File(image.path);
        final sizeInMB = await file.length() / (1024 * 1024);

        if (sizeInMB > 2) {
          throw Exception('Image size should be less than 2MB');
        }

        imagePath.value = image.path;
      }
    } catch (e) {
      _showError('Failed to pick image: ${e.toString()}');
    }
  }

  Future<void> createAd() async {
    if (description.isEmpty) {
      _showError('Please enter a description');
      return;
    }

    isLoading(true);
    errorMessage('');
    uploadProgress(null);

    try {
      final ad = SuperAd(
        description: description.value,
        imagePath: imagePath.value ?? '',
      );

      final newAd = await _repository.createSuperAd(ad);
      superAds.add(newAd);
      Get.back();
      _showSuccess('Ad created successfully');
    } catch (e) {
      _showError('An error occurred: ${e.toString()}');
    } finally {
      isLoading(false);
      uploadProgress(null);
    }
  }

  void _showError(String message) {
    errorMessage(message);
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.teal,
      colorText: Colors.white,
    );
  }
}

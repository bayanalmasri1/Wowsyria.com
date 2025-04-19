import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wowsyria_com/api/ListingService_api.dart';

class AddListingScreen extends StatefulWidget {
  @override
  _AddListingScreenState createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final _formKey = GlobalKey<FormState>();

  String selectedCategory = 'Apartment';
  String selectedSaleType = 'For Rent';

  File? _image;
  final ImagePicker _picker = ImagePicker();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final locationController = TextEditingController();
  final priceController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final bedroomsController = TextEditingController();
  final bathroomsController = TextEditingController();
  final areaController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('add_listing'.tr, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('select_category'.tr),
                Row(
                  children: [
                    _buildCategoryButton('Car', Icons.directions_car),
                    const SizedBox(width: 10),
                    _buildCategoryButton('Apartment', Icons.apartment),
                    const SizedBox(width: 10),
                    _buildCategoryButton('Truck', Icons.local_shipping),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('select_sale_type'.tr),
                Row(
                  children: [
                    _buildSaleTypeButton('For Sale', Icons.attach_money),
                    const SizedBox(width: 10),
                    _buildSaleTypeButton('For Rent', Icons.vpn_key),
                  ],
                ),
                const SizedBox(height: 20),
                _buildImageUploader(),
                const SizedBox(height: 20),
                if (selectedCategory == 'Apartment') ...[
                  _buildInputField('title'.tr, titleController, hint: 'hint_apartment_title'.tr),
                  _buildInputField('bedrooms'.tr, bedroomsController, hint: 'hint_bedrooms'.tr),
                  _buildInputField('bathrooms'.tr, bathroomsController, hint: 'hint_bathrooms'.tr),
                  _buildInputField('area'.tr, areaController, hint: 'hint_area'.tr),
                  _buildInputField('location'.tr, locationController, hint: 'hint_location'.tr),
                  _buildInputField('price'.tr, priceController, hint: 'hint_price'.tr),
                ] else if (selectedCategory == 'Truck' || selectedCategory == 'Car') ...[
                  _buildInputField('title'.tr, titleController, hint: 'hint_car_title'.tr),
                  _buildInputField('description'.tr, descriptionController, hint: 'hint_description'.tr),
                  _buildInputField('brand'.tr, brandController, hint: 'hint_brand'.tr),
                  _buildInputField('model'.tr, modelController, hint: 'hint_model'.tr),
                  _buildInputField('year'.tr, yearController, hint: 'hint_year'.tr),
                  _buildInputField('location'.tr, locationController, hint: 'hint_location'.tr),
                  _buildInputField('price'.tr, priceController, hint: 'hint_price'.tr),
                ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildConfirmButton(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCategoryButton(String label, IconData icon) {
    bool isSelected = selectedCategory == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.teal[100] : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.teal),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.teal : Colors.grey),
              const SizedBox(height: 4),
              Text(label.tr, style: TextStyle(color: isSelected ? Colors.teal : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaleTypeButton(String label, IconData icon) {
    bool isSelected = selectedSaleType == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedSaleType = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.teal[100] : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.teal),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.teal : Colors.grey),
              const SizedBox(height: 4),
              Text(label.tr, style: TextStyle(color: isSelected ? Colors.teal : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploader() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[100],
        ),
        child: _image == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text('upload_image'.tr, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _image!,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {String? hint}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '${label.tr} ${'is_required'.tr}';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            String? imageBase64;
            if (_image != null) {
              final bytes = await _image!.readAsBytes();
              imageBase64 = base64Encode(bytes);
            }
            await ListingService.submitListing(
              context: context,
              category: selectedCategory,
              title: titleController.text,
              description: descriptionController.text,
              location: locationController.text,
              price: priceController.text,
              saleType: selectedSaleType,
              brand: brandController.text,
              model: modelController.text,
              year: int.tryParse(yearController.text),
              imageFile: _image,
              area: areaController.text,
              bathrooms: int.tryParse(bathroomsController.text),
              bedrooms: int.tryParse(bedroomsController.text),
            );

            setState(() {
              titleController.clear();
              descriptionController.clear();
              locationController.clear();
              priceController.clear();
              brandController.clear();
              modelController.clear();
              yearController.clear();
              areaController.clear();
              bedroomsController.clear();
              bathroomsController.clear();
              _image = null;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'confirm'.tr + ' ${selectedCategory.tr}',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowsyria_com/controller/ads_controller.dart';
import 'package:wowsyria_com/model/superadshomeModel.dart';

enum AdType { car, truck, property }

class SuperAdsPage extends StatefulWidget {
  @override
  State<SuperAdsPage> createState() => _SuperAdsPageState();
}

class _SuperAdsPageState extends State<SuperAdsPage> {
  final carController = Get.put(SuperAdsCarController());
  final truckController = Get.put(SuperAdsTruckController());
  final propertyController = Get.put(SuperAdsPropertyController());

  AdType selectedType = AdType.car;

  @override
  void initState() {
    super.initState();
    // قم بتحميل البيانات عند بداية الصفحة
    _refreshData();
  }

  Future<void> _refreshData() async {
    try {
      switch (selectedType) {
        case AdType.car:
          await carController.fetchSuperCars();
          break;
        case AdType.truck:
          await truckController.fetchSuperTruckAds();
          break;
        case AdType.property:
          await propertyController.fetchSuperAdsProperty();
          break;
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحديث البيانات: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my_ads'.tr),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(child: _buildAdList()),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ToggleButtons(
        isSelected: [
          selectedType == AdType.car,
          selectedType == AdType.truck,
          selectedType == AdType.property,
        ],
        onPressed: (index) {
          setState(() {
            selectedType = AdType.values[index];
            _refreshData();
          });
        },
        borderRadius: BorderRadius.circular(12),
        selectedColor: Colors.white,
        fillColor: Colors.teal,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('cars'.tr),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('trucks'.tr),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('properties'.tr),
          ),
        ],
      ),
    );
  } 

  Widget _buildAdList() {
    switch (selectedType) {
      case AdType.car:
        return _buildAdListView(carController);
      case AdType.truck:
        return _buildAdListView(truckController);
      case AdType.property:
        return _buildAdListView(propertyController);
    }
  }

  Widget _buildAdListView(dynamic controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(controller.errorMessage.value),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _refreshData,
                child: Text("try Again"),
              ),
            ],
          ),
        );
      }

      if (controller.superAds.isEmpty) {
        return Center(child: Text("no_ads".tr));
      }

      return RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          itemCount: controller.superAds.length,
          itemBuilder: (context, index) {
            final ad = controller.superAds[index];
            return _buildAdItem(ad, controller);
          },
        ),
      );
    });
  }

  Widget _buildAdItem(dynamic ad, dynamic controller) {
    switch (selectedType) {
      case AdType.car:
        return _buildCarAdItem(ad as SuperAdCarModel, controller);
      case AdType.truck:
        return _buildTruckAdItem(ad as SuperAdsTruckModel, controller);
      case AdType.property:
        return _buildPropertyAdItem(ad as SuperAdsPropertyModel, controller);
    }
  }

  Widget _buildCarAdItem(SuperAdCarModel ad, SuperAdsCarController controller) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: ad.image.isNotEmpty
            ? Image.network(ad.image, width: 50, height: 50, fit: BoxFit.cover)
            : Icon(Icons.directions_car, size: 50, color: Colors.blue),
        title: Text(ad.title ?? 'no_title'.tr),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${'brand'.tr}: ${ad.brand}'),
            Text('${'model'.tr}: ${ad.model}'),
            Text('${'price'.tr}: ${ad.price}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _confirmDelete(ad.id, controller),
        ),
      ),
    );
  }

  Widget _buildTruckAdItem(SuperAdsTruckModel ad, SuperAdsTruckController controller) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: ad.image.isNotEmpty
            ? Image.network(ad.image, width: 50, height: 50, fit: BoxFit.cover)
            : Icon(Icons.local_shipping, size: 50, color: Colors.orange),
        title: Text(ad.title ?? 'no_title'.tr),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${'brand'.tr}: ${ad.brand}'),
            Text('${'year'.tr}: ${ad.year}'),
            Text('${'price'.tr}: ${ad.price}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _confirmDelete(ad.id, controller),
        ),
      ),
    );
  }

  Widget _buildPropertyAdItem(SuperAdsPropertyModel ad, SuperAdsPropertyController controller) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: ad.image.isNotEmpty
            ? Image.network(ad.image, width: 50, height: 50, fit: BoxFit.cover)
            : Icon(Icons.home, size: 50, color: Colors.green),
        title: Text(ad.title ?? 'no_title'.tr),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${'location'.tr}: ${ad.location}'),
            Text('${'bedrooms'.tr}: ${ad.bedrooms}'),
            Text('${'price'.tr}: ${ad.price}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _confirmDelete(ad.id, controller),
        ),
      ),
    );
  }

  void _confirmDelete(int id, dynamic controller) {
    Get.defaultDialog(
      title: 'confirm_delete'.tr,
      middleText: 'are_you_sure'.tr,
      textConfirm: 'yes'.tr,
      textCancel: 'no'.tr,
      confirmTextColor: Colors.white,
      onConfirm: () async {
        try {
          if (controller is SuperAdsCarController) {
            await controller.deleteCar(id);
          } else if (controller is SuperAdsTruckController) {
            await controller.deleteTruck(id);
          } else if (controller is SuperAdsPropertyController) {
            await controller.deleteProperty(id);
          }

          Get.back(); // لإغلاق صندوق الحوار
          await _refreshData(); // لإعادة تحميل البيانات
        } catch (e) {
          Get.back(); // تأكد من إغلاق الصندوق حتى لو حدث خطأ
          Get.snackbar('خطأ', 'فشل في حذف الإعلان: ${e.toString()}');
        }
      },
    );
  }
}

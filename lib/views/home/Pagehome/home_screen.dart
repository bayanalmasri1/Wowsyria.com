import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowsyria_com/controller/adminads_controller.dart';
import 'package:wowsyria_com/views/home/car/popularCar_widget.dart';
import 'package:wowsyria_com/views/home/proprety/popularPropraty_widget.dart';
import 'package:wowsyria_com/views/home/truck/popularTruck_widget.dart';
import 'package:wowsyria_com/widgets/drawer.dart';
import 'package:wowsyria_com/widgets/properties_sheet.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SuperAdController superAdsController = Get.put(SuperAdController());
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _refreshData() async {
    await superAdsController.fetchSuperAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo2.png',
          height: 25,
        ),
        elevation: 0,
      ),
      drawer: CustomDrawer(),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        color: Colors.teal,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PopularCarsPage(),
              const SizedBox(height: 20),
              const PopularPropretyPage(),
              const SizedBox(height: 20),
              const PopularTrucksPage(),
              const SizedBox(height: 20),

              /// قسم الإعلانات
              Obx(() {
                if (superAdsController.superAds.isEmpty) {
                  return Center(
                    child: Text(
                      "no_ads".tr,
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "super_ads".tr,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: superAdsController.isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: superAdsController.superAds.length,
                              itemBuilder: (context, index) {
                                final ad = superAdsController.superAds[index];
                                return GestureDetector(
                                  onTap: () {
                                    _showAdDetails(context,ad.imagePath ,ad.description);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          ad.imagePath,
                                          width: 120,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image, size: 50),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 30),

              /// الأزرار الرئيسية
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildImageIconButton(
                        context,
                        imagePath: 'assets/images/pp.png',
                        label: "properties".tr,
                      ),
                      const SizedBox(width: 40),
                      _buildImageIconButton(
                        context,
                        imagePath: 'assets/images/cc.png',
                        label: "cars".tr,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildImageIconButton(
                    context,
                    imagePath: 'assets/images/tr.png',
                    label: "trucks".tr,
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageIconButton(BuildContext context,
      {required String imagePath, required String label}) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.teal,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (context) => buildOptionsSheet(context, label),
            );
          },
          child: CircleAvatar(
            radius: 70,
            backgroundColor: Colors.black,
            child: CircleAvatar(
              radius: 67,
              backgroundColor: Colors.white,
              child: Image.asset(
                imagePath,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
void _showAdDetails(BuildContext context, String imagePath, String description) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

}
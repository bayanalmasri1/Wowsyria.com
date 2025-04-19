import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wowsyria_com/model/superadshomeModel.dart';

Future<void> initializeCsrfToken() async {
  final response = await http.get(Uri.parse('https://www.wowsyria.com/login/'));
  final cookies = response.headers['set-cookie'];
  final csrfToken = RegExp('csrftoken=([^;]+)').firstMatch(cookies ?? '')?.group(1);

  if (csrfToken != null) {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('csrf_token', csrfToken);
  }
}

abstract class BaseAdsController<T> extends GetxController {
  var superAds = <T>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  Future<void> fetchData();
  Future<void> deleteItem(int id);

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null || token.isEmpty) {
      errorMessage.value = 'لم يتم العثور على رمز الدخول';
      throw Exception(errorMessage.value);
    }

    return {
      'Content-Type': 'application/json',
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> _handleAuthError() async {
    errorMessage.value = 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى';
    Get.snackbar('خطأ', errorMessage.value);
  }
}

class SuperAdsCarController extends BaseAdsController<SuperAdCarModel> {
  @override
  Future<void> fetchData() async => await fetchSuperCars();

  @override
  Future<void> deleteItem(int id) async => await deleteCar(id);

  Future<void> fetchSuperCars() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('https://www.wowsyria.com/car/cars/my-cars/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData.containsKey('results')) {
          superAds.value = (jsonData['results'] as List)
              .map((item) => SuperAdCarModel.fromJson(item))
              .toList();
        }
      } else if (response.statusCode == 401) {
        await _handleAuthError();
      } else {
        throw Exception('فشل في تحميل السيارات: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCar(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('https://www.wowsyria.com/car/cars/delete/$id/'),
        headers: headers,
      );

      if (response.statusCode == 204) {
        superAds.removeWhere((car) => car.id == id);
        Get.snackbar('نجاح', 'تم حذف إعلان السيارة بنجاح');
      } else if (response.statusCode == 401) {
        await _handleAuthError();
      } else {
        throw Exception('فشل في حذف السيارة: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}

class SuperAdsTruckController extends BaseAdsController<SuperAdsTruckModel> {
  @override
  Future<void> fetchData() async => await fetchSuperTruckAds();

  @override
  Future<void> deleteItem(int id) async => await deleteTruck(id);

  Future<void> fetchSuperTruckAds() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('https://www.wowsyria.com/truck/trucks/my-trucks/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData.containsKey('results')) {
          superAds.value = (jsonData['results'] as List)
              .map((item) => SuperAdsTruckModel.fromJson(item))
              .toList();
        }
      } else if (response.statusCode == 401) {
        await _handleAuthError();
      } else {
        throw Exception('فشل في تحميل الشاحنات: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTruck(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('https://www.wowsyria.com/truck/trucks/delete/$id/'),
        headers: headers,
      );

      if (response.statusCode == 204) {
        superAds.removeWhere((truck) => truck.id == id);
        Get.snackbar('نجاح', 'تم حذف إعلان الشاحنة بنجاح');
      } else if (response.statusCode == 401) {
        await _handleAuthError();
      } else {
        throw Exception('فشل في حذف الشاحنة: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}

class SuperAdsPropertyController extends BaseAdsController<SuperAdsPropertyModel> {
  @override
  Future<void> fetchData() async => await fetchSuperAdsProperty();

  @override
  Future<void> deleteItem(int id) async => await deleteProperty(id);

  Future<void> fetchSuperAdsProperty() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('https://www.wowsyria.com/property/properties/my-properties/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData.containsKey('results')) {
          superAds.value = (jsonData['results'] as List)
              .map((item) => SuperAdsPropertyModel.fromJson(item))
              .toList();
        }
      } else if (response.statusCode == 401) {
        await _handleAuthError();
      } else {
        throw Exception('فشل في تحميل العقارات: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProperty(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('https://www.wowsyria.com/property/properties/delete/$id/'),
        headers: headers,
      );

      if (response.statusCode == 204) {
        superAds.removeWhere((property) => property.id == id);
        Get.snackbar('نجاح', 'تم حذف إعلان العقار بنجاح');
      } else if (response.statusCode == 401) {
        await _handleAuthError();
      } else {
        throw Exception('فشل في حذف العقار: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}

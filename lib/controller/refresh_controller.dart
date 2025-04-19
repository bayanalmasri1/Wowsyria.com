import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiRefreshController extends GetxController {
  // المتغير الذي يتحكم في حالة التحميل
  var isLoading = false.obs;

  // الدالة التي تقوم بإجراء الـ API Call
  Future<void> refreshData() async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('https://www.wowsyria.com/account/refresh/'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-CSRFTOKEN': 'zgKIlIDvi0CBADbKbcwiNymq8wnNdp6vYomC9UWhEgH60rfx5hdIN4GWZhvUvrUN',
        },
        body: json.encode({'refresh': 'your_refresh_token_here'}),
      );

      if (response.statusCode == 200) {
        // إذا كانت الاستجابة صحيحة، معالجة البيانات هنا
        print("تم تحديث البيانات بنجاح");
      } else {
        print("حدث خطأ أثناء تحديث البيانات");
      }
    } catch (e) {
      print("حدث خطأ في الاتصال بالـ API: $e");
    }
    isLoading.value = false;
  }

  void refreshCompleted() {}
}

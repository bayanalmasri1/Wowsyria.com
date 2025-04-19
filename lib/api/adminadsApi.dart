import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';

// Model

class SuperAd {
  final int? id;
  final String description;
  final String imagePath;

  SuperAd({
    this.id,
    required this.description,
    required this.imagePath,
  });

  factory SuperAd.fromJson(Map<String, dynamic> json) {
    return SuperAd(
      id: json['id'],
      description: json['description'],
      imagePath: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      if (imagePath != null) 'image': imagePath,
    };
  }
}

// Services
class AuthService {
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<String?> getCsrfToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('csrf_token');
  }

  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getAccessToken();
    final csrfToken = await getCsrfToken();

    return {
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
      if (csrfToken != null) 'X-CSRFToken': csrfToken,
    };
  }
}

class SuperAdRepository {
  final String _baseUrl = 'https://www.wowsyria.com/super-ads/super-ads/';

  Future<List<SuperAd>> fetchSuperAds() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((ad) => SuperAd.fromJson(ad))
          .toList();
    }
    throw Exception('Failed to load ads');
  }

  Future<void> deleteAd(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl$id/delete/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete ad');
    }
  }

  Future<SuperAd> updateAd(int id, String description, File imageFile) async {
    try {
      final fullUrl = 'https://www.wowsyria.com/super-ads/super-ads/$id/edit/';
      print('🌀 Attempting UPDATE at: $fullUrl');
      print(
          '📦 Sending data: {"description": "$description", "image": "$imageFile"}');

      final response = await http
          .patch(
            Uri.parse(fullUrl),
            headers: {
              'Content-Type': 'application/json',
              // فعّل هذا فقط إذا API محمية
              // 'Authorization': 'Bearer YOUR_REAL_TOKEN_HERE',
            },
            body: json.encode({
              'description': description,
              'image': imageFile,
            }),
          )
          .timeout(const Duration(seconds: 10));

      print('🔵 Response Status: ${response.statusCode}');
      print('📨 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return SuperAd.fromJson(json.decode(response.body));
      } else {
        throw Exception('''
🚨 Update Failed!
Status: ${response.statusCode}
Body: ${response.body}
      ''');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<SuperAd> createSuperAd(SuperAd ad) async {
    try {
      final headers = await AuthService.getAuthHeaders();
      final request =
          http.MultipartRequest('POST', Uri.parse('${_baseUrl}create/'))
            ..headers.addAll(headers)
            ..fields['description'] = ad.description;

      if (ad.imagePath != null && !ad.imagePath!.startsWith('http')) {
        final file = File(ad.imagePath!);
        final fileExtension = extension(file.path).replaceFirst('.', '');

        request.files.add(await http.MultipartFile.fromPath(
          'image',
          file.path,
          contentType: MediaType('image', fileExtension),
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return SuperAd.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(
            error['image']?[0] ?? error['detail'] ?? 'Failed to create ad');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

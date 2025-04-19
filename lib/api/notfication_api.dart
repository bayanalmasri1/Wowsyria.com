import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationModel {
  final int id;
  final int user;
  final String notificationType;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.user,
    required this.notificationType,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      user: json['user'],
      notificationType: json['notification_type'],
      message: json['message'],
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

Future<String?> getAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token'); // استرجاع التوكن المخزن
}

Future<List<NotificationModel>> _loadNotificationsWithToken() async {
  String? token = await getAccessToken(); // الحصول على التوكن

  if (token == null) {
    throw Exception('Token not found. Please log in again.');
  }

  return await fetchNotifications(token); // تمرير التوكن إلى الدالة
}

Future<List<NotificationModel>> fetchNotifications(String token) async {
  final response = await http.get(
    Uri.parse('https://www.wowsyria.com/notifications/'),
    headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer $token', // استخدام التوكن هنا
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List notifications = data['results'];
    return notifications.map((e) => NotificationModel.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load notifications');
  }
}



Future<void> markAllNotificationsAsRead() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  if (token == null) {
    throw Exception('Token not found. Please log in again.');
  }

  final url = Uri.parse('https://www.wowsyria.com/notifications/read-all/');
  
  final response = await http.post(
    url,
    headers: {
      'Accept': '*/*',
    'Authorization': 'Bearer $token' 
    },
    body: {},
  );

  if (response.statusCode == 200) {
    print("All notifications marked as read");
  } else {
    throw Exception('Failed to mark all notifications as read');
  }
}

Future<void> markNotificationAsRead(String notificationId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  if (token == null) {
    throw Exception('Token not found. Please log in again.');
  }

  final url = Uri.parse('https://www.wowsyria.com/notifications/read/$notificationId/');

  final response = await http.post(
    url,
    headers: {
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    },
    body: {},
  );

  if (response.statusCode == 200) {
    print("Notification $notificationId marked as read");
  } else {
    throw Exception('Failed to mark notification as read');
  }
}

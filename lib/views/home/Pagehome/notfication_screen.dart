import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:wowsyria_com/api/notfication_api.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<NotificationModel>> _notificationsFuture;
  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _loadNotificationsWithToken();
  }

  Future<List<NotificationModel>> _loadNotificationsWithToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('Token not found. Please log in again.');
    }

    final notifications = await fetchNotifications(token);
    setState(() {
      _notifications = notifications;
    });
    return notifications;
  }

  Future<void> _refreshNotifications() async {
    setState(() {
      _notificationsFuture = _loadNotificationsWithToken();
    });
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
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
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // تحديث الحالة المحلية مباشرة دون انتظار إعادة التحميل
        setState(() {
          _notifications = _notifications.map((notif) {
            if (notif.id.toString() == notificationId) {
              return NotificationModel(
                id: notif.id,
                user: notif.user,
                notificationType: notif.notificationType,
                message: notif.message,
                isRead: true, // تحديث حالة القراءة هنا
                createdAt: notif.createdAt,
              );
            }
            return notif;
          }).toList();
        });

        // يمكنك أيضاً إعادة تحميل البيانات من الخادم للتأكد من المزامنة
        await _refreshNotifications();
      } else {
        throw Exception('Failed to mark notification as read');
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: _buildNotificationList(),
      ),
    );
  }

  Widget _buildNotificationList() {
    return FutureBuilder<List<NotificationModel>>(
      future: _notificationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && _notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final notifications = _notifications.isNotEmpty ? _notifications : snapshot.data ?? [];

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notif = notifications[index];
            final formattedDate = DateFormat.yMMMd().add_jm().format(notif.createdAt);

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: _getNotificationIcon(notif.notificationType),
                title: Text(
                  notif.message,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(formattedDate),
                trailing: notif.isRead
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.circle, color: Colors.red),
                onTap: () async {
                  if (!notif.isRead) {
                    await markNotificationAsRead(notif.id.toString());
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  Icon _getNotificationIcon(String type) {
    switch (type) {
      case "new_car":
        return Icon(Icons.directions_car, color: Colors.deepPurple, size: 32);
      case "new_property":
        return Icon(Icons.home, color: Colors.deepPurple, size: 32);
      default:
        return Icon(Icons.local_shipping, color: Colors.deepPurple, size: 32);
    }
  }
}
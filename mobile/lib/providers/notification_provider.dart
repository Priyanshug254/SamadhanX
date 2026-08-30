import 'package:flutter/foundation.dart';
import '../core/network/api_client.dart';
import '../data/models/api_response.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String notificationType;
  final String? referenceId;
  final String? referenceType;
  bool isRead;
  final DateTime? createdAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.notificationType,
    this.referenceId,
    this.referenceType,
    required this.isRead,
    this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Civic Alert',
      body: json['body']?.toString() ?? '',
      notificationType: json['notificationType']?.toString() ?? 'GENERAL',
      referenceId: json['referenceId']?.toString(),
      referenceType: json['referenceType']?.toString(),
      isRead: json['isRead'] ?? json['read'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}

class NotificationProvider extends ChangeNotifier {
  final ApiClient _apiClient;

  List<NotificationItem> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _errorMessage;

  NotificationProvider(this._apiClient);

  List<NotificationItem> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchNotifications({bool refresh = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiClient.get(
        '/api/v1/notifications',
        queryParameters: {'page': 0, 'size': 30},
      );

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => PageData<NotificationItem>.fromJson(
          json as Map<String, dynamic>,
          (item) => NotificationItem.fromJson(item),
        ),
      );

      if (apiResponse.data != null) {
        _notifications = apiResponse.data!.content;
        _unreadCount = _notifications.where((n) => !n.isRead).length;
      }
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }

    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    try {
      final notif = _notifications.firstWhere((n) => n.id == id);
      if (!notif.isRead) {
        notif.isRead = true;
        if (_unreadCount > 0) _unreadCount--;
        notifyListeners();

        await _apiClient.patch('/api/v1/notifications/$id/read');
      }
    } catch (e) {
      debugPrint('Failed to mark notification read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      for (var n in _notifications) {
        n.isRead = true;
      }
      _unreadCount = 0;
      notifyListeners();

      await _apiClient.patch('/api/v1/notifications/read-all');
    } catch (e) {
      debugPrint('Failed to mark all notifications read: $e');
    }
  }
}

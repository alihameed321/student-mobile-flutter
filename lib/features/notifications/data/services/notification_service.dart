import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/notification_model.dart';

class NotificationService {
  final DioClient _dioClient;
  static const String _baseUrl = '/api/notifications';

  NotificationService(this._dioClient);

  /// Get paginated list of notifications
  Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    int pageSize = 20,
    bool? isRead,
    String? notificationType,
    String? priority,
    String? dateFrom,
    String? dateTo,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'page_size': pageSize,
      };

      if (isRead != null) queryParams['is_read'] = isRead;
      if (notificationType != null) queryParams['notification_type'] = notificationType;
      if (priority != null) queryParams['priority'] = priority;
      if (dateFrom != null) queryParams['date_from'] = dateFrom;
      if (dateTo != null) queryParams['date_to'] = dateTo;
      if (search != null) queryParams['search'] = search;

      final response = await _dioClient.get(
        _baseUrl,
        queryParameters: queryParams,
      );

      return {
        'notifications': (response.data['results'] as List)
            .map((json) => NotificationModel.fromJson(json))
            .toList(),
        'count': response.data['count'],
        'next': response.data['next'],
        'previous': response.data['previous'],
        'unread_count': response.data['unread_count'] ?? 0,
      };
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  /// Get notification statistics
  Future<NotificationStatsModel> getNotificationStats() async {
    try {
      final response = await _dioClient.get('$_baseUrl/stats/');
      
      if (response.data['success'] == true) {
        return NotificationStatsModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to get stats');
      }
    } catch (e) {
      throw Exception('Failed to fetch notification statistics: $e');
    }
  }

  /// Mark a specific notification as read
  Future<bool> markNotificationAsRead(int notificationId) async {
    try {
      final response = await _dioClient.post(
        '$_baseUrl/$notificationId/read/',
      );
      
      return response.data['success'] == true;
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  /// Mark a specific notification as unread
  Future<bool> markNotificationAsUnread(int notificationId) async {
    try {
      final response = await _dioClient.post(
        '$_baseUrl/$notificationId/unread/',
      );
      
      return response.data['success'] == true;
    } catch (e) {
      throw Exception('Failed to mark notification as unread: $e');
    }
  }

  /// Mark all notifications as read
  Future<int> markAllNotificationsAsRead({
    String? notificationType,
    String? priority,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (notificationType != null) data['notification_type'] = notificationType;
      if (priority != null) data['priority'] = priority;

      final response = await _dioClient.post(
        '$_baseUrl/mark-all-read/',
        data: data,
      );
      
      if (response.data['success'] == true) {
        return response.data['data']['updated_count'] ?? 0;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to mark all as read');
      }
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  /// Delete a specific notification
  Future<bool> deleteNotification(int notificationId) async {
    try {
      final response = await _dioClient.delete(
        '$_baseUrl/$notificationId/delete/',
      );
      
      return response.data['success'] == true;
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  /// Get notification preferences
  Future<NotificationPreferencesModel> getNotificationPreferences() async {
    try {
      final response = await _dioClient.get('$_baseUrl/preferences/');
      return NotificationPreferencesModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch notification preferences: $e');
    }
  }

  /// Update notification preferences
  Future<bool> updateNotificationPreferences(
    NotificationPreferencesModel preferences,
  ) async {
    try {
      final response = await _dioClient.put(
        '$_baseUrl/preferences/',
        data: preferences.toJson(),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to update notification preferences: $e');
    }
  }

  /// Get a specific notification detail
  Future<NotificationModel> getNotificationDetail(int notificationId) async {
    try {
      final response = await _dioClient.get('$_baseUrl/$notificationId/');
      return NotificationModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch notification detail: $e');
    }
  }

  /// Get announcements
  Future<List<NotificationModel>> getAnnouncements() async {
    try {
      final response = await _dioClient.get('$_baseUrl/announcements/');
      
      return (response.data['results'] as List)
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch announcements: $e');
    }
  }
}
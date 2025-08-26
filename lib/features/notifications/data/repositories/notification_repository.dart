import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationRepository {
  final NotificationService _notificationService;

  NotificationRepository(this._notificationService);

  /// Get paginated notifications with caching support
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
      return await _notificationService.getNotifications(
        page: page,
        pageSize: pageSize,
        isRead: isRead,
        notificationType: notificationType,
        priority: priority,
        dateFrom: dateFrom,
        dateTo: dateTo,
        search: search,
      );
    } catch (e) {
      throw Exception('Repository: Failed to get notifications - $e');
    }
  }

  /// Get notification statistics
  Future<NotificationStatsModel> getNotificationStats() async {
    try {
      return await _notificationService.getNotificationStats();
    } catch (e) {
      throw Exception('Repository: Failed to get notification stats - $e');
    }
  }

  /// Mark notification as read
  Future<bool> markAsRead(int notificationId) async {
    try {
      return await _notificationService.markNotificationAsRead(notificationId);
    } catch (e) {
      throw Exception('Repository: Failed to mark notification as read - $e');
    }
  }

  /// Mark notification as unread
  Future<bool> markAsUnread(int notificationId) async {
    try {
      return await _notificationService.markNotificationAsUnread(notificationId);
    } catch (e) {
      throw Exception('Repository: Failed to mark notification as unread - $e');
    }
  }

  /// Mark all notifications as read
  Future<int> markAllAsRead({
    String? notificationType,
    String? priority,
  }) async {
    try {
      return await _notificationService.markAllNotificationsAsRead(
        notificationType: notificationType,
        priority: priority,
      );
    } catch (e) {
      throw Exception('Repository: Failed to mark all notifications as read - $e');
    }
  }

  /// Delete notification
  Future<bool> deleteNotification(int notificationId) async {
    try {
      return await _notificationService.deleteNotification(notificationId);
    } catch (e) {
      throw Exception('Repository: Failed to delete notification - $e');
    }
  }

  /// Get notification preferences
  Future<NotificationPreferencesModel> getPreferences() async {
    try {
      return await _notificationService.getNotificationPreferences();
    } catch (e) {
      throw Exception('Repository: Failed to get notification preferences - $e');
    }
  }

  /// Update notification preferences
  Future<bool> updatePreferences(NotificationPreferencesModel preferences) async {
    try {
      return await _notificationService.updateNotificationPreferences(preferences);
    } catch (e) {
      throw Exception('Repository: Failed to update notification preferences - $e');
    }
  }

  /// Get notification detail
  Future<NotificationModel> getNotificationDetail(int notificationId) async {
    try {
      return await _notificationService.getNotificationDetail(notificationId);
    } catch (e) {
      throw Exception('Repository: Failed to get notification detail - $e');
    }
  }

  /// Get announcements
  Future<List<NotificationModel>> getAnnouncements() async {
    try {
      return await _notificationService.getAnnouncements();
    } catch (e) {
      throw Exception('Repository: Failed to get announcements - $e');
    }
  }
}
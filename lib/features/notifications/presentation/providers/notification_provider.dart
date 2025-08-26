import 'package:flutter/foundation.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _repository;

  NotificationProvider(this._repository);

  // State variables
  List<NotificationModel> _notifications = [];
  NotificationStatsModel? _stats;
  NotificationPreferencesModel? _preferences;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;
  int _unreadCount = 0;

  // Filters
  bool? _filterIsRead;
  String? _filterType;
  String? _filterPriority;
  String? _searchQuery;

  // Getters
  List<NotificationModel> get notifications => _notifications;
  NotificationStatsModel? get stats => _stats;
  NotificationPreferencesModel? get preferences => _preferences;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  int get unreadCount => _unreadCount;
  bool get hasMore => _hasMore;
  bool? get filterIsRead => _filterIsRead;
  String? get filterType => _filterType;
  String? get filterPriority => _filterPriority;
  String? get searchQuery => _searchQuery;

  /// Load notifications (first page)
  Future<void> loadNotifications({bool refresh = false}) async {
    if (_isLoading && !refresh) return;

    _isLoading = true;
    _error = null;
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
    }
    notifyListeners();

    try {
      final result = await _repository.getNotifications(
        page: _currentPage,
        isRead: _filterIsRead,
        notificationType: _filterType,
        priority: _filterPriority,
        search: _searchQuery,
      );

      if (refresh || _currentPage == 1) {
        _notifications = result['notifications'];
      } else {
        _notifications.addAll(result['notifications']);
      }

      _unreadCount = result['unread_count'] ?? 0;
      _hasMore = result['next'] != null;
      _currentPage++;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load more notifications (pagination)
  Future<void> loadMoreNotifications() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final result = await _repository.getNotifications(
        page: _currentPage,
        isRead: _filterIsRead,
        notificationType: _filterType,
        priority: _filterPriority,
        search: _searchQuery,
      );

      _notifications.addAll(result['notifications']);
      _unreadCount = result['unread_count'] ?? 0;
      _hasMore = result['next'] != null;
      _currentPage++;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Load notification statistics
  Future<void> loadStats() async {
    try {
      _stats = await _repository.getNotificationStats();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Mark notification as read
  Future<bool> markAsRead(int notificationId) async {
    try {
      final success = await _repository.markAsRead(notificationId);
      if (success) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(
            isRead: true,
            readAt: DateTime.now(),
          );
          _unreadCount = (_unreadCount - 1).clamp(0, double.infinity).toInt();
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Mark notification as unread
  Future<bool> markAsUnread(int notificationId) async {
    try {
      final success = await _repository.markAsUnread(notificationId);
      if (success) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(
            isRead: false,
            readAt: null,
          );
          _unreadCount++;
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Mark all notifications as read
  Future<bool> markAllAsRead() async {
    try {
      final updatedCount = await _repository.markAllAsRead(
        notificationType: _filterType,
        priority: _filterPriority,
      );
      
      if (updatedCount > 0) {
        // Update local notifications
        for (int i = 0; i < _notifications.length; i++) {
          if (!_notifications[i].isRead) {
            _notifications[i] = _notifications[i].copyWith(
              isRead: true,
              readAt: DateTime.now(),
            );
          }
        }
        _unreadCount = 0;
        notifyListeners();
      }
      return updatedCount > 0;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Delete notification
  Future<bool> deleteNotification(int notificationId) async {
    try {
      final success = await _repository.deleteNotification(notificationId);
      if (success) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          final wasUnread = !_notifications[index].isRead;
          _notifications.removeAt(index);
          if (wasUnread) {
            _unreadCount = (_unreadCount - 1).clamp(0, double.infinity).toInt();
          }
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Load notification preferences
  Future<void> loadPreferences() async {
    try {
      _preferences = await _repository.getPreferences();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Update notification preferences
  Future<bool> updatePreferences(NotificationPreferencesModel preferences) async {
    try {
      final success = await _repository.updatePreferences(preferences);
      if (success) {
        _preferences = preferences;
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Set filters and reload notifications
  void setFilters({
    bool? isRead,
    String? type,
    String? priority,
    String? search,
  }) {
    _filterIsRead = isRead;
    _filterType = type;
    _filterPriority = priority;
    _searchQuery = search;
    loadNotifications(refresh: true);
  }

  /// Clear all filters
  void clearFilters() {
    _filterIsRead = null;
    _filterType = null;
    _filterPriority = null;
    _searchQuery = null;
    loadNotifications(refresh: true);
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refresh all data
  Future<void> refresh() async {
    await Future.wait([
      loadNotifications(refresh: true),
      loadStats(),
    ]);
  }
}
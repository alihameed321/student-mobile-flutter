class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String notificationType;
  final String priority;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;
  final DateTime? expiresAt;
  final String? actionUrl;
  final String? actionText;
  final String timeSinceCreated;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.notificationType,
    required this.priority,
    required this.isRead,
    required this.createdAt,
    this.readAt,
    this.expiresAt,
    this.actionUrl,
    this.actionText,
    required this.timeSinceCreated,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      notificationType: json['notification_type'],
      priority: json['priority'],
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['created_at']),
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
      actionUrl: json['action_url'],
      actionText: json['action_text'],
      timeSinceCreated: json['time_since_created'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'notification_type': notificationType,
      'priority': priority,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'action_url': actionUrl,
      'action_text': actionText,
      'time_since_created': timeSinceCreated,
    };
  }

  NotificationModel copyWith({
    int? id,
    String? title,
    String? message,
    String? notificationType,
    String? priority,
    bool? isRead,
    DateTime? createdAt,
    DateTime? readAt,
    DateTime? expiresAt,
    String? actionUrl,
    String? actionText,
    String? timeSinceCreated,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      notificationType: notificationType ?? this.notificationType,
      priority: priority ?? this.priority,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      expiresAt: expiresAt ?? this.expiresAt,
      actionUrl: actionUrl ?? this.actionUrl,
      actionText: actionText ?? this.actionText,
      timeSinceCreated: timeSinceCreated ?? this.timeSinceCreated,
    );
  }
}

class NotificationStatsModel {
  final int totalNotifications;
  final int unreadNotifications;
  final int highPriorityUnread;
  final int urgentPriorityUnread;
  final int notificationsToday;
  final int infoCount;
  final int warningCount;
  final int successCount;
  final int errorCount;
  final int announcementCount;

  NotificationStatsModel({
    required this.totalNotifications,
    required this.unreadNotifications,
    required this.highPriorityUnread,
    required this.urgentPriorityUnread,
    required this.notificationsToday,
    required this.infoCount,
    required this.warningCount,
    required this.successCount,
    required this.errorCount,
    required this.announcementCount,
  });

  factory NotificationStatsModel.fromJson(Map<String, dynamic> json) {
    return NotificationStatsModel(
      totalNotifications: json['total_notifications'] ?? 0,
      unreadNotifications: json['unread_notifications'] ?? 0,
      highPriorityUnread: json['high_priority_unread'] ?? 0,
      urgentPriorityUnread: json['urgent_priority_unread'] ?? 0,
      notificationsToday: json['notifications_today'] ?? 0,
      infoCount: json['info_count'] ?? 0,
      warningCount: json['warning_count'] ?? 0,
      successCount: json['success_count'] ?? 0,
      errorCount: json['error_count'] ?? 0,
      announcementCount: json['announcement_count'] ?? 0,
    );
  }
}

class NotificationPreferencesModel {
  final bool emailNotifications;
  final bool inAppNotifications;
  final String digestFrequency;
  final bool academicNotifications;
  final bool financialNotifications;
  final bool systemNotifications;
  final bool announcementNotifications;

  NotificationPreferencesModel({
    required this.emailNotifications,
    required this.inAppNotifications,
    required this.digestFrequency,
    required this.academicNotifications,
    required this.financialNotifications,
    required this.systemNotifications,
    required this.announcementNotifications,
  });

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferencesModel(
      emailNotifications: json['email_notifications'] ?? true,
      inAppNotifications: json['in_app_notifications'] ?? true,
      digestFrequency: json['digest_frequency'] ?? 'daily',
      academicNotifications: json['academic_notifications'] ?? true,
      financialNotifications: json['financial_notifications'] ?? true,
      systemNotifications: json['system_notifications'] ?? true,
      announcementNotifications: json['announcement_notifications'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email_notifications': emailNotifications,
      'in_app_notifications': inAppNotifications,
      'digest_frequency': digestFrequency,
      'academic_notifications': academicNotifications,
      'financial_notifications': financialNotifications,
      'system_notifications': systemNotifications,
      'announcement_notifications': announcementNotifications,
    };
  }
}
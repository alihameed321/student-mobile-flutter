import '../../domain/entities/dashboard_stats.dart';
import 'service_request_model.dart';
import 'support_ticket_model.dart';

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.totalServiceRequests,
    required super.pendingServiceRequests,
    required super.completedServiceRequests,
    required super.totalDocuments,
    required super.verifiedDocuments,
    required super.totalSupportTickets,
    required super.openSupportTickets,
    required super.recentServiceRequests,
    required super.recentDocuments,
    required super.recentSupportTickets,
    super.userInfo,
    super.quickActions,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    final stats = json['statistics'] as Map<String, dynamic>? ?? {};
    final recentActivities =
        json['recent_activities'] as Map<String, dynamic>? ?? {};

    return DashboardStatsModel(
      totalServiceRequests: stats['total_requests'] as int? ?? 0,
      pendingServiceRequests: stats['pending_requests'] as int? ?? 0,
      completedServiceRequests: (stats['total_requests'] as int? ?? 0) -
          (stats['pending_requests'] as int? ?? 0),
      totalDocuments: stats['new_documents'] as int? ?? 0,
      verifiedDocuments: stats['new_documents'] as int? ?? 0,
      totalSupportTickets: stats['open_tickets'] as int? ?? 0,
      openSupportTickets: stats['open_tickets'] as int? ?? 0,
      recentServiceRequests: recentActivities['service_requests'] != null
          ? (recentActivities['service_requests'] as List)
              .map((item) => ServiceRequestModel.fromJson(item))
              .toList()
          : [],
      recentSupportTickets: recentActivities['support_tickets'] != null
          ? (recentActivities['support_tickets'] as List)
              .map((item) => SupportTicketModel.fromJson(item))
              .toList()
          : [],
      // TODO: Implement documents later
      recentDocuments: const [],
      userInfo: json['user_info'] != null
          ? UserInfoModel.fromJson(json['user_info'])
          : null,
      quickActions: json['quick_actions'] != null
          ? (json['quick_actions'] as List)
              .map((item) => QuickActionModel.fromBackendJson(item))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statistics': {
        'total_service_requests': totalServiceRequests,
        'pending_service_requests': pendingServiceRequests,
        'completed_service_requests': completedServiceRequests,
        'total_documents': totalDocuments,
        'verified_documents': verifiedDocuments,
        'total_support_tickets': totalSupportTickets,
        'open_support_tickets': openSupportTickets,
      },
      'recent_activities': {
        'service_requests': recentServiceRequests
            .map((item) => (item as ServiceRequestModel).toJson())
            .toList(),
        // TODO: Implement documents later
        'documents': const [],
        'support_tickets': recentSupportTickets
            .map((item) => (item as SupportTicketModel).toJson())
            .toList(),
      },
      'user_info':
          userInfo != null ? (userInfo as UserInfoModel).toJson() : null,
      'quick_actions': quickActions
          ?.map((item) => (item as QuickActionModel).toJson())
          .toList(),
    };
  }
}

class UserInfoModel extends UserInfo {
  const UserInfoModel({
    required super.studentId,
    required super.fullName,
    required super.email,
    super.program,
    super.year,
    super.gpa,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      studentId: json['student_id'] as String? ?? 'Unknown',
      fullName: json['full_name'] as String? ?? 'Unknown Student',
      email: json['email'] as String? ?? 'unknown@email.com',
      program: json['program'] as String?,
      year: json['year'] as String?,
      gpa: json['gpa'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'full_name': fullName,
      'email': email,
      'program': program,
      'year': year,
      'gpa': gpa,
    };
  }
}

class QuickActionModel extends QuickAction {
  const QuickActionModel({
    required super.title,
    required super.description,
    required super.endpoint,
    required super.icon,
    super.color,
  });

  factory QuickActionModel.fromJson(Map<String, dynamic> json) {
    return QuickActionModel(
      title: json['title'] as String,
      description: json['description'] as String,
      endpoint: json['endpoint'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String?,
    );
  }

  factory QuickActionModel.fromBackendJson(Map<String, dynamic> json) {
    return QuickActionModel(
      title: json['title'] as String? ?? 'Quick Action',
      description: json['description'] as String? ??
          json['action'] as String? ??
          'No description',
      endpoint: json['endpoint'] as String? ?? '',
      icon: json['icon'] as String? ?? 'default',
      color: json['color'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'endpoint': endpoint,
      'icon': icon,
      'color': color,
    };
  }
}

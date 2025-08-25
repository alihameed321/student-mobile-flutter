import 'package:equatable/equatable.dart';
import 'service_request.dart';
import 'student_document.dart';
import 'support_ticket.dart';

class DashboardStats extends Equatable {
  final int totalServiceRequests;
  final int pendingServiceRequests;
  final int completedServiceRequests;
  final int totalDocuments;
  final int verifiedDocuments;
  final int totalSupportTickets;
  final int openSupportTickets;
  final List<ServiceRequest> recentServiceRequests;
  final List<StudentDocument> recentDocuments;
  final List<SupportTicket> recentSupportTickets;
  final UserInfo? userInfo;
  final List<QuickAction>? quickActions;

  const DashboardStats({
    required this.totalServiceRequests,
    required this.pendingServiceRequests,
    required this.completedServiceRequests,
    required this.totalDocuments,
    required this.verifiedDocuments,
    required this.totalSupportTickets,
    required this.openSupportTickets,
    required this.recentServiceRequests,
    required this.recentDocuments,
    required this.recentSupportTickets,
    this.userInfo,
    this.quickActions,
  });

  @override
  List<Object?> get props => [
        totalServiceRequests,
        pendingServiceRequests,
        completedServiceRequests,
        totalDocuments,
        verifiedDocuments,
        totalSupportTickets,
        openSupportTickets,
        recentServiceRequests,
        recentDocuments,
        recentSupportTickets,
        userInfo,
        quickActions,
      ];

  // Helper methods
  double get serviceRequestCompletionRate {
    if (totalServiceRequests == 0) return 0.0;
    return completedServiceRequests / totalServiceRequests;
  }

  double get documentVerificationRate {
    if (totalDocuments == 0) return 0.0;
    return verifiedDocuments / totalDocuments;
  }

  int get inProgressServiceRequests {
    return totalServiceRequests - pendingServiceRequests - completedServiceRequests;
  }

  int get closedSupportTickets {
    return totalSupportTickets - openSupportTickets;
  }

  bool get hasRecentActivity {
    return recentServiceRequests.isNotEmpty ||
           recentDocuments.isNotEmpty ||
           recentSupportTickets.isNotEmpty;
  }

  int get totalRecentActivities {
    return recentServiceRequests.length +
           recentDocuments.length +
           recentSupportTickets.length;
  }
}

class UserInfo extends Equatable {
  final String studentId;
  final String fullName;
  final String email;
  final String? program;
  final String? year;
  final double? gpa;

  const UserInfo({
    required this.studentId,
    required this.fullName,
    required this.email,
    this.program,
    this.year,
    this.gpa,
  });

  @override
  List<Object?> get props => [
        studentId,
        fullName,
        email,
        program,
        year,
        gpa,
      ];

  String get firstName {
    return fullName.split(' ').first;
  }

  String get initials {
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names.first[0]}${names.last[0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names.first[0].toUpperCase();
    }
    return 'U';
  }

  String get formattedGpa {
    if (gpa == null) return 'N/A';
    return gpa!.toStringAsFixed(2);
  }
}

class QuickAction extends Equatable {
  final String title;
  final String description;
  final String endpoint;
  final String icon;
  final String? color;

  const QuickAction({
    required this.title,
    required this.description,
    required this.endpoint,
    required this.icon,
    this.color,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        endpoint,
        icon,
        color,
      ];
}
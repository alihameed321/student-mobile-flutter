import 'package:equatable/equatable.dart';

class SupportTicket extends Equatable {
  final int id;
  final String subject;
  final String description;
  final String category;
  final String priority;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? resolvedAt;
  final List<TicketResponse>? responses;

  const SupportTicket({
    required this.id,
    required this.subject,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.resolvedAt,
    this.responses,
  });

  @override
  List<Object?> get props => [
        id,
        subject,
        description,
        category,
        priority,
        status,
        createdAt,
        updatedAt,
        resolvedAt,
        responses,
      ];

  // Helper methods for status checking
  bool get isOpen => status.toLowerCase() == 'open';
  bool get isInProgress => status.toLowerCase() == 'in_progress';
  bool get isResolved => status.toLowerCase() == 'resolved';
  bool get isClosed => status.toLowerCase() == 'closed';
  bool get canAddResponse => isOpen || isInProgress;

  // Helper methods for priority
  bool get isHighPriority => priority.toLowerCase() == 'high';
  bool get isMediumPriority => priority.toLowerCase() == 'medium';
  bool get isLowPriority => priority.toLowerCase() == 'low';

  // Get status color
  String get statusColor {
    switch (status.toLowerCase()) {
      case 'open':
        return 'blue';
      case 'in_progress':
        return 'orange';
      case 'resolved':
        return 'green';
      case 'closed':
        return 'grey';
      default:
        return 'grey';
    }
  }

  // Get priority color
  String get priorityColor {
    switch (priority.toLowerCase()) {
      case 'high':
        return 'red';
      case 'medium':
        return 'orange';
      case 'low':
        return 'green';
      default:
        return 'grey';
    }
  }

  // Get category display name
  String get categoryDisplayName {
    switch (category.toLowerCase()) {
      case 'technical':
        return 'Technical Support';
      case 'academic':
        return 'Academic Support';
      case 'financial':
        return 'Financial Support';
      case 'general':
        return 'General Inquiry';
      case 'complaint':
        return 'Complaint';
      default:
        return category.replaceAll('_', ' ').split(' ').map((word) => 
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : ''
        ).join(' ');
    }
  }

  // Get response count
  int get responseCount => responses?.length ?? 0;

  // Get last response date
  DateTime? get lastResponseDate {
    if (responses == null || responses!.isEmpty) return null;
    return responses!.map((r) => r.createdAt).reduce((a, b) => a.isAfter(b) ? a : b);
  }

  // Check if there are unread staff responses
  bool get hasUnreadStaffResponses {
    if (responses == null || responses!.isEmpty) return false;
    return responses!.any((response) => response.isFromStaff);
  }
}

class TicketResponse extends Equatable {
  final int id;
  final String message;
  final DateTime createdAt;
  final bool isFromStaff;
  final String? staffName;

  const TicketResponse({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.isFromStaff,
    this.staffName,
  });

  @override
  List<Object?> get props => [
        id,
        message,
        createdAt,
        isFromStaff,
        staffName,
      ];

  String get senderName {
    if (isFromStaff) {
      return staffName ?? 'Support Staff';
    } else {
      return 'You';
    }
  }

  String get senderType {
    return isFromStaff ? 'staff' : 'student';
  }
}
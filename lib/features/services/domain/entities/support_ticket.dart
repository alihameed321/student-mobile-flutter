import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SupportTicket extends Equatable {
  final int id;
  final String student;
  final String subject;
  final String description;
  final String category;
  final String priority;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? assignedTo;
  final String? ticketNumber;
  final List<TicketResponse>? responses;

  const SupportTicket({
    required this.id,
    required this.student,
    required this.subject,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.assignedTo,
    this.ticketNumber,
    this.responses,
  });

  @override
  List<Object?> get props => [
        id,
        student,
        subject,
        description,
        category,
        priority,
        status,
        createdAt,
        updatedAt,
        assignedTo,
        ticketNumber,
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
  bool get isUrgentPriority => priority.toLowerCase() == 'urgent';

  // Get status color
  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.blue;
      case 'in_progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  // Get priority color
  Color get priorityColor {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return Colors.deepPurple;
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Get status display text
  String get statusDisplayText {
    switch (status.toLowerCase()) {
      case 'open':
        return 'Open';
      case 'in_progress':
        return 'In Progress';
      case 'resolved':
        return 'Resolved';
      case 'closed':
        return 'Closed';
      default:
        return status.replaceAll('_', ' ').split(' ').map((word) => 
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : ''
        ).join(' ');
    }
  }

  // Get priority display text
  String get priorityDisplayText {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return 'Urgent';
      case 'high':
        return 'High';
      case 'medium':
        return 'Medium';
      case 'low':
        return 'Low';
      default:
        return priority.replaceAll('_', ' ').split(' ').map((word) => 
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : ''
        ).join(' ');
    }
  }

  // Get category display name
  String get categoryDisplayName {
    switch (category.toLowerCase()) {
      case 'technical':
        return 'Technical Support';
      case 'academic':
        return 'Academic Services';
      case 'financial':
        return 'Financial Services';
      case 'general':
        return 'General Inquiry';
      default:
        return category.replaceAll('_', ' ').split(' ').map((word) => 
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : ''
        ).join(' ');
    }
  }

  // Get category icon
  IconData get categoryIcon {
    switch (category.toLowerCase()) {
      case 'technical':
        return Icons.computer;
      case 'academic':
        return Icons.school;
      case 'financial':
        return Icons.account_balance;
      case 'general':
        return Icons.help;
      default:
        return Icons.support;
    }
  }

  // Get priority icon
  IconData get priorityIcon {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return Icons.priority_high;
      case 'high':
        return Icons.keyboard_arrow_up;
      case 'medium':
        return Icons.remove;
      case 'low':
        return Icons.keyboard_arrow_down;
      default:
        return Icons.remove;
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

  // Check if ticket is assigned
  bool get isAssigned => assignedTo != null && assignedTo!.isNotEmpty;
}

class TicketResponse extends Equatable {
  final int id;
  final int ticketId;
  final String message;
  final DateTime createdAt;
  final bool isFromStaff;
  final String authorName;
  final String? authorPosition;
  final bool isInternal;

  const TicketResponse({
    required this.id,
    required this.ticketId,
    required this.message,
    required this.createdAt,
    required this.isFromStaff,
    required this.authorName,
    this.authorPosition,
    this.isInternal = false,
  });

  @override
  List<Object?> get props => [
        id,
        ticketId,
        message,
        createdAt,
        isFromStaff,
        authorName,
        authorPosition,
        isInternal,
      ];

  String get senderName {
    if (isFromStaff) {
      return authorName;
    } else {
      return 'You';
    }
  }

  String get senderType {
    return isFromStaff ? 'staff' : 'student';
  }

  String get displayName {
    if (isFromStaff && authorPosition != null) {
      return '$authorName ($authorPosition)';
    }
    return authorName;
  }
}
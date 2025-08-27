import 'package:equatable/equatable.dart';

class ServiceRequest extends Equatable {
  final int id;
  final String student; // Student username or ID
  final String requestType;
  final String title;
  final String description;
  final String status;
  final String priority;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? processedBy; // Staff member who processed the request
  final String? processingNotes;
  final DateTime? dueDate;
  final List<String> attachments;

  const ServiceRequest({
    required this.id,
    required this.student,
    required this.requestType,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.updatedAt,
    this.processedBy,
    this.processingNotes,
    this.dueDate,
    this.attachments = const [],
  });

  @override
  List<Object?> get props => [
        id,
        student,
        requestType,
        title,
        description,
        status,
        priority,
        createdAt,
        updatedAt,
        processedBy,
        processingNotes,
        dueDate,
        attachments,
      ];

  // Helper methods for status checking
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isInReview => status.toLowerCase() == 'in_review';
  bool get isApproved => status.toLowerCase() == 'approved';
  bool get isRejected => status.toLowerCase() == 'rejected';
  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get needsMoreInfo => status.toLowerCase() == 'more_info_needed';
  bool get canBeCancelled => isPending || isInReview || needsMoreInfo;

  // Helper methods for priority
  bool get isHighPriority => priority?.toLowerCase() == 'high';
  bool get isMediumPriority => priority?.toLowerCase() == 'medium';
  bool get isLowPriority => priority?.toLowerCase() == 'low';

  // Get status color
  String get statusColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'orange';
      case 'in_review':
        return 'blue';
      case 'approved':
        return 'green';
      case 'rejected':
        return 'red';
      case 'completed':
        return 'green';
      case 'more_info_needed':
        return 'amber';
      default:
        return 'grey';
    }
  }

  // Get status display text
  String get statusDisplayText {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'معلق';
      case 'in_review':
        return 'قيد المراجعة';
      case 'approved':
        return 'موافق عليه';
      case 'rejected':
        return 'مرفوض';
      case 'completed':
        return 'مكتمل';
      case 'more_info_needed':
        return 'مطلوب معلومات إضافية';
      default:
        return status;
    }
  }

  // Get request type display text
  String get requestTypeDisplayText {
    switch (requestType.toLowerCase()) {
      case 'enrollment_certificate':
        return 'شهادة قيد';
      case 'schedule_modification':
        return 'تعديل الجدول';
      case 'semester_postponement':
        return 'تأجيل الفصل الدراسي';
      case 'transcript':
        return 'كشف درجات رسمي';
      case 'graduation_certificate':
        return 'شهادة تخرج';
      case 'other':
        return 'أخرى';
      default:
        return requestType;
    }
  }

  // Get priority color
  String get priorityColor {
    switch (priority?.toLowerCase()) {
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
}
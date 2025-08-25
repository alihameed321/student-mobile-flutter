import 'package:equatable/equatable.dart';

class ServiceRequest extends Equatable {
  final int id;
  final String requestType;
  final String status;
  final String description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;
  final String? staffNotes;
  final String? priority;
  final DateTime? estimatedCompletionDate;

  const ServiceRequest({
    required this.id,
    required this.requestType,
    required this.status,
    required this.description,
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
    this.staffNotes,
    this.priority,
    this.estimatedCompletionDate,
  });

  @override
  List<Object?> get props => [
        id,
        requestType,
        status,
        description,
        createdAt,
        updatedAt,
        completedAt,
        staffNotes,
        priority,
        estimatedCompletionDate,
      ];

  // Helper methods for status checking
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isInProgress => status.toLowerCase() == 'in_progress';
  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isCancelled => status.toLowerCase() == 'cancelled';
  bool get canBeCancelled => isPending || isInProgress;

  // Helper methods for priority
  bool get isHighPriority => priority?.toLowerCase() == 'high';
  bool get isMediumPriority => priority?.toLowerCase() == 'medium';
  bool get isLowPriority => priority?.toLowerCase() == 'low';

  // Get status color
  String get statusColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'orange';
      case 'in_progress':
        return 'blue';
      case 'completed':
        return 'green';
      case 'cancelled':
        return 'red';
      default:
        return 'grey';
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
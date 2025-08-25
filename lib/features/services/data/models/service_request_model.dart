import '../../domain/entities/service_request.dart';

class ServiceRequestModel extends ServiceRequest {
  const ServiceRequestModel({
    required super.id,
    required super.requestType,
    required super.status,
    required super.description,
    required super.createdAt,
    super.updatedAt,
    super.completedAt,
    super.staffNotes,
    super.priority,
    super.estimatedCompletionDate,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestModel(
      id: json['id'] as int,
      requestType: json['request_type'] as String,
      status: json['status'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at'] as String) 
          : null,
      staffNotes: json['staff_notes'] as String?,
      priority: json['priority'] as String?,
      estimatedCompletionDate: json['estimated_completion_date'] != null 
          ? DateTime.parse(json['estimated_completion_date'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_type': requestType,
      'status': status,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'staff_notes': staffNotes,
      'priority': priority,
      'estimated_completion_date': estimatedCompletionDate?.toIso8601String(),
    };
  }

  ServiceRequestModel copyWith({
    int? id,
    String? requestType,
    String? status,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    String? staffNotes,
    String? priority,
    DateTime? estimatedCompletionDate,
  }) {
    return ServiceRequestModel(
      id: id ?? this.id,
      requestType: requestType ?? this.requestType,
      status: status ?? this.status,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      staffNotes: staffNotes ?? this.staffNotes,
      priority: priority ?? this.priority,
      estimatedCompletionDate: estimatedCompletionDate ?? this.estimatedCompletionDate,
    );
  }
}

class ServiceRequestCreateModel {
  final String requestType;
  final String description;
  final String? priority;

  const ServiceRequestCreateModel({
    required this.requestType,
    required this.description,
    this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      'request_type': requestType,
      'description': description,
      if (priority != null) 'priority': priority,
    };
  }
}

class ServiceRequestTypeModel {
  final String name;
  final String description;
  final bool isActive;

  const ServiceRequestTypeModel({
    required this.name,
    required this.description,
    required this.isActive,
  });

  factory ServiceRequestTypeModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestTypeModel(
      name: json['name'] as String,
      description: json['description'] as String,
      isActive: json['is_active'] as bool,
    );
  }
}
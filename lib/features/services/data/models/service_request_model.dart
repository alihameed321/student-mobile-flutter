import '../../domain/entities/service_request.dart';

class ServiceRequestModel extends ServiceRequest {
  const ServiceRequestModel({
    required super.id,
    required super.student,
    required super.requestType,
    required super.title,
    required super.description,
    required super.status,
    required super.priority,
    required super.createdAt,
    super.updatedAt,
    super.processedBy,
    super.processingNotes,
    super.dueDate,
    super.attachments = const [],
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestModel(
      id: json['id'] as int,
      student: json['student'] as String? ?? 'Unknown Student',
      requestType: json['request_type'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? 'No description available',
      status: json['status'] as String,
      priority: json['priority'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
      processedBy: json['processed_by'] as String?,
      processingNotes: json['processing_notes'] as String?,
      dueDate: json['due_date'] != null 
          ? DateTime.parse(json['due_date'] as String) 
          : null,
      attachments: json['attachments'] != null 
          ? List<String>.from(json['attachments'] as List) 
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student': student,
      'request_type': requestType,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'processed_by': processedBy,
      'processing_notes': processingNotes,
      'due_date': dueDate?.toIso8601String(),
      'attachments': attachments,
    };
  }

  ServiceRequestModel copyWith({
    int? id,
    String? student,
    String? requestType,
    String? title,
    String? description,
    String? status,
    String? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? processedBy,
    String? processingNotes,
    DateTime? dueDate,
    List<String>? attachments,
  }) {
    return ServiceRequestModel(
      id: id ?? this.id,
      student: student ?? this.student,
      requestType: requestType ?? this.requestType,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      processedBy: processedBy ?? this.processedBy,
      processingNotes: processingNotes ?? this.processingNotes,
      dueDate: dueDate ?? this.dueDate,
      attachments: attachments ?? this.attachments,
    );
  }
}

class ServiceRequestCreateModel {
  final String requestType;
  final String title;
  final String description;
  final String? priority;

  const ServiceRequestCreateModel({
    required this.requestType,
    required this.title,
    required this.description,
    this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      'request_type': requestType,
      'title': title,
      'description': description,
      if (priority != null) 'priority': priority,
    };
  }
}

class ServiceRequestTypeModel {
  final String value;
  final String label;
  final bool isActive;

  const ServiceRequestTypeModel({
    required this.value,
    required this.label,
    this.isActive = true,
  });

  factory ServiceRequestTypeModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestTypeModel(
      value: json['value'] as String,
      label: json['label'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
  
  // Getter for backward compatibility
  String get name => value;
  String get description => label;
}
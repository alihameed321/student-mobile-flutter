import '../../domain/entities/support_ticket.dart';

class SupportTicketModel extends SupportTicket {
  const SupportTicketModel({
    required super.id,
    required super.subject,
    required super.description,
    required super.category,
    required super.priority,
    required super.status,
    required super.createdAt,
    super.updatedAt,
    super.resolvedAt,
    super.responses,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: json['id'] as int,
      subject: json['subject'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      priority: json['priority'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'] as String)
          : null,
      responses: json['responses'] != null
          ? (json['responses'] as List)
              .map((response) => TicketResponseModel.fromJson(response))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'description': description,
      'category': category,
      'priority': priority,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'resolved_at': resolvedAt?.toIso8601String(),
      'responses': responses
          ?.map((response) => (response as TicketResponseModel).toJson())
          .toList(),
    };
  }

  SupportTicketModel copyWith({
    int? id,
    String? subject,
    String? description,
    String? category,
    String? priority,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
    List<TicketResponse>? responses,
  }) {
    return SupportTicketModel(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      responses: responses ?? this.responses,
    );
  }
}

class SupportTicketCreateModel {
  final String subject;
  final String description;
  final String category;
  final String priority;

  const SupportTicketCreateModel({
    required this.subject,
    required this.description,
    required this.category,
    required this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'description': description,
      'category': category,
      'priority': priority,
    };
  }
}

class TicketResponseModel extends TicketResponse {
  const TicketResponseModel({
    required super.id,
    required super.message,
    required super.createdAt,
    required super.isFromStaff,
    super.staffName,
  });

  factory TicketResponseModel.fromJson(Map<String, dynamic> json) {
    return TicketResponseModel(
      id: json['id'] as int,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isFromStaff: json['is_from_staff'] as bool,
      staffName: json['staff_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'created_at': createdAt.toIso8601String(),
      'is_from_staff': isFromStaff,
      'staff_name': staffName,
    };
  }
}

class TicketResponseCreateModel {
  final String message;

  const TicketResponseCreateModel({
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

class TicketCategoryModel {
  final String name;
  final String description;
  final bool isActive;

  const TicketCategoryModel({
    required this.name,
    required this.description,
    required this.isActive,
  });

  factory TicketCategoryModel.fromJson(Map<String, dynamic> json) {
    return TicketCategoryModel(
      name: json['name'] as String,
      description: json['description'] as String,
      isActive: json['is_active'] as bool,
    );
  }
}

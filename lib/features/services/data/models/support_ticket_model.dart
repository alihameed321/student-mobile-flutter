import '../../domain/entities/support_ticket.dart';

class SupportTicketModel extends SupportTicket {
  const SupportTicketModel({
    required super.id,
    required super.student,
    required super.subject,
    required super.description,
    required super.category,
    required super.priority,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.assignedTo,
    super.ticketNumber,
    super.responses,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: json['id'] as int,
      student: json['student'] as String? ?? '', // May not be present in list view
      subject: json['subject'] as String,
      description: json['description'] as String? ?? '', // May not be present in list view
      category: json['category'] as String,
      priority: json['priority'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      assignedTo: json['assigned_to'] as String?,
      ticketNumber: json['ticket_number'] as String?,
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
      'student': student,
      'subject': subject,
      'description': description,
      'category': category,
      'priority': priority,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'assigned_to': assignedTo,
      'ticket_number': ticketNumber,
      'responses': responses
          ?.map((response) => (response as TicketResponseModel).toJson())
          .toList(),
    };
  }

  SupportTicketModel copyWith({
    int? id,
    String? student,
    String? subject,
    String? description,
    String? category,
    String? priority,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? assignedTo,
    String? ticketNumber,
    List<TicketResponse>? responses,
  }) {
    return SupportTicketModel(
      id: id ?? this.id,
      student: student ?? this.student,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assignedTo: assignedTo ?? this.assignedTo,
      ticketNumber: ticketNumber ?? this.ticketNumber,
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
    required super.ticketId,
    required super.message,
    required super.createdAt,
    required super.isFromStaff,
    required super.authorName,
    super.authorPosition,
    super.isInternal = false,
  });

  factory TicketResponseModel.fromJson(Map<String, dynamic> json) {
    return TicketResponseModel(
      id: json['id'] as int,
      ticketId: json['ticket_id'] as int,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isFromStaff: json['is_from_staff'] as bool,
      authorName: json['author_name'] as String,
      authorPosition: json['author_position'] as String?,
      isInternal: json['is_internal'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_id': ticketId,
      'message': message,
      'created_at': createdAt.toIso8601String(),
      'is_from_staff': isFromStaff,
      'author_name': authorName,
      'author_position': authorPosition,
      'is_internal': isInternal,
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

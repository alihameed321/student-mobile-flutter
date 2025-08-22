import '../../domain/entities/student_fee.dart';

class StudentFeeModel extends StudentFee {
  const StudentFeeModel({
    required super.id,
    required super.studentName,
    required super.studentId,
    required super.feeType,
    required super.amount,
    required super.amountPaid,
    required super.remainingBalance,
    required super.status,
    super.dueDate,
    required super.semester,
    required super.academicYear,
    required super.createdAt,
    required super.updatedAt,
  });

  factory StudentFeeModel.fromJson(Map<String, dynamic> json) {
    return StudentFeeModel(
      id: json['id'] as int? ?? 0,
      studentName: json['student_name'] as String? ?? '',
      studentId: json['student_id'] as String? ?? '',
      feeType: FeeTypeModel.fromJson(json['fee_type'] as Map<String, dynamic>? ?? {}),
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      amountPaid: double.tryParse(json['amount_paid']?.toString() ?? '0') ?? 0.0,
      remainingBalance: double.tryParse(json['remaining_balance']?.toString() ?? '0') ?? 0.0,
      status: json['status'] as String? ?? '',
      dueDate: DateTime.tryParse(json['due_date'] as String? ?? ''),
      semester: json['semester'] as String? ?? 'Current',
      academicYear: json['academic_year'] as String? ?? '2024-2025',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_name': studentName,
      'student_id': studentId,
      'fee_type': (feeType as FeeTypeModel).toJson(),
      'amount': amount,
      'amount_paid': amountPaid,
      'remaining_balance': remainingBalance,
      'status': status,
      'due_date': dueDate?.toIso8601String(),
      'semester': semester,
      'academic_year': academicYear,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class FeeTypeModel extends FeeType {
  const FeeTypeModel({
    required super.id,
    required super.name,
    super.description,
    required super.category,
    required super.isActive,
  });

  factory FeeTypeModel.fromJson(Map<String, dynamic> json) {
    return FeeTypeModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      category: json['category'] as String? ?? 'General',
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
    };
  }
}
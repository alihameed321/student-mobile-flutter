import 'package:equatable/equatable.dart';

class StudentFee extends Equatable {
  final int id;
  final String studentName;
  final String studentId;
  final FeeType feeType;
  final double amount;
  final double amountPaid;
  final double remainingBalance;
  final String status;
  final DateTime? dueDate;
  final String semester;
  final String academicYear;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? daysPastDue;

  const StudentFee({
    required this.id,
    required this.studentName,
    required this.studentId,
    required this.feeType,
    required this.amount,
    required this.amountPaid,
    required this.remainingBalance,
    required this.status,
    this.dueDate,
    required this.semester,
    required this.academicYear,
    required this.createdAt,
    required this.updatedAt,
    this.daysPastDue,
  });

  bool get isOverdue {
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!) && status != 'paid';
  }

  bool get isPaid => status == 'paid';
  bool get isPending => status == 'pending';
  bool get isPartiallyPaid => status == 'partially_paid';

  @override
  List<Object?> get props => [
        id,
        studentName,
        studentId,
        feeType,
        amount,
        amountPaid,
        remainingBalance,
        status,
        dueDate,
        semester,
        academicYear,
        createdAt,
        updatedAt,
        daysPastDue,
      ];
}

class FeeType extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String category;
  final bool isActive;

  const FeeType({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        isActive,
      ];
}
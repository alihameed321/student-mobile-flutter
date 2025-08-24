import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final int id;
  final String studentName;
  final String studentId;
  final String paymentReference;
  final double amount;
  final PaymentProvider paymentProvider;
  final String status;
  final String? transactionReference;
  final DateTime? paymentDate;
  final DateTime? verifiedDate;
  final String? receiptNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<PaymentFee> fees;

  const Payment({
    required this.id,
    required this.studentName,
    required this.studentId,
    required this.paymentReference,
    required this.amount,
    required this.paymentProvider,
    required this.status,
    this.transactionReference,
    this.paymentDate,
    this.verifiedDate,
    this.receiptNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.fees,
  });

  bool get isPending => status == 'pending';
  bool get isVerified => status == 'verified';
  bool get isRejected => status == 'rejected';
  bool get isCancelled => status == 'cancelled';

  @override
  List<Object?> get props => [
        id,
        studentName,
        studentId,
        paymentReference,
        amount,
        paymentProvider,
        status,
        transactionReference,
        paymentDate,
        verifiedDate,
        receiptNumber,
        createdAt,
        updatedAt,
        fees,
      ];
}

class PaymentProvider extends Equatable {
  final int id;
  final String name;
  final String type;
  final bool isActive;
  final String? instructions;
  final String? logo;
  final String? universityAccountName;
  final String? universityAccountNumber;
  final String? universityPhone;
  final String? additionalInfo;

  const PaymentProvider({
    required this.id,
    required this.name,
    required this.type,
    required this.isActive,
    this.instructions,
    this.logo,
    this.universityAccountName,
    this.universityAccountNumber,
    this.universityPhone,
    this.additionalInfo,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        isActive,
        instructions,
        logo,
        universityAccountName,
        universityAccountNumber,
        universityPhone,
        additionalInfo,
      ];
}

class PaymentFee extends Equatable {
  final int feeId;
  final String feeType;
  final double amount;

  const PaymentFee({
    required this.feeId,
    required this.feeType,
    required this.amount,
  });

  @override
  List<Object?> get props => [
        feeId,
        feeType,
        amount,
      ];
}

class PaymentStatistics extends Equatable {
  final int totalPayments;
  final PaymentStatusCount statusCounts;
  final List<MonthlyPayment> monthlyBreakdown;

  const PaymentStatistics({
    required this.totalPayments,
    required this.statusCounts,
    required this.monthlyBreakdown,
  });

  @override
  List<Object?> get props => [
        totalPayments,
        statusCounts,
        monthlyBreakdown,
      ];
}

class PaymentStatusCount extends Equatable {
  final int pending;
  final int verified;
  final int rejected;
  final int cancelled;

  const PaymentStatusCount({
    required this.pending,
    required this.verified,
    required this.rejected,
    required this.cancelled,
  });

  int get total => pending + verified + rejected + cancelled;

  @override
  List<Object?> get props => [
        pending,
        verified,
        rejected,
        cancelled,
      ];
}

class MonthlyPayment extends Equatable {
  final String month;
  final double totalAmount;
  final int count;

  const MonthlyPayment({
    required this.month,
    required this.totalAmount,
    required this.count,
  });

  @override
  List<Object?> get props => [
        month,
        totalAmount,
        count,
      ];
}
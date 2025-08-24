import '../../domain/entities/payment.dart';

class PaymentModel extends Payment {
  const PaymentModel({
    required super.id,
    required super.studentName,
    required super.studentId,
    required super.paymentReference,
    required super.amount,
    required super.paymentProvider,
    required super.status,
    super.transactionReference,
    super.paymentDate,
    super.verifiedDate,
    super.receiptNumber,
    required super.createdAt,
    required super.updatedAt,
    required super.fees,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as int? ?? 0,
      studentName: json['student_name'] as String? ?? '',
      studentId: json['student_id'] as String? ?? '',
      paymentReference: json['payment_reference'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paymentProvider: PaymentProviderModel.fromJson(
        json['payment_provider'] as Map<String, dynamic>? ?? {},
      ),
      status: json['status'] as String? ?? '',
      transactionReference: json['transaction_reference'] as String?,
      paymentDate: json['payment_date'] != null ? DateTime.tryParse(json['payment_date'] as String) : null,
      verifiedDate: json['verified_date'] != null ? DateTime.tryParse(json['verified_date'] as String) : null,
      receiptNumber: json['receipt_number'] as String?,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ?? DateTime.now(),
      fees: (json['fees'] as List<dynamic>?)
          ?.map((e) => PaymentFeeModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_name': studentName,
      'student_id': studentId,
      'payment_reference': paymentReference,
      'amount': amount,
      'payment_provider': (paymentProvider as PaymentProviderModel).toJson(),
      'status': status,
      'transaction_reference': transactionReference,
      'payment_date': paymentDate?.toIso8601String(),
      'verified_date': verifiedDate?.toIso8601String(),
      'receipt_number': receiptNumber,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'fees': fees.map((e) => (e as PaymentFeeModel).toJson()).toList(),
    };
  }
}

class PaymentProviderModel extends PaymentProvider {
  const PaymentProviderModel({
    required super.id,
    required super.name,
    required super.type,
    required super.isActive,
    super.instructions,
    super.logo,
    super.universityAccountName,
    super.universityAccountNumber,
    super.universityPhone,
    super.additionalInfo,
  });

  factory PaymentProviderModel.fromJson(Map<String, dynamic> json) {
    return PaymentProviderModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      type: json['description'] as String? ?? '', // Backend uses 'description' field
      isActive: json['is_active'] as bool? ?? true,
      instructions: json['instructions'] as String?,
      logo: json['logo'] as String?,
      universityAccountName: json['university_account_name'] as String?,
      universityAccountNumber: json['university_account_number'] as String?,
      universityPhone: json['university_phone'] as String?,
      additionalInfo: json['additional_info'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': type,
      'is_active': isActive,
      'instructions': instructions,
      'logo': logo,
      'university_account_name': universityAccountName,
      'university_account_number': universityAccountNumber,
      'university_phone': universityPhone,
      'additional_info': additionalInfo,
    };
  }
}

class PaymentFeeModel extends PaymentFee {
  const PaymentFeeModel({
    required super.feeId,
    required super.feeType,
    required super.amount,
  });

  factory PaymentFeeModel.fromJson(Map<String, dynamic> json) {
    return PaymentFeeModel(
      feeId: json['fee_id'] as int? ?? 0,
      feeType: json['fee_type'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fee_id': feeId,
      'fee_type': feeType,
      'amount': amount,
    };
  }
}

class PaymentStatisticsModel extends PaymentStatistics {
  const PaymentStatisticsModel({
    required super.totalPayments,
    required super.statusCounts,
    required super.monthlyBreakdown,
  });

  factory PaymentStatisticsModel.fromJson(Map<String, dynamic> json) {
    return PaymentStatisticsModel(
      totalPayments: json['total_payments'] as int? ?? 0,
      statusCounts: PaymentStatusCountModel.fromJson(
        json['status_counts'] as Map<String, dynamic>? ?? {},
      ),
      monthlyBreakdown: (json['monthly_breakdown'] as List<dynamic>?)
          ?.map((e) => MonthlyPaymentModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_payments': totalPayments,
      'status_counts': (statusCounts as PaymentStatusCountModel).toJson(),
      'monthly_breakdown': monthlyBreakdown
          .map((e) => (e as MonthlyPaymentModel).toJson())
          .toList(),
    };
  }
}

class PaymentStatusCountModel extends PaymentStatusCount {
  const PaymentStatusCountModel({
    required super.pending,
    required super.verified,
    required super.rejected,
    required super.cancelled,
  });

  factory PaymentStatusCountModel.fromJson(Map<String, dynamic> json) {
    return PaymentStatusCountModel(
      pending: json['pending'] as int? ?? 0,
      verified: json['verified'] as int? ?? 0,
      rejected: json['rejected'] as int? ?? 0,
      cancelled: json['cancelled'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pending': pending,
      'verified': verified,
      'rejected': rejected,
      'cancelled': cancelled,
    };
  }
}

class MonthlyPaymentModel extends MonthlyPayment {
  const MonthlyPaymentModel({
    required super.month,
    required super.totalAmount,
    required super.count,
  });

  factory MonthlyPaymentModel.fromJson(Map<String, dynamic> json) {
    return MonthlyPaymentModel(
      month: json['month'] as String? ?? 'January',
      count: json['count'] as int? ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'count': count,
      'total_amount': totalAmount,
    };
  }
}
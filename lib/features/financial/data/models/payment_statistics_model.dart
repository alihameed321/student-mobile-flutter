class PaymentStatisticsModel {
  final double totalPayments;
  final int totalPaymentCount;
  final Map<String, int> paymentsByStatus;
  final List<MonthlyPaymentModel> monthlyPayments;
  final List<RecentPaymentModel> recentPayments;
  final Map<String, int> paymentProviderUsage;
  final CurrentYearStatsModel currentYearStats;

  const PaymentStatisticsModel({
    required this.totalPayments,
    required this.totalPaymentCount,
    required this.paymentsByStatus,
    required this.monthlyPayments,
    required this.recentPayments,
    required this.paymentProviderUsage,
    required this.currentYearStats,
  });

  factory PaymentStatisticsModel.fromJson(Map<String, dynamic> json) {
    return PaymentStatisticsModel(
      totalPayments: double.tryParse(json['total_payments']?.toString() ?? '0') ?? 0.0,
      totalPaymentCount: json['total_payment_count'] as int? ?? 0,
      paymentsByStatus: Map<String, int>.from(json['payments_by_status'] ?? {}),
      monthlyPayments: (json['monthly_payments'] as List<dynamic>? ?? [])
          .map((e) => MonthlyPaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentPayments: (json['recent_payments'] as List<dynamic>? ?? [])
          .map((e) => RecentPaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentProviderUsage: Map<String, int>.from(json['payment_provider_usage'] ?? {}),
      currentYearStats: CurrentYearStatsModel.fromJson(
        json['current_year_stats'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_payments': totalPayments,
      'total_payment_count': totalPaymentCount,
      'payments_by_status': paymentsByStatus,
      'monthly_payments': monthlyPayments.map((e) => e.toJson()).toList(),
      'recent_payments': recentPayments.map((e) => e.toJson()).toList(),
      'payment_provider_usage': paymentProviderUsage,
      'current_year_stats': currentYearStats.toJson(),
    };
  }
}

class MonthlyPaymentModel {
  final String month;
  final double totalAmount;
  final int paymentCount;

  const MonthlyPaymentModel({
    required this.month,
    required this.totalAmount,
    required this.paymentCount,
  });

  factory MonthlyPaymentModel.fromJson(Map<String, dynamic> json) {
    return MonthlyPaymentModel(
      month: json['month'] as String? ?? '',
      totalAmount: double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0.0,
      paymentCount: json['payment_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'total_amount': totalAmount,
      'payment_count': paymentCount,
    };
  }
}

class RecentPaymentModel {
  final int id;
  final double amount;
  final String status;
  final DateTime paymentDate;
  final String paymentProvider;
  final String feeType;

  const RecentPaymentModel({
    required this.id,
    required this.amount,
    required this.status,
    required this.paymentDate,
    required this.paymentProvider,
    required this.feeType,
  });

  factory RecentPaymentModel.fromJson(Map<String, dynamic> json) {
    return RecentPaymentModel(
      id: json['id'] as int? ?? 0,
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      status: json['status'] as String? ?? '',
      paymentDate: DateTime.tryParse(json['payment_date'] as String? ?? '') ?? DateTime.now(),
      paymentProvider: json['payment_provider'] as String? ?? '',
      feeType: json['fee_type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'status': status,
      'payment_date': paymentDate.toIso8601String(),
      'payment_provider': paymentProvider,
      'fee_type': feeType,
    };
  }
}

class CurrentYearStatsModel {
  final double totalAmount;
  final int paymentCount;
  final double averagePayment;

  const CurrentYearStatsModel({
    required this.totalAmount,
    required this.paymentCount,
    required this.averagePayment,
  });

  factory CurrentYearStatsModel.fromJson(Map<String, dynamic> json) {
    return CurrentYearStatsModel(
      totalAmount: double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0.0,
      paymentCount: json['payment_count'] as int? ?? 0,
      averagePayment: double.tryParse(json['average_payment']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_amount': totalAmount,
      'payment_count': paymentCount,
      'average_payment': averagePayment,
    };
  }
}
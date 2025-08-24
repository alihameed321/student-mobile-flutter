import 'package:equatable/equatable.dart';

class FinancialSummary extends Equatable {
  final double totalFees;
  final double pendingPayments;
  final double paidThisSemester;
  final int overdueCount;
  final double overdueAmount;
  final int pendingCount;
  final int partialCount;
  final Map<String, dynamic> paymentStatistics;
  final List<RecentTransaction> recentTransactions;
  final List<FeeBreakdown> feeBreakdown;

  const FinancialSummary({
    required this.totalFees,
    required this.pendingPayments,
    required this.paidThisSemester,
    required this.overdueCount,
    required this.overdueAmount,
    required this.pendingCount,
    required this.partialCount,
    required this.paymentStatistics,
    required this.recentTransactions,
    required this.feeBreakdown,
  });

  @override
  List<Object?> get props => [
        totalFees,
        pendingPayments,
        paidThisSemester,
        overdueCount,
        overdueAmount,
        pendingCount,
        partialCount,
        paymentStatistics,
        recentTransactions,
        feeBreakdown,
      ];
}

class RecentTransaction extends Equatable {
  final int paymentId;
  final double amount;
  final DateTime paymentDate;
  final String paymentProvider;
  final String status;
  final int feeId;
  final String feeType;

  const RecentTransaction({
    required this.paymentId,
    required this.amount,
    required this.paymentDate,
    required this.paymentProvider,
    required this.status,
    required this.feeId,
    required this.feeType,
  });

  @override
  List<Object?> get props => [
        paymentId,
        amount,
        paymentDate,
        paymentProvider,
        status,
        feeId,
        feeType,
      ];
}

class FeeBreakdown extends Equatable {
  final String feeType;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final int count;

  const FeeBreakdown({
    required this.feeType,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.count,
  });

  @override
  List<Object?> get props => [
        feeType,
        totalAmount,
        paidAmount,
        remainingAmount,
        count,
      ];
}
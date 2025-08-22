part of 'financial_bloc.dart';

abstract class FinancialEvent extends Equatable {
  const FinancialEvent();

  @override
  List<Object?> get props => [];
}

class LoadFinancialSummary extends FinancialEvent {
  final String studentId;

  const LoadFinancialSummary(this.studentId);

  @override
  List<Object?> get props => [studentId];
}

class LoadStudentFees extends FinancialEvent {
  final String studentId;
  final bool isRefresh;

  const LoadStudentFees({
    required this.studentId,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [
        studentId,
        isRefresh,
      ];
}

class LoadPayments extends FinancialEvent {
  final String studentId;
  final bool isRefresh;

  const LoadPayments({
    required this.studentId,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [
        studentId,
        isRefresh,
      ];
}

class CreatePaymentEvent extends FinancialEvent {
  final String studentId;
  final List<String> feeIds;
  final String paymentProviderId;
  final double amount;

  const CreatePaymentEvent({
    required this.studentId,
    required this.feeIds,
    required this.paymentProviderId,
    required this.amount,
  });

  @override
  List<Object?> get props => [
        studentId,
        feeIds,
        paymentProviderId,
        amount,
      ];
}

class RefreshFinancialData extends FinancialEvent {
  final String studentId;

  const RefreshFinancialData(this.studentId);

  @override
  List<Object?> get props => [studentId];
}
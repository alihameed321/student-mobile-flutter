part of 'financial_bloc.dart';

abstract class FinancialState extends Equatable {
  const FinancialState();

  @override
  List<Object?> get props => [];
}

class FinancialInitial extends FinancialState {}

class FinancialLoading extends FinancialState {}

class FinancialError extends FinancialState {
  final String message;

  const FinancialError(this.message);

  @override
  List<Object?> get props => [message];
}

// Financial Summary States
class FinancialSummaryLoaded extends FinancialState {
  final FinancialSummary summary;

  const FinancialSummaryLoaded(this.summary);

  @override
  List<Object?> get props => [summary];
}

// Student Fees States
class FeesLoading extends FinancialState {}

class FeesLoaded extends FinancialState {
  final List<StudentFee> fees;

  const FeesLoaded(this.fees);

  @override
  List<Object?> get props => [fees];
}

class OutstandingFeesLoaded extends FinancialState {
  final List<StudentFee> fees;

  const OutstandingFeesLoaded(this.fees);

  @override
  List<Object?> get props => [fees];
}

// Payments States
class PaymentsLoading extends FinancialState {}

class PaymentsLoaded extends FinancialState {
  final List<Payment> payments;

  const PaymentsLoaded(this.payments);

  @override
  List<Object?> get props => [payments];
}

// Payment Providers States
class PaymentProvidersLoaded extends FinancialState {
  final List<PaymentProvider> providers;

  const PaymentProvidersLoaded(this.providers);

  @override
  List<Object?> get props => [providers];
}

// Payment Creation States
class PaymentCreating extends FinancialState {}

class PaymentCreated extends FinancialState {
  final Payment payment;

  const PaymentCreated(this.payment);

  @override
  List<Object?> get props => [payment];
}
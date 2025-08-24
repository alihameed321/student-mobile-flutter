import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/financial_summary.dart';
import '../../domain/entities/student_fee.dart';
import '../../domain/entities/payment.dart';
import '../../domain/usecases/get_financial_summary.dart';
import '../../domain/usecases/get_student_fees.dart';
import '../../domain/usecases/get_payments.dart';
import '../../domain/usecases/get_payment_providers.dart';
import '../../domain/usecases/create_payment.dart';

part 'financial_event.dart';
part 'financial_state.dart';

class FinancialBloc extends Bloc<FinancialEvent, FinancialState> {
  final GetFinancialSummary getFinancialSummary;
  final GetStudentFees getStudentFees;
  final GetPayments getPayments;
  final GetPaymentProviders getPaymentProviders;
  final CreatePayment createPayment;

  FinancialBloc({
    required this.getFinancialSummary,
    required this.getStudentFees,
    required this.getPayments,
    required this.getPaymentProviders,
    required this.createPayment,
  }) : super(FinancialInitial()) {
    on<LoadFinancialSummary>(_onLoadFinancialSummary);
    on<LoadStudentFees>(_onLoadStudentFees);
    on<LoadPayments>(_onLoadPayments);
    on<LoadPaymentProviders>(_onLoadPaymentProviders);
    on<CreatePaymentEvent>(_onCreatePayment);
    on<RefreshFinancialData>(_onRefreshFinancialData);
  }

  Future<void> _onLoadFinancialSummary(
    LoadFinancialSummary event,
    Emitter<FinancialState> emit,
  ) async {
    print('FinancialBloc: Loading financial summary for student: ${event.studentId}');
    emit(FinancialLoading());
    
    final result = await getFinancialSummary(event.studentId);
    
    result.fold(
      (failure) {
        print('FinancialBloc: Error loading financial summary: ${failure.message}');
        emit(FinancialError(failure.message));
      },
      (summary) {
        print('FinancialBloc: Successfully loaded financial summary');
        print('FinancialBloc: Total fees: ${summary.totalFees}');
        print('FinancialBloc: Pending payments: ${summary.pendingPayments}');
        print('FinancialBloc: Recent transactions count: ${summary.recentTransactions.length}');
        emit(FinancialSummaryLoaded(summary));
      },
    );
  }

  Future<void> _onLoadStudentFees(
    LoadStudentFees event,
    Emitter<FinancialState> emit,
  ) async {
    if (event.isRefresh) {
      emit(FinancialLoading());
    } else {
      emit(FeesLoading());
    }
    
    final result = await getStudentFees(event.studentId);
    
    result.fold(
      (failure) => emit(FinancialError(failure.message)),
      (fees) => emit(FeesLoaded(fees)),
    );
  }

  Future<void> _onLoadPayments(
    LoadPayments event,
    Emitter<FinancialState> emit,
  ) async {
    if (event.isRefresh) {
      emit(FinancialLoading());
    } else {
      emit(PaymentsLoading());
    }
    
    final result = await getPayments(event.studentId);
    
    result.fold(
      (failure) => emit(FinancialError(failure.message)),
      (payments) => emit(PaymentsLoaded(payments)),
    );
  }

  Future<void> _onCreatePayment(
    CreatePaymentEvent event,
    Emitter<FinancialState> emit,
  ) async {
    emit(PaymentCreating());
    
    final result = await createPayment(
      studentId: event.studentId,
      feeIds: event.feeIds,
      paymentProviderId: event.paymentProviderId,
      amount: event.amount,
      transactionReference: event.transactionReference,
      senderName: event.senderName,
      senderPhone: event.senderPhone,
      transferNotes: event.transferNotes,
    );
    
    result.fold(
      (failure) => emit(FinancialError(failure.message)),
      (payment) => emit(PaymentCreated(payment)),
    );
  }

  Future<void> _onLoadPaymentProviders(
    LoadPaymentProviders event,
    Emitter<FinancialState> emit,
  ) async {
    print('FinancialBloc: Loading payment providers');
    emit(FinancialLoading());
    
    final result = await getPaymentProviders();
    
    result.fold(
      (failure) {
        print('FinancialBloc: Error loading payment providers: ${failure.message}');
        emit(FinancialError(failure.message));
      },
      (providers) {
        print('FinancialBloc: Successfully loaded ${providers.length} payment providers');
        emit(PaymentProvidersLoaded(providers));
      },
    );
  }

  Future<void> _onRefreshFinancialData(
    RefreshFinancialData event,
    Emitter<FinancialState> emit,
  ) async {
    // Refresh all financial data
    add(LoadFinancialSummary(event.studentId));
  }
}
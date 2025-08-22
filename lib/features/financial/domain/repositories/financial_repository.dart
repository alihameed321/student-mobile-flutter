import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/financial_summary.dart';
import '../entities/student_fee.dart';
import '../entities/payment.dart';

abstract class FinancialRepository {
  /// Get financial summary for the student
  Future<Either<Failure, FinancialSummary>> getFinancialSummary(String studentId);

  /// Get student fees
  Future<Either<Failure, List<StudentFee>>> getStudentFees(String studentId);



  /// Get all outstanding fees for the current student
  Future<Either<Failure, List<StudentFee>>> getOutstandingFees();

  /// Get all available payment providers
  Future<Either<Failure, List<PaymentProvider>>> getPaymentProviders();

  /// Get payments for the student
  Future<Either<Failure, List<Payment>>> getPayments(String studentId);



  /// Create a new payment
  Future<Either<Failure, Payment>> createPayment({
    required String studentId,
    required List<String> feeIds,
    required String paymentProviderId,
    required double amount,
  });

  /// Get payment statistics for the student
  Future<Either<Failure, PaymentStatistics>> getPaymentStatistics(String studentId);

  /// View receipt details for a payment
  Future<Either<Failure, Map<String, dynamic>>> viewReceipt(int paymentId);

  /// Download receipt PDF for a payment
  Future<Either<Failure, List<int>>> downloadReceipt(int paymentId);
}
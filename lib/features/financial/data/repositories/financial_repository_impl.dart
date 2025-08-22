import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/financial_summary.dart';
import '../../domain/entities/student_fee.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/financial_repository.dart';
import '../datasources/financial_api_service.dart';
import '../models/financial_summary_model.dart';
import '../models/student_fee_model.dart';
import '../models/payment_model.dart';

class FinancialRepositoryImpl implements FinancialRepository {
  final FinancialApiService _apiService;

  FinancialRepositoryImpl(this._apiService);

  @override
  Future<Either<Failure, FinancialSummary>> getFinancialSummary(String studentId) async {
    try {
      final summaryModel = await _apiService.getFinancialSummary(studentId);
      return Right(_mapSummaryModelToEntity(summaryModel));
    } on ServerException {
      return Left(ServerFailure('Failed to fetch financial summary'));
    } on NetworkException {
      return Left(NetworkFailure('No internet connection'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<StudentFee>>> getStudentFees(String studentId) async {
    try {
      print('[FinancialRepository] Fetching student fees for ID: $studentId');
      final feeModels = await _apiService.getStudentFees(studentId);
      print('[FinancialRepository] Received ${feeModels.length} fee models from API');
      final fees = feeModels.map(_mapFeeModelToEntity).toList();
      print('[FinancialRepository] Successfully mapped ${fees.length} fees');
      return Right(fees);
    } on ServerException catch (e) {
      print('[FinancialRepository] ServerException: $e');
      return Left(ServerFailure('Failed to fetch student fees'));
    } on NetworkException catch (e) {
      print('[FinancialRepository] NetworkException: $e');
      return Left(NetworkFailure('No internet connection'));
    } catch (e, stackTrace) {
      print('[FinancialRepository] Unexpected error: $e');
      print('[FinancialRepository] Stack trace: $stackTrace');
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }



  @override
  Future<Either<Failure, List<StudentFee>>> getOutstandingFees() async {
    try {
      // Get student ID from somewhere - this needs to be passed as parameter
      // For now, using a placeholder - this method signature needs to be updated
      final feeModels = await _apiService.getStudentFees('student_id_placeholder');
      final fees = feeModels
          .where((fee) => fee.status == 'pending' || fee.status == 'overdue')
          .map(_mapFeeModelToEntity)
          .toList();
      return Right(fees);
    } on ServerException {
      return Left(ServerFailure('Failed to fetch outstanding fees'));
    } on NetworkException {
      return Left(NetworkFailure('No internet connection'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<PaymentProvider>>> getPaymentProviders() async {
    try {
      final providerModels = await _apiService.getPaymentProviders();
      final providers = providerModels.map(_mapProviderModelToEntity).toList();
      return Right(providers);
    } on ServerException {
      return Left(ServerFailure('Failed to fetch payment providers'));
    } on NetworkException {
      return Left(NetworkFailure('No internet connection'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<Payment>>> getPayments(String studentId) async {
    try {
      final paymentModels = await _apiService.getPayments(studentId);
      final payments = paymentModels.map(_mapPaymentModelToEntity).toList();
      return Right(payments);
    } on ServerException {
      return Left(ServerFailure('Failed to fetch payments'));
    } on NetworkException {
      return Left(NetworkFailure('No internet connection'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }



  @override
  Future<Either<Failure, Payment>> createPayment({
    required String studentId,
    required List<String> feeIds,
    required String paymentProviderId,
    required double amount,
  }) async {
    try {
      final paymentModel = await _apiService.createPayment(
        studentId: studentId,
        feeIds: feeIds,
        paymentProviderId: paymentProviderId,
        amount: amount,
      );
      return Right(_mapPaymentModelToEntity(paymentModel));
    } on ServerException {
      return Left(ServerFailure('Failed to create payment'));
    } on NetworkException {
      return Left(NetworkFailure('No internet connection'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, PaymentStatistics>> getPaymentStatistics(String studentId) async {
    try {
      final statsModel = await _apiService.getPaymentStatistics(studentId);
      return Right(_mapStatsModelToEntity(statsModel));
    } on ServerException {
      return Left(ServerFailure('Failed to fetch payment statistics'));
    } on NetworkException {
      return Left(NetworkFailure('No internet connection'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> viewReceipt(int paymentId) async {
    try {
      final receipt = await _apiService.viewReceipt(paymentId.toString());
      // Parse the String response to Map<String, dynamic>
      return Right({'receipt_url': receipt});
    } on ServerException {
      return Left(ServerFailure('Failed to view receipt'));
    } on NetworkException {
      return Left(NetworkFailure('No internet connection'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<int>>> downloadReceipt(int paymentId) async {
    try {
      final response = await _apiService.downloadReceipt(paymentId.toString());
      return Right(response.data as List<int>);
    } on ServerException {
      return Left(ServerFailure('Failed to download receipt'));
    } on NetworkException {
      return Left(NetworkFailure('No internet connection'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  // Helper methods to map models to entities
  FinancialSummary _mapSummaryModelToEntity(FinancialSummaryModel model) {
    return FinancialSummary(
      totalFees: model.totalFees,
      pendingPayments: model.pendingPayments,
      paidThisSemester: model.paidThisSemester,
      overdueCount: model.overdueCount,
      recentTransactions: model.recentTransactions
          .map((t) => RecentTransaction(
                paymentId: t.paymentId,
                amount: t.amount,
                paymentDate: t.paymentDate,
                paymentProvider: t.paymentProvider,
                status: t.status,
                feeId: t.feeId,
                feeType: t.feeType,
              ))
          .toList(),
      feeBreakdown: model.feeBreakdown
          .map((f) => FeeBreakdown(
                feeType: f.feeType,
                totalAmount: f.totalAmount,
                paidAmount: f.paidAmount,
                remainingAmount: f.remainingAmount,
                count: f.count,
              ))
          .toList(),
    );
  }

  StudentFee _mapFeeModelToEntity(StudentFeeModel model) {
    return StudentFee(
      id: model.id,
      studentName: model.studentName,
      studentId: model.studentId,
      feeType: FeeType(
        id: model.feeType.id,
        name: model.feeType.name,
        description: model.feeType.description,
        category: model.feeType.category,
        isActive: model.feeType.isActive,
      ),
      amount: model.amount,
      amountPaid: model.amountPaid,
      remainingBalance: model.remainingBalance,
      status: model.status,
      dueDate: model.dueDate,
      semester: model.semester,
      academicYear: model.academicYear,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  PaymentProvider _mapProviderModelToEntity(PaymentProviderModel model) {
    return PaymentProvider(
      id: model.id,
      name: model.name,
      type: model.type,
      isActive: model.isActive,
      instructions: model.instructions,
    );
  }

  Payment _mapPaymentModelToEntity(PaymentModel model) {
    return Payment(
      id: model.id,
      studentName: model.studentName,
      studentId: model.studentId,
      paymentReference: model.paymentReference,
      amount: model.amount,
      paymentProvider: PaymentProvider(
        id: model.paymentProvider.id,
        name: model.paymentProvider.name,
        type: model.paymentProvider.type,
        isActive: model.paymentProvider.isActive,
        instructions: model.paymentProvider.instructions,
      ),
      status: model.status,
      transactionReference: model.transactionReference,
      paymentDate: model.paymentDate,
      verifiedDate: model.verifiedDate,
      receiptNumber: model.receiptNumber,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      fees: model.fees
          .map((f) => PaymentFee(
                feeId: f.feeId,
                feeType: f.feeType,
                amount: f.amount,
              ))
          .toList(),
    );
  }

  PaymentStatistics _mapStatsModelToEntity(PaymentStatisticsModel model) {
    return PaymentStatistics(
      totalPayments: model.totalPayments,
      statusCounts: PaymentStatusCount(
        pending: model.statusCounts.pending,
        verified: model.statusCounts.verified,
        rejected: model.statusCounts.rejected,
        cancelled: model.statusCounts.cancelled,
      ),
      monthlyBreakdown: model.monthlyBreakdown
          .map((m) => MonthlyPayment(
                month: m.month,
                totalAmount: m.totalAmount,
                count: m.count,
              ))
          .toList(),
    );
  }
}
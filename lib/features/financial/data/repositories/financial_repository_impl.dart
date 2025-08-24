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
import '../models/payment_statistics_model.dart' as stats;

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
      final response = await _apiService.getStudentFees(
        status: null,
        feeType: null,
        page: 1,
        pageSize: 50,
      );
      print('[FinancialRepository] Raw response: $response');
      print('[FinancialRepository] Response type: ${response.runtimeType}');
      print('[FinancialRepository] Response keys: ${response.keys}');
      final results = response['results'];
      if (results == null) {
        print('[FinancialRepository] Results field is null in response');
        return Left(ServerFailure('Invalid response format'));
      }
      final feeModels = (results as List)
          .map((json) => StudentFeeModel.fromJson(json))
          .toList();
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
      final feeModels = await _apiService.getOutstandingFees();
      final fees = feeModels.map(_mapFeeModelToEntity).toList();
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
      final response = await _apiService.getPayments(
        page: 1,
        pageSize: 50,
      );
      final paymentModels = (response['payments'] as List)
          .map((json) => PaymentModel.fromJson(json))
          .toList();
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
    String? transactionReference,
    String? senderName,
    String? senderPhone,
    String? transferNotes,
  }) async {
    try {
      // Get the actual fee amounts from the outstanding fees
      final outstandingFeesResult = await getOutstandingFees();
      final Map<String, double> feeAmountMap = {};
      
      outstandingFeesResult.fold(
        (failure) => throw Exception('Failed to get fee amounts'),
        (fees) {
          for (final fee in fees) {
            feeAmountMap[fee.id.toString()] = fee.remainingBalance;
          }
        },
      );
      
      // Convert feeIds to the format expected by the API with actual amounts
      final fees = feeIds.map((id) => {
        'id': id,
        'amount': feeAmountMap[id] ?? (amount / feeIds.length), // Use actual fee amount or fallback to even distribution
      }).toList();
      
      // Calculate the correct total amount from the actual fee amounts
      double calculatedTotal = 0.0;
      for (final fee in fees) {
        calculatedTotal += (fee['amount'] as double);
      }
      
      final response = await _apiService.createPayment(
        fees: fees,
        paymentProviderId: paymentProviderId,
        totalAmount: calculatedTotal,
        transactionReference: transactionReference,
        senderName: senderName,
        senderPhone: senderPhone,
        transferNotes: transferNotes,
      );
      
      // The API returns 'payments' array, get the first payment
      final payments = response['payments'] as List;
      if (payments.isEmpty) {
        return Left(ServerFailure('No payment data returned'));
      }
      final paymentModel = PaymentModel.fromJson(payments[0]);
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
      final response = await _apiService.getPaymentStatistics();
      final statsModel = PaymentStatisticsModel.fromJson(response);
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
      overdueAmount: model.overdueAmount,
      pendingCount: model.pendingCount,
      partialCount: model.partialCount,
      paymentStatistics: model.paymentStatistics,
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
      daysPastDue: model.daysPastDue,
    );
  }

  PaymentProvider _mapProviderModelToEntity(PaymentProviderModel model) {
    return PaymentProvider(
      id: model.id,
      name: model.name,
      type: model.type,
      isActive: model.isActive,
      instructions: model.instructions,
      logo: model.logo,
      universityAccountName: model.universityAccountName,
      universityAccountNumber: model.universityAccountNumber,
      universityPhone: model.universityPhone,
      additionalInfo: model.additionalInfo,
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
        logo: model.paymentProvider.logo,
        universityAccountName: model.paymentProvider.universityAccountName,
        universityAccountNumber: model.paymentProvider.universityAccountNumber,
        universityPhone: model.paymentProvider.universityPhone,
        additionalInfo: model.paymentProvider.additionalInfo,
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
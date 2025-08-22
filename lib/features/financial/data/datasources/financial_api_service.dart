import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/financial_summary_model.dart';
import '../models/student_fee_model.dart';
import '../models/payment_model.dart';

abstract class FinancialApiService {
  Future<FinancialSummaryModel> getFinancialSummary(String studentId);
  Future<List<StudentFeeModel>> getStudentFees(String studentId);
  Future<List<PaymentProviderModel>> getPaymentProviders();
  Future<List<PaymentModel>> getPayments(String studentId);
  Future<PaymentStatisticsModel> getPaymentStatistics(String studentId);
  Future<PaymentModel> createPayment({
    required String studentId,
    required List<String> feeIds,
    required String paymentProviderId,
    required double amount,
  });
  Future<String> viewReceipt(String paymentId);
  Future<Response> downloadReceipt(String paymentId);
}

class FinancialApiServiceImpl implements FinancialApiService {
  final DioClient _dioClient;

  FinancialApiServiceImpl(this._dioClient);

  @override
  Future<FinancialSummaryModel> getFinancialSummary(String studentId) async {
    final response = await _dioClient.get(
      ApiConstants.financialSummaryEndpoint,
    );
    return FinancialSummaryModel.fromJson(response.data);
  }

  @override
  Future<List<StudentFeeModel>> getStudentFees(String studentId) async {
    final response = await _dioClient.get(
      ApiConstants.studentFeesEndpoint,
    );
    final List<dynamic> data = response.data['results'] ?? response.data;
    return data.map((json) => StudentFeeModel.fromJson(json)).toList();
  }

  @override
  Future<List<PaymentProviderModel>> getPaymentProviders() async {
    final response = await _dioClient.get(
      ApiConstants.paymentProvidersEndpoint,
    );
    final List<dynamic> data = response.data['results'] ?? response.data;
    return data.map((json) => PaymentProviderModel.fromJson(json)).toList();
  }

  @override
  Future<List<PaymentModel>> getPayments(String studentId) async {
    final response = await _dioClient.get(
      ApiConstants.paymentsEndpoint,
    );
    final List<dynamic> data = response.data['results'] ?? response.data;
    return data.map((json) => PaymentModel.fromJson(json)).toList();
  }

  @override
  Future<PaymentStatisticsModel> getPaymentStatistics(String studentId) async {
    final response = await _dioClient.get(
      ApiConstants.paymentStatisticsEndpoint,
    );
    return PaymentStatisticsModel.fromJson(response.data);
  }

  @override
  Future<PaymentModel> createPayment({
    required String studentId,
    required List<String> feeIds,
    required String paymentProviderId,
    required double amount,
  }) async {
    final response = await _dioClient.post(
      ApiConstants.createPaymentEndpoint,
      data: {
        'student_id': studentId,
        'fee_ids': feeIds,
        'payment_provider_id': paymentProviderId,
        'amount': amount,
      },
    );
    return PaymentModel.fromJson(response.data);
  }

  @override
  Future<String> viewReceipt(String paymentId) async {
    final response = await _dioClient.get(
      '${ApiConstants.viewReceiptEndpoint}$paymentId/',
    );
    return response.data['receipt_url'] ?? response.data['url'] ?? '';
  }

  @override
  Future<Response> downloadReceipt(String paymentId) async {
    return await _dioClient.get(
      '${ApiConstants.downloadReceiptEndpoint}$paymentId/',
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
  }
}
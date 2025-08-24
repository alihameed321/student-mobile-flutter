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
    String? transactionReference,
    String? senderName,
    String? senderPhone,
    String? transferNotes,
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
    print('[FinancialApiService] Response status: ${response.statusCode}');
    final List<dynamic> data = response.data['results'] ?? response.data;
    print('[FinancialApiService] Parsing ${data.length} fee items');
    try {
      final fees = data.map((json) => StudentFeeModel.fromJson(json)).toList();
      print('[FinancialApiService] Successfully parsed ${fees.length} fees');
      return fees;
    } catch (e, stackTrace) {
      print('[FinancialApiService] Error parsing fees: $e');
      print('[FinancialApiService] Stack trace: $stackTrace');
      rethrow;
    }
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
    String? transactionReference,
    String? senderName,
    String? senderPhone,
    String? transferNotes,
  }) async {
    final data = {
      'student_id': studentId,
      'fee_ids': feeIds,
      'payment_provider_id': paymentProviderId,
      'amount': amount,
    };
    
    // Add optional parameters if provided
    if (transactionReference != null && transactionReference.isNotEmpty) {
      data['transaction_reference'] = transactionReference;
    }
    if (senderName != null && senderName.isNotEmpty) {
      data['sender_name'] = senderName;
    }
    if (senderPhone != null && senderPhone.isNotEmpty) {
      data['sender_phone'] = senderPhone;
    }
    if (transferNotes != null && transferNotes.isNotEmpty) {
      data['transfer_notes'] = transferNotes;
    }
    
    final response = await _dioClient.post(
      ApiConstants.createPaymentEndpoint,
      data: data,
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
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/financial_summary_model.dart';
import '../models/student_fee_model.dart';
import '../models/payment_model.dart';

abstract class FinancialApiService {
  Future<FinancialSummaryModel> getFinancialSummary(String studentId);
  Future<Map<String, dynamic>> getStudentFees({
    String? status,
    String? feeType,
    bool? outstanding,
    String? semester,
    String? search,
    int page = 1,
    int pageSize = 20,
  });
  Future<List<StudentFeeModel>> getOutstandingFees();
  Future<List<PaymentProviderModel>> getPaymentProviders();
  Future<Map<String, dynamic>> getPayments({int page = 1, int pageSize = 20});
  Future<Map<String, dynamic>> getPaymentStatistics();
  Future<Map<String, dynamic>> createPayment({
    required List<Map<String, dynamic>> fees,
    required String paymentProviderId,
    required double totalAmount,
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
  Future<Map<String, dynamic>> getStudentFees({
    String? status,
    String? feeType,
    bool? outstanding,
    String? semester,
    String? search,
    int page = 1,
    int pageSize = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    
    if (status != null) queryParams['status'] = status;
    if (feeType != null) queryParams['fee_type'] = feeType;
    if (outstanding != null) queryParams['outstanding'] = outstanding;
    if (semester != null) queryParams['semester'] = semester;
    if (search != null) queryParams['search'] = search;
    
    final response = await _dioClient.get(
      ApiConstants.studentFeesEndpoint,
      queryParameters: queryParams,
    );
    
    print('[FinancialApiService] Student fees response: ${response.statusCode}');
    return response.data;
  }

  @override
  Future<List<StudentFeeModel>> getOutstandingFees() async {
    final response = await _dioClient.get(
      '${ApiConstants.studentFeesEndpoint}outstanding/',
    );
    
    final List<dynamic> data = response.data['outstanding_fees'] ?? [];
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
  Future<Map<String, dynamic>> getPayments({int page = 1, int pageSize = 20}) async {
    final response = await _dioClient.get(
      ApiConstants.paymentsEndpoint,
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
    );
    
    print('[FinancialApiService] Payments response: ${response.statusCode}');
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getPaymentStatistics() async {
    final response = await _dioClient.get(
      ApiConstants.paymentStatisticsEndpoint,
    );
    
    print('[FinancialApiService] Payment statistics response: ${response.statusCode}');
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> createPayment({
    required List<Map<String, dynamic>> fees,
    required String paymentProviderId,
    required double totalAmount,
    String? transactionReference,
    String? senderName,
    String? senderPhone,
    String? transferNotes,
  }) async {
    print('=== PAYMENT CREATION DEBUG ===');
    print('Fees: $fees');
    print('Payment Provider ID: $paymentProviderId');
    print('Total Amount: $totalAmount');
    print('Transaction Reference: $transactionReference');
    
    final data = {
      'fees': fees,
      'payment_provider_id': paymentProviderId,
      'total_amount': totalAmount.toStringAsFixed(2),
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
    
    print('Final request data: $data');
    print('Endpoint: ${ApiConstants.createPaymentEndpoint}');
    
    try {
      final response = await _dioClient.post(
        ApiConstants.createPaymentEndpoint,
        data: data,
      );
      print('Payment creation successful: ${response.data}');
      return response.data;
    } catch (e) {
      print('Payment creation failed: $e');
      rethrow;
    }
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
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/service_request_model.dart';
import '../models/student_document_model.dart';
import '../models/support_ticket_model.dart';
import '../models/dashboard_model.dart';

abstract class StudentPortalApiService {
  Future<DashboardStatsModel> getDashboardStats();
  Future<List<ServiceRequestModel>> getServiceRequests({
    String? status,
    String? requestType,
    String? search,
    int? page,
  });
  Future<ServiceRequestModel> getServiceRequestDetail(int id);
  Future<ServiceRequestModel> createServiceRequest(ServiceRequestCreateModel request);
  Future<ServiceRequestModel> cancelServiceRequest(int id);
  Future<List<ServiceRequestTypeModel>> getServiceRequestTypes();
  Future<List<StudentDocumentModel>> getStudentDocuments({
    String? documentType,
    String? search,
    int? page,
  });
  Future<StudentDocumentModel> getStudentDocumentDetail(int id);
  Future<List<SupportTicketModel>> getSupportTickets({
    String? category,
    String? status,
    String? priority,
    String? search,
    int? page,
  });
  Future<SupportTicketModel> getSupportTicketDetail(int id);
  Future<SupportTicketModel> createSupportTicket(SupportTicketCreateModel ticket);
  Future<SupportTicketModel> addTicketResponse(int ticketId, TicketResponseCreateModel response);
  Future<List<TicketCategoryModel>> getTicketCategories();
}

class StudentPortalApiServiceImpl implements StudentPortalApiService {
  final DioClient _dioClient;

  StudentPortalApiServiceImpl(this._dioClient);

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      final response = await _dioClient.get(
        ApiConstants.studentDashboardEndpoint,
      );
      return DashboardStatsModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to fetch dashboard stats: $e');
    }
  }

  @override
  Future<List<ServiceRequestModel>> getServiceRequests({
    String? status,
    String? requestType,
    String? search,
    int? page,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (status != null) queryParameters['status'] = status;
      if (requestType != null) queryParameters['request_type'] = requestType;
      if (search != null) queryParameters['search'] = search;
      if (page != null) queryParameters['page'] = page;

      final response = await _dioClient.get(
        ApiConstants.serviceRequestsEndpoint,
        queryParameters: queryParameters,
      );

      final List<dynamic> results = response.data['results'] ?? response.data;
      return results.map((json) => ServiceRequestModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to fetch service requests: $e');
    }
  }

  @override
  Future<ServiceRequestModel> getServiceRequestDetail(int id) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.getServiceRequestDetailEndpoint(id),
      );
      return ServiceRequestModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to fetch service request detail: $e');
    }
  }

  @override
  Future<ServiceRequestModel> createServiceRequest(ServiceRequestCreateModel request) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.serviceRequestsEndpoint,
        data: request.toJson(),
      );
      return ServiceRequestModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to create service request: $e');
    }
  }

  @override
  Future<ServiceRequestModel> cancelServiceRequest(int id) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.getCancelServiceRequestEndpoint(id),
      );
      return ServiceRequestModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to cancel service request: $e');
    }
  }

  @override
  Future<List<ServiceRequestTypeModel>> getServiceRequestTypes() async {
    try {
      final response = await _dioClient.get(
        ApiConstants.serviceRequestTypesEndpoint,
      );
      final List<dynamic> results = response.data;
      return results.map((json) => ServiceRequestTypeModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to fetch service request types: $e');
    }
  }

  @override
  Future<List<StudentDocumentModel>> getStudentDocuments({
    String? documentType,
    String? search,
    int? page,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (documentType != null) queryParameters['document_type'] = documentType;
      if (search != null) queryParameters['search'] = search;
      if (page != null) queryParameters['page'] = page;

      final response = await _dioClient.get(
        ApiConstants.studentDocumentsEndpoint,
        queryParameters: queryParameters,
      );

      final List<dynamic> results = response.data['results'] ?? response.data;
      return results.map((json) => StudentDocumentModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to fetch student documents: $e');
    }
  }

  @override
  Future<StudentDocumentModel> getStudentDocumentDetail(int id) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.getStudentDocumentDetailEndpoint(id),
      );
      return StudentDocumentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to fetch student document detail: $e');
    }
  }

  @override
  Future<List<SupportTicketModel>> getSupportTickets({
    String? category,
    String? status,
    String? priority,
    String? search,
    int? page,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (category != null) queryParameters['category'] = category;
      if (status != null) queryParameters['status'] = status;
      if (priority != null) queryParameters['priority'] = priority;
      if (search != null) queryParameters['search'] = search;
      if (page != null) queryParameters['page'] = page;

      final response = await _dioClient.get(
        ApiConstants.supportTicketsEndpoint,
        queryParameters: queryParameters,
      );

      final List<dynamic> results = response.data['results'] ?? response.data;
      return results.map((json) => SupportTicketModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to fetch support tickets: $e');
    }
  }

  @override
  Future<SupportTicketModel> getSupportTicketDetail(int id) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.getSupportTicketDetailEndpoint(id),
      );
      return SupportTicketModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to fetch support ticket detail: $e');
    }
  }

  @override
  Future<SupportTicketModel> createSupportTicket(SupportTicketCreateModel ticket) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.supportTicketsEndpoint,
        data: ticket.toJson(),
      );
      return SupportTicketModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to create support ticket: $e');
    }
  }

  @override
  Future<SupportTicketModel> addTicketResponse(int ticketId, TicketResponseCreateModel response) async {
    try {
      final responseData = await _dioClient.post(
        ApiConstants.getAddTicketResponseEndpoint(ticketId),
        data: response.toJson(),
      );
      return SupportTicketModel.fromJson(responseData.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to add ticket response: $e');
    }
  }

  @override
  Future<List<TicketCategoryModel>> getTicketCategories() async {
    try {
      final response = await _dioClient.get(
        ApiConstants.ticketCategoriesEndpoint,
      );
      final List<dynamic> results = response.data;
      return results.map((json) => TicketCategoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to fetch ticket categories: $e');
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? e.response?.data?['detail'] ?? 'Unknown error';
        switch (statusCode) {
          case 400:
            return Exception('Bad request: $message');
          case 401:
            return Exception('Unauthorized. Please login again.');
          case 403:
            return Exception('Access forbidden: $message');
          case 404:
            return Exception('Resource not found: $message');
          case 500:
            return Exception('Server error. Please try again later.');
          default:
            return Exception('Request failed: $message');
        }
      case DioExceptionType.cancel:
        return Exception('Request was cancelled');
      case DioExceptionType.connectionError:
        return Exception('No internet connection');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}
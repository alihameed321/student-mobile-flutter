import '../../domain/entities/service_request.dart';
import '../../domain/entities/student_document.dart';
import '../../domain/entities/support_ticket.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/repositories/student_portal_repository.dart';
import '../datasources/student_portal_api_service.dart';
import '../models/service_request_model.dart';
import '../models/support_ticket_model.dart';

class StudentPortalRepositoryImpl implements StudentPortalRepository {
  final StudentPortalApiService _apiService;

  StudentPortalRepositoryImpl(this._apiService);

  @override
  Future<DashboardStats> getDashboardStats() async {
    try {
      return await _apiService.getDashboardStats();
    } catch (e) {
      throw Exception('Failed to get dashboard stats: $e');
    }
  }

  @override
  Future<List<ServiceRequest>> getServiceRequests({
    String? status,
    String? requestType,
    String? search,
    int? page,
  }) async {
    try {
      final serviceRequests = await _apiService.getServiceRequests(
        status: status,
        requestType: requestType,
        search: search,
        page: page,
      );
      return serviceRequests.cast<ServiceRequest>();
    } catch (e) {
      throw Exception('Failed to get service requests: $e');
    }
  }

  @override
  Future<ServiceRequest> getServiceRequestDetail(int id) async {
    try {
      return await _apiService.getServiceRequestDetail(id);
    } catch (e) {
      throw Exception('Failed to get service request detail: $e');
    }
  }

  @override
  Future<ServiceRequest> createServiceRequest({
    required String requestType,
    required String description,
    String? priority,
  }) async {
    try {
      final createModel = ServiceRequestCreateModel(
        requestType: requestType,
        description: description,
        priority: priority,
      );
      return await _apiService.createServiceRequest(createModel);
    } catch (e) {
      throw Exception('Failed to create service request: $e');
    }
  }

  @override
  Future<ServiceRequest> cancelServiceRequest(int id) async {
    try {
      return await _apiService.cancelServiceRequest(id);
    } catch (e) {
      throw Exception('Failed to cancel service request: $e');
    }
  }

  @override
  Future<List<String>> getServiceRequestTypes() async {
    try {
      final types = await _apiService.getServiceRequestTypes();
      return types.where((type) => type.isActive).map((type) => type.name).toList();
    } catch (e) {
      throw Exception('Failed to get service request types: $e');
    }
  }

  @override
  Future<List<StudentDocument>> getStudentDocuments({
    String? documentType,
    String? search,
    int? page,
  }) async {
    try {
      final documents = await _apiService.getStudentDocuments(
        documentType: documentType,
        search: search,
        page: page,
      );
      return documents.cast<StudentDocument>();
    } catch (e) {
      throw Exception('Failed to get student documents: $e');
    }
  }

  @override
  Future<StudentDocument> getStudentDocumentDetail(int id) async {
    try {
      return await _apiService.getStudentDocumentDetail(id);
    } catch (e) {
      throw Exception('Failed to get student document detail: $e');
    }
  }

  @override
  Future<List<SupportTicket>> getSupportTickets({
    String? category,
    String? status,
    String? priority,
    String? search,
    int? page,
  }) async {
    try {
      final tickets = await _apiService.getSupportTickets(
        category: category,
        status: status,
        priority: priority,
        search: search,
        page: page,
      );
      return tickets.cast<SupportTicket>();
    } catch (e) {
      throw Exception('Failed to get support tickets: $e');
    }
  }

  @override
  Future<SupportTicket> getSupportTicketDetail(int id) async {
    try {
      return await _apiService.getSupportTicketDetail(id);
    } catch (e) {
      throw Exception('Failed to get support ticket detail: $e');
    }
  }

  @override
  Future<SupportTicket> createSupportTicket({
    required String subject,
    required String description,
    required String category,
    required String priority,
  }) async {
    try {
      final createModel = SupportTicketCreateModel(
        subject: subject,
        description: description,
        category: category,
        priority: priority,
      );
      return await _apiService.createSupportTicket(createModel);
    } catch (e) {
      throw Exception('Failed to create support ticket: $e');
    }
  }

  @override
  Future<SupportTicket> addTicketResponse(int ticketId, String message) async {
    try {
      final responseModel = TicketResponseCreateModel(message: message);
      return await _apiService.addTicketResponse(ticketId, responseModel);
    } catch (e) {
      throw Exception('Failed to add ticket response: $e');
    }
  }

  @override
  Future<List<String>> getTicketCategories() async {
    try {
      final categories = await _apiService.getTicketCategories();
      return categories.where((category) => category.isActive).map((category) => category.name).toList();
    } catch (e) {
      throw Exception('Failed to get ticket categories: $e');
    }
  }
}
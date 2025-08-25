import '../entities/service_request.dart';
import '../entities/student_document.dart';
import '../entities/support_ticket.dart';
import '../entities/dashboard_stats.dart';
import '../../data/models/service_request_model.dart';
import '../../data/models/support_ticket_model.dart';

abstract class StudentPortalRepository {
  Future<DashboardStats> getDashboardStats();
  
  // Service Requests
  Future<List<ServiceRequest>> getServiceRequests({
    String? status,
    String? requestType,
    String? search,
    int? page,
  });
  Future<ServiceRequest> getServiceRequestDetail(int id);
  Future<ServiceRequest> createServiceRequest({
    required String requestType,
    required String title,
    required String description,
    String? priority,
  });
  Future<ServiceRequest> cancelServiceRequest(int id);
  Future<List<String>> getServiceRequestTypes();
  
  // Student Documents
  Future<List<StudentDocument>> getStudentDocuments({
    String? documentType,
    String? search,
    int? page,
  });
  Future<StudentDocument> getStudentDocumentDetail(int id);
  
  // Support Tickets
  Future<List<SupportTicket>> getSupportTickets({
    String? category,
    String? status,
    String? priority,
    String? search,
    int? page,
  });
  Future<SupportTicket> getSupportTicketDetail(int id);
  Future<SupportTicket> createSupportTicket({
    required String subject,
    required String description,
    required String category,
    required String priority,
  });
  Future<SupportTicket> addTicketResponse(int ticketId, String message);
  Future<List<String>> getTicketCategories();
}
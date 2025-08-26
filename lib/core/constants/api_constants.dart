class ApiConstants {
  // Base URL for the API
  static const String baseUrl = 'http://192.168.8.120:8000';

  // API Endpoints
  static const String loginEndpoint = '/api/auth/login/';
  static const String logoutEndpoint = '/api/auth/logout/';
  static const String refreshTokenEndpoint = '/api/auth/refresh/';
  static const String userProfileEndpoint = '/api/auth/profile/';

  // Student Portal API endpoints
  static const String studentDashboardEndpoint = '/api/student/dashboard/';
  static const String serviceRequestsEndpoint =
      '/api/student/service-requests/';
  static const String serviceRequestTypesEndpoint =
      '/api/student/service-request-types/';
  static const String studentDocumentsEndpoint = '/api/student/documents/';
  static const String supportTicketsEndpoint = '/api/student/support-tickets/';
  static const String ticketCategoriesEndpoint =
      '/api/student/ticket-categories/';

  // Legacy services endpoints (keep for backward compatibility)
  static const String servicesEndpoint = '/api/services/';

  // Documents endpoints (legacy)
  static const String documentsEndpoint = '/api/documents/';

  // Enhanced Document Management API endpoints
  static const String documentTypesEndpoint = '/api/student/document-types/';
  static const String documentStatisticsEndpoint = '/api/student/documents/statistics/';
  static const String documentStatusEndpoint = '/api/student/documents/status/';
  static const String documentSearchEndpoint = '/api/student/documents/search/';
  static const String documentSharingEndpoint = '/api/student/documents/sharing/';

  // Student-specific document endpoints
  static String getStudentDocumentDetailEndpoint(int id) =>
      '/api/student/documents/$id/';
  static String getStudentDocumentDownloadEndpoint(int id) =>
      '/api/student/documents/$id/download/';
  static String getDocumentStatusEndpoint(int id) =>
      '/api/student/documents/$id/status/';
  static String getServiceRequestDetailEndpoint(int id) =>
      '/api/student/service-requests/$id/';
  static String getCancelServiceRequestEndpoint(int id) =>
      '/api/student/service-requests/$id/cancel/';
  static String getSupportTicketDetailEndpoint(int id) =>
      '/api/student/support-tickets/$id/';
  static String getAddTicketResponseEndpoint(int id) =>
      '/api/student/support-tickets/$id/respond/';

  // Notifications endpoints
  static const String notificationsEndpoint = '/api/notifications/';

  // Financial endpoints
  static const String financialSummaryEndpoint = '/api/financial/summary/';
  static const String studentFeesEndpoint = '/api/financial/fees/';
  static const String paymentProvidersEndpoint =
      '/api/financial/payment-providers/';
  static const String paymentsEndpoint = '/api/financial/payments/';
  static const String paymentStatisticsEndpoint =
      '/api/financial/payments/statistics/';
  static const String createPaymentEndpoint = '/api/financial/payments/create/';
  static const String viewReceiptEndpoint = '/api/financial/receipts/';
  static const String downloadReceiptEndpoint = '/api/financial/receipts/';

  // Request timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

class ApiConstants {
  // Base URL for the API
  static const String baseUrl = 'http://192.168.8.120:8000';
  
  // API Endpoints
  static const String loginEndpoint = '/api/auth/login/';
  static const String logoutEndpoint = '/api/auth/logout/';
  static const String refreshTokenEndpoint = '/api/auth/refresh/';
  static const String userProfileEndpoint = '/api/auth/profile/';
  
  // Services endpoints
  static const String servicesEndpoint = '/api/services/';
  static const String serviceRequestsEndpoint = '/api/service-requests/';
  
  // Documents endpoints
  static const String documentsEndpoint = '/api/documents/';
  
  // Notifications endpoints
  static const String notificationsEndpoint = '/api/notifications/';
  
  // Financial endpoints
  static const String financialSummaryEndpoint = '/api/financial/summary/';
  static const String studentFeesEndpoint = '/api/financial/fees/';
  static const String paymentProvidersEndpoint = '/api/financial/payment-providers/';
  static const String paymentsEndpoint = '/api/financial/payments/';
  static const String paymentStatisticsEndpoint = '/api/financial/payments/statistics/';
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
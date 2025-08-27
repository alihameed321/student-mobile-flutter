class AppConstants {
  // App Information
  static const String appName = 'خدمات الطلاب';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  
  // Default Values
  static const String defaultLanguage = 'en';
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx', 'txt'];
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);
}
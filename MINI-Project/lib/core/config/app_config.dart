class AppConfig {
  static const String appName = 'Attendance Pro';
  static const String packageName = 'com.example.attendance_app';
  static const String iosAppId = 'com.example.attendanceApp';

  // API Configuration
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // Cache Configuration
  static const Duration cacheExpiry = Duration(hours: 24);
  static const int maxCacheSize = 50 * 1024 * 1024; // 50MB

  // UI Configuration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const int itemsPerPage = 20;

  // Notification Configuration
  static const int notificationBeforeClass = 10; // minutes
  static const int maxNotifications = 50;

  // File Upload Configuration
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedFileTypes = ['jpg', 'jpeg', 'png', 'pdf'];

  // Security Configuration
  static const int sessionTimeout = 30; // minutes
  static const int passwordMinLength = 6;
  static const int otpLength = 6;
  static const Duration otpExpiry = Duration(minutes: 5);
}

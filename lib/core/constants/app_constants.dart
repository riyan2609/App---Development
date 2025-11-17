import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Attendance Pro';
  static const String appVersion = '1.0.0';

  // Colors
  static const Color primaryColor = Color(0xFF6C5CE7);
  static const Color secondaryColor = Color(0xFF00D2D3);
  static const Color accentColor = Color(0xFFFF6B6B);
  static const Color successColor = Color(0xFF00B894);
  static const Color warningColor = Color(0xFFFDCB6E);
  static const Color errorColor = Color(0xFFD63031);
  static const Color darkBg = Color(0xFF1A1A2E);
  static const Color lightBg = Color(0xFFF5F5F5);

  // VIP Colors
  static const Color vipGold = Color(0xFFFFD700);
  static const Color vipGradientStart = Color(0xFFFFD700);
  static const Color vipGradientEnd = Color(0xFFFFA500);

  // Attendance Status Colors
  static const Color presentColor = Color(0xFF00B894);
  static const Color absentColor = Color(0xFFD63031);
  static const Color lateColor = Color(0xFFFDCB6E);

  // User Roles
  static const String roleStudent = 'student';
  static const String roleTeacher = 'teacher';
  static const String roleAdmin = 'admin';
  static const String roleGuest = 'guest';

  // Attendance Status
  static const String statusPresent = 'present';
  static const String statusAbsent = 'absent';
  static const String statusLate = 'late';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String studentsCollection = 'students';
  static const String teachersCollection = 'teachers';
  static const String attendanceCollection = 'attendance';
  static const String timetableCollection = 'timetable';
  static const String classesCollection = 'classes';
  static const String subjectsCollection = 'subjects';
  static const String departmentsCollection = 'departments';
  static const String announcementsCollection = 'announcements';
  static const String vipSubscriptionsCollection = 'vip_subscriptions';

  // Shared Preferences Keys
  static const String keyUserId = 'user_id';
  static const String keyUserRole = 'user_role';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyIsVip = 'is_vip';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';

  // VIP Pricing
  static const double vipMonthlyPrice = 99.0;
  static const double vipYearlyPrice = 999.0;

  // Attendance Thresholds
  static const double attendanceWarningThreshold = 75.0;
  static const double attendanceDangerThreshold = 65.0;

  // API Endpoints (if using REST API)
  static const String baseUrl = 'https://your-api.com/api/v1';

  // Time Formats
  static const String dateFormat = 'dd MMM yyyy';
  static const String timeFormat = 'hh:mm a';
  static const String dateTimeFormat = 'dd MMM yyyy, hh:mm a';

  // Pagination
  static const int pageSize = 20;

  // Notification Channels
  static const String attendanceChannelId = 'attendance_channel';
  static const String announcementChannelId = 'announcement_channel';
  static const String reminderChannelId = 'reminder_channel';

  // Assets
  static const String logoPath = 'assets/images/logo.png';
  static const String splashAnimation = 'assets/animations/splash.json';
  static const String emptyStateAnimation = 'assets/animations/empty.json';
  static const String loadingAnimation = 'assets/animations/loading.json';

  // Regex Patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phonePattern = r'^[0-9]{10}$';

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork =
      'No internet connection. Please check your network.';
  static const String errorAuth = 'Authentication failed. Please try again.';
  static const String errorPermission =
      'Permission denied. Please grant necessary permissions.';
}

class AppStrings {
  // Auth
  static const String login = 'Login';
  static const String signup = 'Sign Up';
  static const String logout = 'Logout';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String phone = 'Phone Number';
  static const String otp = 'OTP';
  static const String verifyOtp = 'Verify OTP';
  static const String continueAsGuest = 'Continue as Guest';

  // Dashboard
  static const String dashboard = 'Dashboard';
  static const String todayAttendance = "Today's Attendance";
  static const String monthlyAttendance = 'Monthly Attendance';
  static const String totalLectures = 'Total Lectures';
  static const String upcomingLectures = 'Upcoming Lectures';

  // Attendance
  static const String attendance = 'Attendance';
  static const String markAttendance = 'Mark Attendance';
  static const String viewAttendance = 'View Attendance';
  static const String present = 'Present';
  static const String absent = 'Absent';
  static const String late = 'Late';

  // Timetable
  static const String timetable = 'Timetable';
  static const String schedule = 'Schedule';
  static const String noClassesToday = 'No classes today';

  // VIP
  static const String vip = 'VIP';
  static const String upgradeToVip = 'Upgrade to VIP';
  static const String vipFeatures = 'VIP Features';
  static const String subscribeNow = 'Subscribe Now';

  // Profile
  static const String profile = 'Profile';
  static const String editProfile = 'Edit Profile';
  static const String settings = 'Settings';

  // Common
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String refresh = 'Refresh';
  static const String submit = 'Submit';
  static const String loading = 'Loading...';
  static const String noData = 'No data available';
  static const String error = 'Error';
  static const String success = 'Success';
}

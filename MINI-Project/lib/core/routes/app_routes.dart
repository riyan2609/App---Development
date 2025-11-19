import 'package:get/get.dart';
import '../../screens/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/phone_auth_screen.dart';
import '../../screens/student/student_dashboard.dart';
import '../../screens/student/attendance_screen.dart';
import '../../screens/student/timetable_screen.dart';
import '../../screens/student/profile_screen.dart';
import '../../screens/teacher/teacher_dashboard.dart';
import '../../screens/teacher/mark_attendance_screen.dart';
import '../../screens/teacher/class_reports_screen.dart';
import '../../screens/teacher/announcements_screen.dart';
import '../../screens/admin/admin_dashboard.dart';
import '../../screens/admin/user_management_screen.dart';
import '../../screens/admin/class_management_screen.dart';
import '../../screens/vip/vip_screen.dart';
import '../../screens/guest/guest_dashboard.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String phoneAuth = '/phone-auth';

  // Student
  static const String studentDashboard = '/student/dashboard';
  static const String attendance = '/student/attendance';
  static const String timetable = '/student/timetable';
  static const String profile = '/student/profile';

  // Teacher
  static const String teacherDashboard = '/teacher/dashboard';
  static const String markAttendance = '/teacher/mark-attendance';
  static const String classReports = '/teacher/reports';
  static const String announcements = '/teacher/announcements';

  // Admin
  static const String adminDashboard = '/admin/dashboard';
  static const String userManagement = '/admin/users';
  static const String classManagement = '/admin/classes';

  // VIP
  static const String vip = '/vip';

  // Guest
  static const String guestDashboard = '/guest/dashboard';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: signup, page: () => const SignupScreen()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: phoneAuth, page: () => const PhoneAuthScreen()),

    // Student
    GetPage(name: studentDashboard, page: () => const StudentDashboard()),
    GetPage(name: attendance, page: () => const AttendanceScreen()),
    GetPage(name: timetable, page: () => const TimetableScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),

    // Teacher
    GetPage(name: teacherDashboard, page: () => const TeacherDashboard()),
    GetPage(name: markAttendance, page: () => const MarkAttendanceScreen()),
    GetPage(name: classReports, page: () => const ClassReportsScreen()),
    GetPage(name: announcements, page: () => const AnnouncementsScreen()),

    // Admin
    GetPage(name: adminDashboard, page: () => const AdminDashboard()),
    GetPage(name: userManagement, page: () => const UserManagementScreen()),
    GetPage(name: classManagement, page: () => const ClassManagementScreen()),

    // VIP
    GetPage(name: vip, page: () => const VipScreen()),

    // Guest
    GetPage(name: guestDashboard, page: () => const GuestDashboard()),
  ];
}

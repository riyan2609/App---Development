import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/storage_service.dart';
import '../constants/app_constants.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Check if user is logged in
    bool isLoggedIn =
        StorageService.getBool(AppConstants.keyIsLoggedIn) ?? false;

    if (!isLoggedIn && route != AppRoutes.login && route != AppRoutes.signup) {
      return const RouteSettings(name: AppRoutes.login);
    }

    return null;
  }
}

class GuestMiddleware extends GetMiddleware {
  @override
  int? get priority => 2;

  @override
  RouteSettings? redirect(String? route) {
    String? userRole = StorageService.getString(AppConstants.keyUserRole);

    if (userRole == AppConstants.roleGuest) {
      // Restrict certain routes for guest users
      List<String> restrictedRoutes = [
        AppRoutes.markAttendance,
        AppRoutes.classReports,
        AppRoutes.announcements,
        AppRoutes.adminDashboard,
      ];

      if (restrictedRoutes.contains(route)) {
        return const RouteSettings(name: AppRoutes.login);
      }
    }

    return null;
  }
}

class RoleMiddleware extends GetMiddleware {
  final List<String> allowedRoles;

  RoleMiddleware({required this.allowedRoles});

  @override
  int? get priority => 3;

  @override
  RouteSettings? redirect(String? route) {
    String? userRole = StorageService.getString(AppConstants.keyUserRole);

    if (userRole != null && !allowedRoles.contains(userRole)) {
      // Redirect to appropriate dashboard based on role
      switch (userRole) {
        case AppConstants.roleStudent:
          return const RouteSettings(name: AppRoutes.studentDashboard);
        case AppConstants.roleTeacher:
          return const RouteSettings(name: AppRoutes.teacherDashboard);
        case AppConstants.roleAdmin:
          return const RouteSettings(name: AppRoutes.adminDashboard);
        case AppConstants.roleGuest:
          return const RouteSettings(name: AppRoutes.guestDashboard);
        default:
          return const RouteSettings(name: AppRoutes.login);
      }
    }

    return null;
  }
}

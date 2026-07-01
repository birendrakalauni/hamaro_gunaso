import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/user/user_dashboard_screen.dart';
import '../screens/user/add_complaint_screen.dart';
import '../screens/user/complaint_list_screen.dart';
import '../screens/user/complaint_details_screen.dart';
import '../screens/user/profile_screen.dart';
import '../screens/home/home_screen.dart';

class AppRoutes {
  // Route Names
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String addComplaint = '/addComplaint';
  static const String complaints = '/complaints';
  static const String complaintDetails = '/complaintDetails';
  static const String profile = '/profile';
  static const home = '/';

  // Routes Map
  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    forgotPassword: (_) => const ForgotPasswordScreen(),
    dashboard: (_) => const UserDashboardScreen(),
    addComplaint: (_) => const AddComplaintScreen(),
    complaints: (_) => const ComplaintListScreen(),
    profile: (_) => const ProfileScreen(),
    home: (_) => const HomeScreen(),
  };
}

import 'package:flutter/material.dart';

import '../ui/auth/login_page.dart';
import '../ui/auth/register_doctor_page.dart';
import '../ui/auth/otp_page.dart';
import '../ui/common/splash_page.dart';
import '../ui/dashboard/admin/admin_dashboard_page.dart';
import '../ui/dashboard/doctor/doctor_dashboard_page.dart';
import '../ui/patient/patient_history_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String registerDoctor = '/registerDoctor';
  static const String otp = '/otp';
  static const String doctorDashboard = '/doctorDashboard';
  static const String adminDashboard = '/adminDashboard';
  static const String patientHistory = '/patientHistory';
}

class AppRouter {
  static Map<String, WidgetBuilder> get routes => {
        AppRoutes.splash: (context) => const SplashPage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.registerDoctor: (context) => const RegisterDoctorPage(),
        AppRoutes.otp: (context) => const OtpPage(),
        AppRoutes.doctorDashboard: (context) => const DoctorDashboardPage(),
        AppRoutes.adminDashboard: (context) => const AdminDashboardPage(),
        AppRoutes.patientHistory: (context) => const PatientHistoryPage(),
      };
}



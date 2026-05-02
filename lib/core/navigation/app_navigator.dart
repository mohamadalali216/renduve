import 'package:flutter/material.dart';
import 'package:randevu_app/presentation/routes/app_routes.dart';

/// Navigation Service Layer - Decouples navigation from UI and Bloc
/// Solves issue: Navigation inside BlocListener tight coupling
class AppNavigator {
  final BuildContext context;
  
  AppNavigator(this.context);
  
  /// Navigate to appointment confirmation screen
  Future<dynamic> toAppointmentConfirmation({
    required int doctorId,
    required int patientId,
    required String date,
    required String time,
    String? notes,
  }) {
    return Navigator.pushNamed(
      context,
      AppRoutes.fAppointment,
      arguments: {
        'doctorId': doctorId,
        'patientId': patientId,
        'date': date,
        'time': time,
        'notes': notes,
      },
    );
  }
  
  /// Navigate to appointment booking screen
  Future<dynamic> toAppointmentBooking() {
    return Navigator.pushNamed(
      context,
      AppRoutes.appointmenttake,
    );
  }
  
  /// Replace current with appointment booking
  void replaceWithBooking(int doctorId) {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.appointmenttake,
      arguments: doctorId,
    );
  }
  
  /// Navigate to new patient registration
  Future<dynamic> toNewPatient(int doctorId) {
    return Navigator.pushNamed(
      context,
      AppRoutes.newPaitent,
      arguments: doctorId,
    );
  }
  
  /// Navigate to patient search
  Future<dynamic> toPatientSearch() {
    return Navigator.pushNamed(
      context,
      AppRoutes.searchresult,
    );
  }
  
  /// Navigate to appointment list
  Future<dynamic> toAppointmentList() {
    return Navigator.pushNamed(
      context,
      AppRoutes.appointmentlist,
    );
  }
  
  /// Navigate to home screen
  void popToHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
  
  /// Pop current screen
  void pop<T>([T? result]) {
    Navigator.pop(context, result);
  }
}

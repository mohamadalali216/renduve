import 'package:randevu_app/data/models/appointment_model.dart';

class AppointmentState {
  final int? doctorId;
  final int? patientId;
  final bool isLoading;
  final bool isSuccess;
  final bool isGetLoading;
  final String? error;
  final List<AppointmentModel> appointments;
  final bool isValid;
  final String? validationError;
  final DateTime? selectedDate;

  const AppointmentState({
    this.doctorId,
    this.patientId,
    this.isLoading = false,
    this.isSuccess = false,
    this.isGetLoading = false,
    this.error,
    this.appointments = const [],
    this.isValid = false,
    this.validationError,
    this.selectedDate,
  });

AppointmentState copyWith({
    int? doctorId,
    int? patientId,
    bool? isLoading,
    bool? isSuccess,
    bool? isGetLoading,
    String? error,
    List<AppointmentModel>? appointments,
    bool? isValid,
    String? validationError,
    DateTime? selectedDate,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AppointmentState(
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: clearSuccess ? false : (isSuccess ?? this.isSuccess),
      isGetLoading: isGetLoading ?? this.isGetLoading,
      error: clearError ? null : error ?? this.error,
      appointments: appointments ?? this.appointments,
      isValid: isValid ?? ((doctorId ?? this.doctorId) != null && (patientId ?? this.patientId) != null),
      validationError: validationError,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
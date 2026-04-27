import 'package:equatable/equatable.dart';
import 'package:randevu_app/data/models/paitent_model.dart';

abstract class PatientState {
  const PatientState();
}

/// Search states
class SearchPatientLoading extends PatientState {}
class SearchPatientSuccess extends PatientState {
  final List<PatientModel> patients;  // PatientModel list
  const SearchPatientSuccess(this.patients);

  @override
  List<Object?> get props => [patients];
}
class SearchPatientFailure extends PatientState {
  final String message;
  SearchPatientFailure(this.message);
}
class SearchPatientNoResults extends PatientState {
  final String message;
  SearchPatientNoResults(this.message);
}

class PatientInitial extends PatientState {}

class PatientLoading extends PatientState {}

class PatientSuccess extends PatientState {
  final int patientId;

  PatientSuccess({required this.patientId});

  @override
  List<Object?> get props => [patientId];
}

class PatientFailure extends PatientState {
  final String message;
PatientFailure(this.message);
}

class PatientCleared extends PatientState {}

/// Diagnosis Save States
class DiagnosisSaving extends PatientState {}
class DiagnosisSaved extends PatientState {
  final String message;
  DiagnosisSaved(this.message);
}
class DiagnosisSaveError extends PatientState {
  final String message;
  const DiagnosisSaveError(this.message);
}

/// Session Save States
class SessionSaving extends PatientState {}
class SessionSaved extends PatientState {
  final String message;
  SessionSaved(this.message);
}
class SessionSaveError extends PatientState {
  final String message;
  const SessionSaveError(this.message);
}

class ComplaintsUpdated extends PatientState with EquatableMixin {
  final List<String> complaints;
  const ComplaintsUpdated(this.complaints);

  @override
  List<Object?> get props => [complaints];
}

class MedicationsUpdated extends PatientState with EquatableMixin {
  final List<Map<String, String>> medications;
  const MedicationsUpdated(this.medications);

  @override
  List<Object?> get props => [medications];
}

class DiagnosisUpdated extends PatientState with EquatableMixin {
  final String diagnosis;
  const DiagnosisUpdated(this.diagnosis);

  @override
  List<Object?> get props => [diagnosis];
}

class SessionTimerUpdated extends PatientState with EquatableMixin {
  final String formattedTime;
  const SessionTimerUpdated(this.formattedTime);

  @override
  List<Object?> get props => [formattedTime];
}

class SessionTimerStopped extends PatientState with EquatableMixin {
  final String finalTime;
  const SessionTimerStopped(this.finalTime);

  @override
  List<Object?> get props => [finalTime];
}

/// Patient Appointments States
class PatientAppointmentsLoading extends PatientState {}

class PatientAppointmentsLoaded extends PatientState with EquatableMixin {
  final List<dynamic> appointments; // AppointmentModel list
  const PatientAppointmentsLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

class PatientAppointmentsError extends PatientState {
  final String message;
  const PatientAppointmentsError(this.message);
}

/// Patient Last Review States
class PatientLastReviewLoading extends PatientState {}


class PatientLastReviewError extends PatientState {
  final String message;
  const PatientLastReviewError(this.message);
}

/// NEW: States for specific complaint details (reviews navigation)
class ComplaintDetailsLoading extends PatientState {}



class ComplaintDetailsError extends PatientState {
  final String message;
const ComplaintDetailsError(this.message);
}

/// NEW: States for Patient Complaints (fixes stuck loading issue)
class ComplaintsLoading extends PatientState {}



class ComplaintsError extends PatientState {
  final String message;

  const ComplaintsError(this.message);
}

class PatientBasicInfoLoaded extends PatientState {
  final PatientModel patient;
  PatientBasicInfoLoaded(this.patient);
}



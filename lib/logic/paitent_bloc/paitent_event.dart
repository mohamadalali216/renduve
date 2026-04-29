import 'package:equatable/equatable.dart';

abstract class PatientEvent {
  const PatientEvent();
}


class SearchPatientEvent extends PatientEvent {
  final String query;

  SearchPatientEvent(this.query);
}

class AddPatientEvent extends PatientEvent {
  final String name;
  final String? phone;
  final String? city;
  final String? address;
  final int? age;
  final String? idNumber;
  final String? gender;

AddPatientEvent({
    required this.name,
    this.phone,
    this.city,
    this.address,
    this.age,
    this.idNumber,
    this.gender,
  });
}

class ClearPatientFieldsEvent extends PatientEvent {}

class SaveDiagnosisEvent extends PatientEvent {
  final String description;
  final int patientId;
  final int doctorId;
  final int examId;

  SaveDiagnosisEvent({
    required this.description,
    required this.patientId,
    required this.doctorId,
    this.examId = 0,
  });
}

class SaveMedicalSessionEvent extends PatientEvent with EquatableMixin {
  final int patientId;
  final int appointmentId;
  final List<String> complaints;
  final String diagnosisDescription;
  final List<Map<String, String>> medications;

  const SaveMedicalSessionEvent({
    required this.patientId,
    required this.appointmentId,
    required this.complaints,
    required this.diagnosisDescription,
    required this.medications,
  });

  @override
  List<Object?> get props => [patientId, appointmentId, complaints, diagnosisDescription, medications];
}

class AddComplaintEvent extends PatientEvent with EquatableMixin {
  final String complaint;

  const AddComplaintEvent(this.complaint);

  @override
  List<Object?> get props => [complaint];
}

class DeleteComplaintEvent extends PatientEvent with EquatableMixin {
  final int index;

  const DeleteComplaintEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class AddMedicationEvent extends PatientEvent with EquatableMixin {
  final Map<String, String> medication;

  const AddMedicationEvent(this.medication);

  @override
  List<Object?> get props => [medication];
}

class DeleteMedicationEvent extends PatientEvent with EquatableMixin {
  final int index;

  const DeleteMedicationEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class UpdateDiagnosisEvent extends PatientEvent with EquatableMixin {
  final String diagnosis;

  const UpdateDiagnosisEvent(this.diagnosis);

  @override
  List<Object?> get props => [diagnosis];
}

class StartSessionTimerEvent extends PatientEvent {}

class StopSessionTimerEvent extends PatientEvent {}

class TickSessionTimerEvent extends PatientEvent {}

class GetPatientAppointmentsEvent extends PatientEvent {
  final int patientId;
  const GetPatientAppointmentsEvent(this.patientId);
}

// NEW - Step 3: Get Patient Complaints Event (for reviews loading)
class GetPatientComplaintsEvent extends PatientEvent with EquatableMixin {
  final int patientId;
  const GetPatientComplaintsEvent(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

// NEW - Dynamic Last Review Event
class GetPatientLastReviewEvent extends PatientEvent with EquatableMixin {
  final int patientId;
  const GetPatientLastReviewEvent(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

// NEW: Event for loading specific complaint details (reviews navigation)
class GetComplaintDetailsEvent extends PatientEvent with EquatableMixin {
  final int complaintId;
  const GetComplaintDetailsEvent(this.complaintId);

  @override
  List<Object?> get props => [complaintId];
}

// NEW: Direct examId review (for list navigation)
class GetReviewByExamIdEvent extends PatientEvent with EquatableMixin {
  final int examId;
  const GetReviewByExamIdEvent(this.examId);

  @override
  List<Object?> get props => [examId];
}

class GetPatientBasicInfoEvent extends PatientEvent {
  final int patientId;
  GetPatientBasicInfoEvent(this.patientId);
}

/// Event to reload the last search results (used when returning from appointment screens)
class ReloadLastSearchEvent extends PatientEvent {}


abstract class AppointmentEvent {}

class AddAppointmentEvent extends AppointmentEvent {
  final String date;
  final String time;
  final String? notes;
  final int doctorId;
  final int patientId;

  AddAppointmentEvent({
    required this.date,
    required this.time,
    this.notes,
    required this.doctorId,
    required this.patientId,
  });
}

/// Event to clear the created appointment event after navigation is complete
/// This prevents state replay when returning to the screen
class ClearAppointmentCreatedEvent extends AppointmentEvent {}

class ClearAppointmentFieldsEvent extends AppointmentEvent {}

class GetAppointmentsEvent extends AppointmentEvent {
  final int doctorId;
  GetAppointmentsEvent(this.doctorId);
}
class SetDoctorEvent extends AppointmentEvent {
  final int doctorId;
  SetDoctorEvent(this.doctorId);
}
class SetPatientEvent extends AppointmentEvent {
  final int patientId;
SetPatientEvent(this.patientId  );
}

class ValidateSelectionEvent extends AppointmentEvent {}

class PreviousDayEvent extends AppointmentEvent {}

class NextDayEvent extends AppointmentEvent {}
class DeleteAppointmentEvent extends AppointmentEvent {
  final int appointmentId;
  
  DeleteAppointmentEvent(this.appointmentId);
}


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randevu_app/data/models/appointment_model.dart';
import 'package:randevu_app/data/repository/appointment_repository.dart';
import 'package:randevu_app/logic/appointment_bloc/appointment_event.dart';
import 'package:randevu_app/logic/appointment_bloc/appointment_state.dart';

/// Manages appointment creation, fetching, and session state for doctor/patient selection.
class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository appointmentRepository;



AppointmentBloc(this.appointmentRepository)
      : super(const AppointmentState()) {
    on<AddAppointmentEvent>(_onAddAppointment);
    on<ClearAppointmentFieldsEvent>(_onClearFields);
    on<GetAppointmentsEvent>(_onGetAppointments);
    on<SetDoctorEvent>(_onSetDoctor);
    on<SetPatientEvent>(_onSetPatient);
    on<ValidateSelectionEvent>(_onValidateSelection);
    on<PreviousDayEvent>(_onPreviousDay);
    on<NextDayEvent>(_onNextDay);
     on<DeleteAppointmentEvent>(_onDeleteAppointment); 

    // 🔍 DEBUG state changes
    @override
    void onChange(Change<AppointmentState> change) {
      super.onChange(change);
      print("📊 APPOINTMENT BLOC: loading=${change.nextState.isGetLoading} error=${change.nextState.error} count=${change.nextState.appointments.length}");
    }
      }
  /// Set selected doctor ID, preserve patient ID
  void _onSetDoctor(SetDoctorEvent event, Emitter<AppointmentState> emit) {
    if (event.doctorId < 1) {
      emit(state.copyWith(validationError: 'Invalid doctor ID'));
      return;
    }
    print("🔥 DOCTOR SET: ${event.doctorId}");

    final newState = state.copyWith(doctorId: event.doctorId);
    print("STATE DOCTOR AFTER: ${newState.doctorId}");

    emit(newState);
  }

  /// Set selected patient ID, preserve doctor ID
  void _onSetPatient(SetPatientEvent event, Emitter<AppointmentState> emit) {
  if (state.doctorId == null) {
    emit(state.copyWith(
      validationError: 'Doctor must be selected first',
    ));
    return;
  }
  if (event.patientId < 1) {
    emit(state.copyWith(
      validationError: 'Invalid patient ID',
    ));
    return;
  }
  print("🔥 PATIENT SET: ${event.patientId}");

  final newState = state.copyWith(patientId: event.patientId);

  print("STATE AFTER: ${newState.patientId}");

  emit(newState);
}

  /// Add new appointment after validation
  Future<void> _onAddAppointment(
    AddAppointmentEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

   
    try {
      final appointment = AppointmentModel(
        date: event.date,
        time: event.time,
        notes: event.notes,
        status: 'pending',
        doctorId: event.doctorId,
        patientId: event.patientId,
        nurseId: 1, // Hardcoded - can be dynamic later
      );

      await appointmentRepository.addAppointment(appointment);

      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  /// Fetch doctor's appointments
  Future<void> _onGetAppointments(
    GetAppointmentsEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    if (event.doctorId < 1) {
      emit(state.copyWith(error: 'Invalid doctor ID'));
      return;
    }

    emit(state.copyWith(isGetLoading: true, error: null));

    try {
      final appointments =
          await appointmentRepository.getDoctorsAppointments(event.doctorId);

      emit(state.copyWith(
        isGetLoading: false,
        appointments: appointments,
        error: null,
        selectedDate: DateTime.now(),
        isSuccess: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isGetLoading: false,
        error: e.toString(),
      ));
    }
  }

  /// Clear form fields and session state
  void _onClearFields(
    ClearAppointmentFieldsEvent event,
    Emitter<AppointmentState> emit,
  ) {
   emit(state.copyWith(
  doctorId: null,
  patientId: null,
  isLoading: false,
  isSuccess: false,
  error: null,
  appointments: null,
  validationError: null,
));
  }

  void _onValidateSelection(ValidateSelectionEvent event, Emitter<AppointmentState> emit) {
    final isValid = state.doctorId != null && state.patientId != null;
    final validationError = isValid ? null : 'Please select both doctor and patient';

    emit(state.copyWith(
      isValid: isValid,
      validationError: validationError,
    ));
    print("✅ VALIDATION: isValid=$isValid, error=${validationError ?? 'OK'}");
  }

  void _onPreviousDay(PreviousDayEvent event, Emitter<AppointmentState> emit) {
    if (state.selectedDate == null) return;
    emit(state.copyWith(
      selectedDate: state.selectedDate!.subtract(const Duration(days: 1)),
    ));
  }

  void _onNextDay(NextDayEvent event, Emitter<AppointmentState> emit) {
    if (state.selectedDate == null) return;
    emit(state.copyWith(
      selectedDate: state.selectedDate!.add(const Duration(days: 1)),
    ));
  }
Future<void> _onDeleteAppointment(
    DeleteAppointmentEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      // حدّث القائمة محلياً بدون API
      final updatedAppointments = state.appointments.map((apt) {
        if (apt.id == event.appointmentId) {
          return apt.copyWith(status: 'cancelled'); // تحول للأحمر
        }
        return apt;
      }).toList();

      emit(state.copyWith(appointments: updatedAppointments));
    } catch (e) {
      emit(state.copyWith(error: 'خطأ: $e'));
    }
  }
}


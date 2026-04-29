

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randevu_app/data/models/paitent_model.dart';
import 'package:randevu_app/data/repository/appointment_repository.dart';
import 'package:randevu_app/data/repository/paitent_repository.dart';
import 'package:randevu_app/logic/paitent_bloc/paitent_event.dart';
import 'package:randevu_app/logic/paitent_bloc/paitent_state.dart';
import 'package:randevu_app/logic/use_case/add_paitent_usecase.dart';

// Removed ComplaintsState import - using distinct states now
import 'dart:async';

import 'package:randevu_app/logic/use_case/search_paitent_usecase.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {

  final PatientRepository patientRepository;

  final AppointmentRepository appointmentRepository;



  late final ISearchPatientUseCase _searchPatientUseCase;

  final List<String> _complaints = [];
  List<Map<String, String>> _medications = [];
  String _diagnosis = '';
  Timer? _sessionTimer;
  Duration _sessionDuration = Duration.zero;

  /// Cached last search query and results for restoring after navigation
  String? _lastSearchQuery;
  List<PatientModel>? _lastSearchResults;

PatientBloc({
    required this.patientRepository,

    required this.appointmentRepository,

  }) : super(PatientInitial()) {
    _searchPatientUseCase = SearchPatientUseCase(repository: patientRepository);
    
    on<AddPatientEvent>(_onAddPatient);
    on<ClearPatientFieldsEvent>(_onClearFields);
    on<SearchPatientEvent>(_onSearchPatient);
 
    on<AddComplaintEvent>(_onAddComplaint);
  ;
    on<AddMedicationEvent>(_onAddMedication);
    on<DeleteMedicationEvent>(_onDeleteMedication);

  
    on<GetPatientAppointmentsEvent>(_onGetPatientAppointments);
    on<GetPatientBasicInfoEvent>(_onGetPatientBasicInfo);
    on<ReloadLastSearchEvent>(_onReloadLastSearch);
  }


 


  Future<void> _onGetPatientBasicInfo(
    GetPatientBasicInfoEvent event,
    Emitter<PatientState> emit,
  ) async {
    print("🔥 PATIENT EVENT TRIGGERED");
    print("🔥 GET PATIENT ID: ${event.patientId}");

    emit(PatientLoading());

    try {
      final patient = await patientRepository.getPatientById(event.patientId);
      print("🔥 PATIENT RESULT: $patient");

      if (patient != null) {
        emit(PatientBasicInfoLoaded(patient));
      } else {
        print("❌ PATIENT NULL");
        emit(PatientFailure("Patient not found"));
      }
    } catch (e) {
      print("❌ ERROR: $e");
      emit(PatientFailure(e.toString()));
    }
  }


  // AppointmentRepository appointmentRepository already initialized in main constructor



  Future<void> _onGetPatientAppointments(
    GetPatientAppointmentsEvent event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientAppointmentsLoading());

    try {
      final appointments = await appointmentRepository.getPatientAppointments(event.patientId);
      emit(PatientAppointmentsLoaded(appointments));
    } catch (e) {
      emit(PatientAppointmentsError(e.toString()));
    }
  }

String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  Future<void> _onAddComplaint(
    AddComplaintEvent event,
    Emitter<PatientState> emit,
  ) async {
    final trimmed = event.complaint.trim();
    if (trimmed.isEmpty) return;
    _complaints.add(trimmed);
    emit(ComplaintsUpdated(List.unmodifiable(_complaints)));
  }

 

  Future<void> _onAddMedication(
    AddMedicationEvent event,
    Emitter<PatientState> emit,
  ) async {
    if (event.medication['name']?.trim().isNotEmpty ?? false) {
      _medications.add(Map<String, String>.from(event.medication));
      emit(MedicationsUpdated(List.unmodifiable(_medications)));
    }
  }

  Future<void> _onDeleteMedication(
    DeleteMedicationEvent event,
    Emitter<PatientState> emit,
  ) async {
    if (event.index >= 0 && event.index < _medications.length) {
      _medications.removeAt(event.index);
      emit(MedicationsUpdated(List.unmodifiable(_medications)));
    }
  }

Future<void> _onAddPatient(
  AddPatientEvent event,
  Emitter<PatientState> emit,
) async {
  emit(PatientLoading());

  try {
    final patient = PatientModel(
      name: event.name,
      phone: event.phone,
      city: event.city,
      address: event.address,
      age: event.age,
      idNumber: event.idNumber,
      gender: event.gender,
      userId: 1,
    );

    final useCase = AddPatientUseCase(repository: patientRepository);

    final newPatientId = await useCase.execute(patient);

   emit(PatientSuccess(patientId: newPatientId));

  } catch (e) {
    emit(PatientFailure(e.toString()));
  }
}
  Future<void> _onClearFields(
    ClearPatientFieldsEvent event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientCleared());
  }

  Future<void> _onSearchPatient(
    SearchPatientEvent event,
    Emitter<PatientState> emit,
  ) async {
    final query = event.query.trim();
    if (query.length < 3) {
      emit(SearchPatientFailure('Query must be at least 3 characters'));
      return;
    }

    emit(SearchPatientLoading());

    try {
      print('BLoC: Searching for "$query"');
      final patients = await _searchPatientUseCase.execute(query: query);
      print('BLoC: Found ${patients.length} patients for "$query"');

      _lastSearchQuery = query;
      _lastSearchResults = patients;

      if (patients.isEmpty) {
        emit(SearchPatientNoResults('No patients found matching "$query"'));
      } else {
        emit(SearchPatientSuccess(patients));
      }
    } catch (e) {
      print('BLoC: Search error for "$query": $e');
      emit(SearchPatientFailure(e.toString()));
    }
  }

  Future<void> _onReloadLastSearch(
    ReloadLastSearchEvent event,
    Emitter<PatientState> emit,
  ) async {
    if (_lastSearchResults != null && _lastSearchResults!.isNotEmpty) {
      emit(SearchPatientSuccess(_lastSearchResults!));
    } else if (_lastSearchQuery != null) {
      emit(SearchPatientLoading());
      try {
        final patients = await _searchPatientUseCase.execute(query: _lastSearchQuery!);
        _lastSearchResults = patients;
        if (patients.isEmpty) {
          emit(SearchPatientNoResults('No patients found matching "$_lastSearchQuery"'));
        } else {
          emit(SearchPatientSuccess(patients));
        }
      } catch (e) {
        emit(SearchPatientFailure(e.toString()));
      }
    }
  }

  


@override
  Future<void> close() async {
    _sessionTimer?.cancel();
    await super.close();
  }
}



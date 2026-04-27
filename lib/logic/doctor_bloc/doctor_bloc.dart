import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randevu_app/data/repository/doctor_repository.dart';
import 'package:randevu_app/logic/doctor_bloc/doctor_event.dart';
import 'package:randevu_app/logic/doctor_bloc/doctor_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final DoctorRepository repository;

  DoctorBloc(this.repository) : super(DoctorInitial()) {
    /// تحميل الأطباء
    on<LoadDoctorsEvent>(_onLoadDoctors);

    /// إضافة طبيب
    on<AddDoctorEvent>(_onAddDoctor);

    /// البحث عن طبيب
    on<SearchDoctorEvent>(_onSearchDoctor);
  }

  Future<void> _onLoadDoctors(
    LoadDoctorsEvent event,
    Emitter<DoctorState> emit,
  ) async {
    emit(DoctorLoading());

    try {
      final doctors = await repository.getAllDoctors();

      if (doctors.isEmpty) {
        emit(DoctorNoResults("No doctors found"));
      } else {
        emit(DoctorLoaded(doctors));
      }
    } catch (_) {
      emit(DoctorFailure("Failed to load doctors"));
    }
  }

  Future<void> _onAddDoctor(
    AddDoctorEvent event,
    Emitter<DoctorState> emit,
  ) async {
    try {
      await repository.addDoctor(event.doctor);

      final doctors = await repository.getAllDoctors();
      emit(DoctorLoaded(doctors));
    } catch (_) {
      emit(DoctorFailure("Failed to add doctor"));
    }
  }

  Future<void> _onSearchDoctor(
    SearchDoctorEvent event,
    Emitter<DoctorState> emit,
  ) async {
    final query = event.query.trim();

    if (query.length < 2) {
      add(LoadDoctorsEvent());
      return;
    }

    emit(DoctorLoading());

    try {
      final doctors = await repository.getAllDoctors();

      final filtered = doctors.where((doctor) {
        return doctor.name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      if (filtered.isEmpty) {
        emit(DoctorNoResults('No doctors found'));
      } else {
        emit(DoctorSearchSuccess(filtered));
      }
    } catch (_) {
      emit(DoctorFailure('Search failed'));
    }
  }
}
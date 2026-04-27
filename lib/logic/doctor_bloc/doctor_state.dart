// ================= doctor_state.dart =================

import 'package:randevu_app/data/models/doctor_model.dart';

abstract class DoctorState {}

class DoctorInitial extends DoctorState {}

class DoctorLoading extends DoctorState {}

class DoctorLoaded extends DoctorState {
  final List<DoctorModel> doctors;

  DoctorLoaded(this.doctors);
}

class DoctorSearchSuccess extends DoctorState {
  final List<DoctorModel> doctors;

  DoctorSearchSuccess(this.doctors);
}

class DoctorNoResults extends DoctorState {
  final String message;

  DoctorNoResults(this.message);
}

class DoctorFailure extends DoctorState {
  final String message;

  DoctorFailure(this.message);
}
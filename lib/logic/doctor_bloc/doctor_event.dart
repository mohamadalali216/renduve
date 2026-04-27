import 'package:randevu_app/data/models/doctor_model.dart';
abstract class DoctorEvent {}

class LoadDoctorsEvent extends DoctorEvent {}

class AddDoctorEvent extends DoctorEvent {
  final DoctorModel doctor;

  AddDoctorEvent(this.doctor);
}
class SearchDoctorEvent extends DoctorEvent {
  final String query;

  SearchDoctorEvent(this.query);
}
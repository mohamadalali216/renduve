
import 'package:randevu_app/data/models/appointment_model.dart';
import 'package:randevu_app/data/repository/appointment_repository.dart';

/// UseCase for fetching doctor's appointments following Clean Arch
class GetAppointmentsUseCase {
  final AppointmentRepository appointmentRepository;

  const GetAppointmentsUseCase({
    required this.appointmentRepository,
  });

  Future<List<AppointmentModel>> execute({
    required int doctorId,
  }) {
    return appointmentRepository.getDoctorsAppointments(doctorId);
  }
}


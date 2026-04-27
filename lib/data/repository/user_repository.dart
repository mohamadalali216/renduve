import 'package:randevu_app/data/datasources/local/appointment_local_datasource.dart';
import 'package:randevu_app/data/datasources/remot/appointment_remot_datasource.dart';
import 'package:randevu_app/data/models/appointment_model.dart';

/// Repository يعمل بطريقة Offline-First
class AppointmentRepository {
  final AppointmentLocalDataSource localDataSource;
  final AppointmentRemoteDataSource remoteDataSource;

  AppointmentRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  /// ================= CREATE =================
  Future<int> addAppointment(AppointmentModel appointment) async {
    final result = await localDataSource.insertAppointment(appointment);
    _syncInBackground(appointment);
    return result;
  }

  /// ================= UPDATE =================
  Future<int> updateAppointment(AppointmentModel appointment) async {
    final updatedAppointment = appointment.markUpdated();
    final result = await localDataSource.updateAppointment(updatedAppointment);
    _syncInBackground(updatedAppointment);
    return result;
  }

  /// ================= SOFT DELETE =================
  Future<int> deleteAppointment(int id) async {
    final result = await localDataSource.softDelete(id);
    _syncDeleteInBackground(id);
    return result;
  }

  /// ================= GET BY ID =================
  Future<AppointmentModel?> getAppointmentById(int id) async {
    return await localDataSource.getAppointmentById(id);
  }

  /// ================= GET DOCTOR'S APPOINTMENTS =================
  Future<List<AppointmentModel>> getDoctorsAppointments(int doctorId) async {
    return await localDataSource.getDoctorsAppointments(doctorId);
  }

  /// ================= GET PATIENT'S APPOINTMENTS =================
  Future<List<AppointmentModel>> getPatientAppointments(int patientId) async {
    final localAppointments = await localDataSource.getPatientAppointments(patientId);
    await syncFromCloud(); // Ensure latest data
    final freshLocal = await localDataSource.getPatientAppointments(patientId);
    return freshLocal.where((apt) => apt.status == 'done' || apt.isDeleted == false).toList()
      ..sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
  }

  /// ================= GET ALL =================
  Future<List<AppointmentModel>> getAllAppointments() async {
    return await localDataSource.getAllAppointments();
  }

  /// ================= SYNC =================
  Future<void> syncToCloud() async {
    try {
      final unsynced = await localDataSource.getUnsyncedAppointments();
      for (final item in unsynced) {
        try {
          await remoteDataSource.syncAppointment(item);
          await localDataSource.markAsSynced(item.id!);
        } catch (e) { continue; }
      }
    } catch (e) {}
  }

  Future<void> syncFromCloud() async {
    try {
      final remoteItems = await remoteDataSource.getAllAppointments();
      for (final item in remoteItems) {
        final local = await localDataSource.getAppointmentById(item.id!);
        if (local == null) {
          await localDataSource.insertAppointment(item);
        } else if (!local.needsSync) {
          await localDataSource.updateAppointment(item);
        }
      }
    } catch (e) {}
  }

  Future<void> fullSync() async {
    await syncFromCloud();
    await syncToCloud();
  }

  /// ================= UTILITY =================
  Future<int> addOrUpdate(AppointmentModel appointment) async {
    if (appointment.id == null) {
      return addAppointment(appointment);
    } else {
      return updateAppointment(appointment);
    }
  }

  void _syncInBackground(AppointmentModel appointment) {
    remoteDataSource.syncAppointment(appointment).then((success) {
      if (success) localDataSource.markAsSynced(appointment.id!);
    }).catchError((_) {});
  }

  void _syncDeleteInBackground(int id) {
    remoteDataSource.deleteAppointment(id).catchError((_) {});
  }
}

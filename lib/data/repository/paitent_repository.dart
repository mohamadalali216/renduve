
import 'package:randevu_app/data/datasources/local/paitent_local_datasource.dart';
import 'package:randevu_app/data/datasources/remot/paitent_remote_datasource.dart';
import 'package:randevu_app/data/models/paitent_model.dart';

/// Repository يعمل بطريقة Offline-First
class PatientRepository {
  final PatientLocalDataSource localDataSource;
  final PatientRemoteDataSource remoteDataSource;

  PatientRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  /// ================= CREATE =================
  Future<int> addPatient(PatientModel patient) async {
    final result = await localDataSource.insertPatient(patient);
    _syncInBackground(patient);
    return result;
  }

  /// ================= UPDATE =================
  Future<int> updatePatient(PatientModel patient) async {
    final updatedPatient = patient.markUpdated();
    final result = await localDataSource.updatePatient(updatedPatient);
    _syncInBackground(updatedPatient);
    return result;
  }

  /// ================= SOFT DELETE =================
  Future<int> deletePatient(int id) async {
    final result = await localDataSource.softDelete(id);
    _syncDeleteInBackground(id);
    return result;
  }

  /// ================= GET BY ID =================
  Future<PatientModel?> getPatientById(int id) async {
    return await localDataSource.getPatientById(id);
  }

  /// ================= GET ALL =================
  Future<List<PatientModel>> getAllPatients() async {
    return await localDataSource.getAllPatients();
  }

  /// ================= SEARCH =================
  Future<List<PatientModel>> searchPatients(String query) async {
    return await localDataSource.searchPatient(query);
  }

  /// Get patient counts per day of the week (Sun=7, Mon=1, etc.)
 

  /// ================= SYNC =================
  Future<void> syncToCloud() async {
    try {
      final unsyncedPatients = await localDataSource.getUnsyncedPatients();
      for (final patient in unsyncedPatients) {
        try {
          await remoteDataSource.syncPatient(patient);
          await localDataSource.markAsSynced(patient.id!);
        } catch (e) {
          continue;
        }
      }
    } catch (e) {}
  }

  Future<void> syncFromCloud() async {
    try {
      final remotePatients = await remoteDataSource.getAllPatients();
      for (final patient in remotePatients) {
        final localPatient = await localDataSource.getPatientById(patient.id!);
        if (localPatient == null) {
          await localDataSource.insertPatient(patient);
        } else if (!localPatient.needsSync) {
          await localDataSource.updatePatient(patient);
        }
      }
    } catch (e) {}
  }

  Future<void> fullSync() async {
    await syncFromCloud();
    await syncToCloud();
  }

  /// ================= UTILITY =================
  Future<int> addOrUpdate(PatientModel patient) async {
    if (patient.id == null) {
      return addPatient(patient);
    } else {
      return updatePatient(patient);
    }
  }

  void _syncInBackground(PatientModel patient) {
    remoteDataSource.syncPatient(patient).then((success) {
      if (success) localDataSource.markAsSynced(patient.id!);
    }).catchError((_) {});
  }

  void _syncDeleteInBackground(int id) {
    remoteDataSource.deletePatient(id).catchError((_) {});
  }
}


import 'package:randevu_app/data/models/paitent_model.dart';

/// Remote Data Source للتفاعل مع الخادم (API)
/// ملاحظة: هذا الملف يحتاج لتفعيلة عند توفر API
class PatientRemoteDataSource {
  /// INSERT PATIENT
  Future<int> insertPatient(PatientModel model) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// UPDATE PATIENT
  Future<int> updatePatient(PatientModel model) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// DELETE PATIENT
  Future<int> deletePatient(int id) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// GET ALL PATIENTS
  Future<List<PatientModel>> getAllPatients() async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// GET PATIENT BY ID
  Future<PatientModel?> getPatientById(int id) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// SYNC PATIENT
  Future<bool> syncPatient(PatientModel model) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// SEARCH PATIENTS
  Future<List<PatientModel>> searchPatients(String query) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }
}

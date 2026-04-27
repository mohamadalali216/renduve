import 'package:randevu_app/data/models/doctor_model.dart';

/// Remote Data Source للتفاعل مع الخادم (API)
/// ملاحظة: هذا الملف يحتاج لتفعيلة عند توفر API
class DoctorRemoteDataSource {
  /// INSERT DOCTOR
  Future<int> insertDoctor(DoctorModel model) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// UPDATE DOCTOR
  Future<int> updateDoctor(DoctorModel model) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// DELETE DOCTOR
  Future<int> deleteDoctor(int id) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// GET ALL DOCTORS
  Future<List<DoctorModel>> getAllDoctors() async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// GET DOCTOR BY ID
  Future<DoctorModel?> getDoctorById(int id) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// SYNC DOCTOR
  Future<bool> syncDoctor(DoctorModel model) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }
}

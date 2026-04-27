
import 'package:randevu_app/data/models/nurse_model.dart';

/// Remote Data Source للتفاعل مع الخادم (API)
/// ملاحظة: هذا الملف يحتاج لتفعيلة عند توفر API
class NurseRemoteDataSource {
  /// INSERT NURSE
  Future<int> insertNurse(NurseModel model) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// UPDATE NURSE
  Future<int> updateNurse(NurseModel model) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// DELETE NURSE
  Future<int> deleteNurse(int id) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// GET ALL NURSES
  Future<List<NurseModel>> getAllNurses() async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// GET NURSE BY ID
  Future<NurseModel?> getNurseById(int id) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// SYNC NURSE
  Future<bool> syncNurse(NurseModel model) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }
}

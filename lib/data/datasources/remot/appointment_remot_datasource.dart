
import 'package:randevu_app/data/models/appointment_model.dart';

/// Remote Data Source للتفاعل مع الخادم (API)
/// ملاحظة: هذا الملف يحتاج لتفعيلة عند توفر API
class AppointmentRemoteDataSource {
  /// INSERT APPOINTMENT
  Future<int> insertAppointment(AppointmentModel model) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// UPDATE APPOINTMENT
  Future<int> updateAppointment(AppointmentModel model) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// DELETE APPOINTMENT
  Future<int> deleteAppointment(int id) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// GET ALL APPOINTMENTS
  Future<List<AppointmentModel>> getAllAppointments() async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// GET APPOINTMENT BY ID
  Future<AppointmentModel?> getAppointmentById(int id) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// SYNC APPOINTMENT
  Future<bool> syncAppointment(AppointmentModel model) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }
}

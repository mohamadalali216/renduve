
import 'package:randevu_app/data/models/user_model.dart';

/// Remote Data Source للتفاعل مع الخادم (API)
/// ملاحظة: هذا الملف يحتاج لتفعيلة عند توفر API
class UserRemoteDataSource {
  /// جلب جميع المستخدمين من الخادم
  Future<List<UserModel>> getAllUsers() async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// تسجيل الدخول عن طريق الخادم
  Future<UserModel?> login(String username, String password) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// جلب بيانات المستخدم من الخادم
  Future<UserModel?> getUserById(int id) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// إضافة مستخدم على الخادم
  Future<bool> insertUser(UserModel user) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// تحديث بيانات المستخدم على الخادم
  Future<bool> updateUser(UserModel user) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// حذف مستخدم على الخادم
  Future<bool> deleteUser(int id) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }

  /// مزامنة البيانات المحلية مع الخادم
  Future<bool> syncUser(UserModel user) async {
    throw UnimplementedError('Remote API not available yet. Please implement when API is ready.');
  }
}

import 'package:randevu_app/data/datasources/local/doctor_local_datasource.dart';
import 'package:randevu_app/data/datasources/remot/doctor_remote_datasource.dart';
import 'package:randevu_app/data/models/doctor_model.dart';

/// Repository يعمل بطريقة Offline-First:
/// - التخزين المحلي (SQLite) هو الأساسي
/// - المزامنة مع السحابة تحدث عند توفر الإنترنت
class DoctorRepository {
  final DoctorLocalDataSource localDataSource;
  final DoctorRemoteDataSource remoteDataSource;

  DoctorRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  /// ================= CREATE =================
  /// إضافة طبيب - يتم تخزينه محلياً أولاً
  Future<int> addDoctor(DoctorModel doctor) async {
    final result = await localDataSource.insertDoctor(doctor);
    // محاولة المزامنة في الخلفية
    _syncInBackground(doctor);
    return result;
  }

  /// ================= UPDATE =================
  /// تحديث طبيب - يتم تخزينه محلياً أولاً
  Future<int> updateDoctor(DoctorModel doctor) async {
    final updatedDoctor = doctor.markUpdated();
    final result = await localDataSource.updateDoctor(updatedDoctor);
    // محاولة المزامنة في الخلفية
    _syncInBackground(updatedDoctor);
    return result;
  }

  /// ================= SOFT DELETE =================
  /// حذف طبيب - يتم تخزينه محلياً أولاً
  Future<int> deleteDoctor(int id) async {
    final result = await localDataSource.softDelete(id);
    // محاولة المزامنة في الخلفية
    _syncDeleteInBackground(id);
    return result;
  }

  /// ================= GET BY ID =================
  /// جلب طبيب بواسطة ID - من المحلي فقط
  Future<DoctorModel?> getDoctorById(int id) async {
    return await localDataSource.getDoctorById(id);
  }

  /// ================= GET ALL =================
  /// جلب جميع الأطباء - من المحلي فقط (Offline-First)
  Future<List<DoctorModel>> getAllDoctors() async {
    return await localDataSource.getAllDoctors();
  }

  /// ================= SYNC: LOCAL → REMOTE =================
  /// مزامنة البيانات غير المتزامنة إلى السحابة
  Future<void> syncToCloud() async {
    try {
      final unsyncedDoctors = await localDataSource.getUnsyncedDoctors();
      for (final doctor in unsyncedDoctors) {
        try {
          await remoteDataSource.syncDoctor(doctor);
          await localDataSource.markAsSynced(doctor.id!);
        } catch (e) {
          // استمرار المحاولة رغم الفشل
          continue;
        }
      }
    } catch (e) {
      // فشل المزامنة - سيتم المحاولة لاحقاً
    }
  }

  /// ================= SYNC: REMOTE → LOCAL =================
  /// جلب البيانات من السحابة وتحديث المحلي
  Future<void> syncFromCloud() async {
    try {
      final remoteDoctors = await remoteDataSource.getAllDoctors();
      for (final doctor in remoteDoctors) {
        final localDoctor = await localDataSource.getDoctorById(doctor.id!);
        if (localDoctor == null) {
          // إضافة جديد
          await localDataSource.insertDoctor(doctor);
        } else if (!localDoctor.needsSync) {
          // تحديث فقط إذا كان المجلد محلياً لم يتغير
          await localDataSource.updateDoctor(doctor);
        }
      }
    } catch (e) {
      // فشل المزامنة - نستمر بالعمل محلياً
    }
  }

  /// ================= FULL SYNC =================
  /// مزامنة كاملة (تحميل + رفع)
  Future<void> fullSync() async {
    await syncFromCloud();
    await syncToCloud();
  }

  /// ================= UTILITY =================
  /// إضافة أو تحديث طبيب (upsert)
  Future<int> addOrUpdate(DoctorModel doctor) async {
    if (doctor.id == null) {
      return addDoctor(doctor);
    } else {
      return updateDoctor(doctor);
    }
  }

  /// ================= BACKGROUND SYNC =================
  /// مزامنة في الخلفية (عدم انتظار النتيجة)
  void _syncInBackground(DoctorModel doctor) {
    // يمكن استخدام Worker أو Future لتزامن في الخلفية
    remoteDataSource.syncDoctor(doctor).then((success) {
      if (success) {
        localDataSource.markAsSynced(doctor.id!);
      }
    }).catchError((_) {});
  }

  void _syncDeleteInBackground(int id) {
    remoteDataSource.deleteDoctor(id).catchError((_) {});
  }
}

import 'package:randevu_app/data/datasources/local/nurse_local_datasource.dart';
import 'package:randevu_app/data/datasources/remot/nurse_remote_datasource.dart';
import 'package:randevu_app/data/models/nurse_model.dart';

/// Repository يعمل بطريقة Offline-First
class NurseRepository {
  final NurseLocalDataSource localDataSource;
  final NurseRemoteDataSource remoteDataSource;

  NurseRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  /// ==================== CRUD ====================
  /// إضافة ممرض - يتم تخزينه محلياً أولاً
  Future<int> addNurse(NurseModel model) async {
    final result = await localDataSource.insertNurse(model);
    _syncInBackground(model);
    return result;
  }

  /// تحديث ممرض - يتم تخزينه محلياً أولاً
  Future<int> updateNurse(NurseModel model) async {
    final updatedModel = model.markUpdated();
    final result = await localDataSource.updateNurse(updatedModel);
    _syncInBackground(updatedModel);
    return result;
  }

  /// حذف ممرض - يتم تخزينه محلياً أولاً
  Future<int> deleteNurse(int id) async {
    final result = await localDataSource.softDelete(id);
    _syncDeleteInBackground(id);
    return result;
  }

  /// جلب جميع الممرضين - من المحلي فقط
  Future<List<NurseModel>> getAllNurses() async {
    return await localDataSource.getAllNurses();
  }

  /// جلب ممرض بواسطة ID - من المحلي فقط
  Future<NurseModel?> getNurseById(int id) async {
    return await localDataSource.getNurseById(id);
  }

  /// ==================== SYNC ====================
  /// مزامنة البيانات المحلية إلى السحابة
  Future<void> syncToCloud() async {
    try {
      final unsyncedNurses = await localDataSource.getUnsyncedNurses();
      for (final nurse in unsyncedNurses) {
        try {
          await remoteDataSource.syncNurse(nurse);
          await localDataSource.markAsSynced(nurse.id!);
        } catch (e) {
          continue;
        }
      }
    } catch (e) {
      // فشل المزامنة
    }
  }

  /// جلب البيانات من السحابة وتحديث المحلي
  Future<void> syncFromCloud() async {
    try {
      final remoteNurses = await remoteDataSource.getAllNurses();
      for (final nurse in remoteNurses) {
        final localNurse = await localDataSource.getNurseById(nurse.id!);
        if (localNurse == null) {
          await localDataSource.insertNurse(nurse);
        } else if (!localNurse.needsSync) {
          await localDataSource.updateNurse(nurse);
        }
      }
    } catch (e) {
      // فشل المزامنة
    }
  }

  /// مزامنة كاملة
  Future<void> fullSync() async {
    await syncFromCloud();
    await syncToCloud();
  }

  /// ==================== BACKGROUND SYNC ====================
  void _syncInBackground(NurseModel nurse) {
    remoteDataSource.syncNurse(nurse).then((success) {
      if (success) {
        localDataSource.markAsSynced(nurse.id!);
      }
    }).catchError((_) {});
  }

  void _syncDeleteInBackground(int id) {
    remoteDataSource.deleteNurse(id).catchError((_) {});
  }
}

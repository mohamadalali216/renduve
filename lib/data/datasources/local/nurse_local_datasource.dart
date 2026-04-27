import 'package:randevu_app/data/datasources/database/database_helper.dart';
import 'package:randevu_app/data/models/nurse_model.dart';


class NurseLocalDataSource {
  /// INSERT NURSE
  Future<int> insertNurse(NurseModel model) async {
    final db = await DatabaseHelper.database;

    final stmt = db.prepare('''
      INSERT INTO nurses 
      (name, phone, shift, user_id,
       is_synced, created_at, updated_at, deleted_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''');

    stmt.execute([
      model.name,
      model.phone,
      model.shift,
      model.userId,
      model.isSynced,
      model.createdAt,
      model.updatedAt,
      model.deletedAt,
    ]);

    stmt.dispose();
    return db.getUpdatedRows();
  }

  /// UPDATE NURSE
  Future<int> updateNurse(NurseModel model) async {
    if (model.id == null) return 0;

    final db = await DatabaseHelper.database;

    final stmt = db.prepare('''
      UPDATE nurses SET
        name = ?,
        phone = ?,
        shift = ?,
        user_id = ?,
        is_synced = 0,
        updated_at = ?
      WHERE id = ?
    ''');

    stmt.execute([
      model.name,
      model.phone,
      model.shift,
      model.userId,
      DateTime.now().toIso8601String(),
      model.id,
    ]);

    stmt.dispose();
    return db.getUpdatedRows();
  }

  /// SOFT DELETE
  Future<int> softDelete(int id) async {
    final db = await DatabaseHelper.database;

    final stmt = db.prepare('''
      UPDATE nurses SET
        deleted_at = ?,
        is_synced = 0
      WHERE id = ?
    ''');

    stmt.execute([
      DateTime.now().toIso8601String(),
      id,
    ]);

    stmt.dispose();
    return db.getUpdatedRows();
  }

  /// GET ALL NURSES (not deleted)
  Future<List<NurseModel>> getAllNurses() async {
    final db = await DatabaseHelper.database;

    final result = db.select('''
      SELECT * FROM nurses WHERE deleted_at IS NULL
    ''');

    return result.map((row) => NurseModel.fromMap(row)).toList();
  }

  /// GET UNSYNCED NURSES
  Future<List<NurseModel>> getUnsyncedNurses() async {
    final db = await DatabaseHelper.database;

    final result = db.select('''
      SELECT * FROM nurses WHERE is_synced = 0
    ''');

    return result.map((row) => NurseModel.fromMap(row)).toList();
  }

  /// MARK AS SYNCED
  Future<int> markAsSynced(int id) async {
    final db = await DatabaseHelper.database;

    final stmt = db.prepare('''
      UPDATE nurses SET is_synced = 1 WHERE id = ?
    ''');

    stmt.execute([id]);
    stmt.dispose();

    return db.getUpdatedRows();
  }

  /// GET NURSE BY ID
  Future<NurseModel?> getNurseById(int id) async {
    final db = await DatabaseHelper.database;

    final result = db.select('''
      SELECT * FROM nurses WHERE id = $id
    ''');

    if (result.isEmpty) return null;

    return NurseModel.fromMap(result.first);
  }
}

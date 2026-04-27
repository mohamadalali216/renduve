
import 'package:randevu_app/data/datasources/database/database_helper.dart';
import 'package:randevu_app/data/models/doctor_model.dart';

class DoctorLocalDataSource {
  /// INSERT DOCTOR
  Future<int> insertDoctor(DoctorModel model) async {
    final db = await DatabaseHelper.database;

    final stmt = db.prepare('''
      INSERT INTO doctors 
      (name, specialization, phone, user_id, is_synced, created_at, updated_at, deleted_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''');

    stmt.execute([
      model.name,
      model.specialty,
      model.phone,
      model.userId,
      model.isSynced,
      model.createdAt,
      model.updatedAt,
      model.deletedAt,
    ]);

    stmt.dispose();

    return db.updatedRows;
  }

  /// UPDATE DOCTOR
  Future<int> updateDoctor(DoctorModel model) async {
    if (model.id == null) return 0;

    final db = await DatabaseHelper.database;

    final stmt = db.prepare('''
      UPDATE doctors SET
        name = ?,
        specialization = ?,
        phone = ?,
        user_id = ?,
        is_synced = 0,
        updated_at = ?
      WHERE id = ?
    ''');

    stmt.execute([
      model.name,
      model.specialty,
      model.phone,
      model.userId,
      DateTime.now().toIso8601String(),
      model.id,
    ]);

    stmt.dispose();

    return db.updatedRows;
  }

  /// SOFT DELETE
  Future<int> softDelete(int id) async {
    final db = await DatabaseHelper.database;

    final stmt = db.prepare('''
      UPDATE doctors SET
        deleted_at = ?,
        is_synced = 0
      WHERE id = ?
    ''');

    stmt.execute([
      DateTime.now().toIso8601String(),
      id,
    ]);

    stmt.dispose();

    return db.updatedRows;
  }

  /// GET ALL DOCTORS (not deleted)
  Future<List<DoctorModel>> getAllDoctors() async {
    final db = await DatabaseHelper.database;

    final result = db.select('''
      SELECT * FROM doctors WHERE deleted_at IS NULL
    ''');

    return result.map((row) => DoctorModel.fromMap(row)).toList();
  }

  /// GET UNSYNCED DOCTORS
  Future<List<DoctorModel>> getUnsyncedDoctors() async {
    final db = await DatabaseHelper.database;

    final result = db.select('''
      SELECT * FROM doctors WHERE is_synced = 0
    ''');

    return result.map((row) => DoctorModel.fromMap(row)).toList();
  }

  /// MARK AS SYNCED
  Future<int> markAsSynced(int id) async {
    final db = await DatabaseHelper.database;

    final stmt = db.prepare('''
      UPDATE doctors SET is_synced = 1 WHERE id = ?
    ''');

    stmt.execute([id]);
    stmt.dispose();

    return db.getUpdatedRows();
  }

  /// GET DOCTOR BY ID
  Future<DoctorModel?> getDoctorById(int id) async {
    final db = await DatabaseHelper.database;

    final result = db.select('''
      SELECT * FROM doctors WHERE id = $id
    ''');

    if (result.isEmpty) return null;

    return DoctorModel.fromMap(result.first);
  }
}

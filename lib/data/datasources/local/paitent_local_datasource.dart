import 'package:randevu_app/data/datasources/database/database_helper.dart';
import 'package:randevu_app/data/models/paitent_model.dart';

class PatientLocalDataSource {
  /// INSERT PATIENT
  Future<int> insertPatient(PatientModel model) async {
    final db = await DatabaseHelper.database;

    final stmt = db.prepare('''
      INSERT INTO patients 
      (name, age, gender, phone, address, city, idNumber, userId, isSynced, createdAt, updatedAt, deletedAt)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''');

    final now = DateTime.now().toIso8601String();
    stmt.execute([
      model.name,
      model.age,
      model.gender,
      model.phone,
      model.address,
      model.city,
      model.idNumber,
      model.userId,
      model.isSynced,
      model.createdAt.isEmpty ? now : model.createdAt,
      model.updatedAt.isEmpty ? now : model.updatedAt,
      model.deletedAt,
    ]);
    stmt.dispose();

   final newId = db.lastInsertRowId;
stmt.dispose();

print("✅ NEW PATIENT ID = $newId");
return newId;
  }

  /// UPDATE PATIENT
  Future<int> updatePatient(PatientModel model) async {
    if (model.id == null) return 0;

    final db = await DatabaseHelper.database;

    final stmt = db.prepare('''
      UPDATE patients SET
        name = ?,
        age = ?,
        gender = ?,
        phone = ?,
        address = ?,
        city = ?,
        idNumber = ?,
        userId = ?,
        isSynced = 0,
        updatedAt = ?
      WHERE id = ?
    ''');

    stmt.execute([
      model.name,
      model.age,
      model.gender,
      model.phone,
      model.address,
      model.city,
      model.idNumber,
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
      UPDATE patients SET
        deletedAt = ?,
        isSynced = 0
      WHERE id = ?
    ''');

    stmt.execute([
      DateTime.now().toIso8601String(),
      id,
    ]);

    stmt.dispose();

    return db.getUpdatedRows();
  }

  /// GET ALL PATIENTS (not deleted)
  Future<List<PatientModel>> getAllPatients() async {
    final db = await DatabaseHelper.database;
    final resultSet = db.select('SELECT * FROM patients WHERE deletedAt IS NULL');
    final patients = resultSet.map((row) => PatientModel.fromMap(row)).toList();
    return patients;
  }

  /// GET UNSYNCED PATIENTS
  Future<List<PatientModel>> getUnsyncedPatients() async {
    final db = await DatabaseHelper.database;
    final resultSet = db.select('SELECT * FROM patients WHERE isSynced = 0');
    final patients = resultSet.map((row) => PatientModel.fromMap(row)).toList();
    return patients;
  }

  /// MARK AS SYNCED
  Future<int> markAsSynced(int id) async {
    final db = await DatabaseHelper.database;

    final stmt = db.prepare('''
      UPDATE patients SET isSynced = 1 WHERE id = ?
    ''');

    stmt.execute([id]);
    stmt.dispose();

    return db.getUpdatedRows();
  }

  /// GET PATIENT BY ID
  Future<PatientModel?> getPatientById(int id) async {
    final db = await DatabaseHelper.database;
    final result = db.select('SELECT * FROM patients WHERE id = $id AND deletedAt IS NULL');
    
    if (result.isEmpty) return null;
    
    return PatientModel.fromMap(result.first);
  }

  /// SEARCH PATIENTS BY NAME OR PHONE 
  Future<List<PatientModel>> searchPatient(String query) async {
    final db = await DatabaseHelper.database;
    final resultSet = db.select("SELECT * FROM patients WHERE deletedAt IS NULL AND (name LIKE '%$query%' OR phone LIKE '%$query%')");
    final patients = resultSet.map((row) => PatientModel.fromMap(row)).toList();
    return patients;
  }
}

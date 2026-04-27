
import 'package:randevu_app/data/datasources/database/database_helper.dart';
import 'package:randevu_app/data/models/appointment_model.dart';


class AppointmentLocalDataSource {
  /// ENSURE TABLE EXISTS
  Future<void> _ensureTableExists() async {
    final db = await DatabaseHelper.database;
    try {
      db.execute('''
        CREATE TABLE IF NOT EXISTS appointments (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL,
          time TEXT NOT NULL,
          status TEXT NOT NULL,
          notes TEXT,
          doctor_id INTEGER NOT NULL,
          patient_id INTEGER NOT NULL,
          nurse_id INTEGER NOT NULL,
          is_synced INTEGER NOT NULL DEFAULT 0,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          deleted_at TEXT
        )
      ''');
    } catch (e) {
      // تجاهل إذا كان الجدول موجوداً
    }
  }

  /// INSERT APPOINTMENT
  Future<int> insertAppointment(AppointmentModel model) async {
    await _ensureTableExists();
    
    final db = await DatabaseHelper.database;

    final stmt = db.prepare('''
      INSERT INTO appointments 
      (date, time, status, notes, doctor_id, patient_id, nurse_id, 
       is_synced, created_at, updated_at, deleted_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''');

    stmt.execute([
      model.date,
      model.time,
      model.status,
      model.notes,
      model.doctorId,
      model.patientId,
      model.nurseId,
      model.isSynced,
      model.createdAt,
      model.updatedAt,
      model.deletedAt,
    ]);

    stmt.dispose();

    return db.updatedRows;
  }

  /// UPDATE APPOINTMENT
  Future<int> updateAppointment(AppointmentModel model) async {
    if (model.id == null) return 0;

    final db = await DatabaseHelper.database;

    final stmt = db.prepare('''
      UPDATE appointments SET
        date = ?,
        time = ?,
        status = ?,
        notes = ?,
        doctor_id = ?,
        patient_id = ?,
        nurse_id = ?,
        is_synced = 0,
        updated_at = ?
      WHERE id = ?
    ''');

    stmt.execute([
      model.date,
      model.time,
      model.status,
      model.notes,
      model.doctorId,
      model.patientId,
      model.nurseId,
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
      UPDATE appointments SET
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

  /// GET ALL APPOINTMENTS (not deleted)
  Future<List<AppointmentModel>> getAllAppointments() async {
    final db = await DatabaseHelper.database;

    final result = db.select('''
      SELECT * FROM appointments WHERE deleted_at IS NULL
    ''');

    return result.map((row) => AppointmentModel.fromMap(row)).toList();
  }

  /// GET UNSYNCED APPOINTMENTS
  Future<List<AppointmentModel>> getUnsyncedAppointments() async {
    final db = await DatabaseHelper.database;

    final result = db.select('''
      SELECT * FROM appointments WHERE is_synced = 0
    ''');

    return result.map((row) => AppointmentModel.fromMap(row)).toList();
  }

  /// MARK AS SYNCED
  Future<int> markAsSynced(int id) async {
    final db = await DatabaseHelper.database;

    final stmt = db.prepare('''
      UPDATE appointments SET is_synced = 1 WHERE id = ?
    ''');

    stmt.execute([id]);
    stmt.dispose();

    return db.updatedRows;
  }

  /// GET APPOINTMENT BY ID
  Future<AppointmentModel?> getAppointmentById(int id) async {
    final db = await DatabaseHelper.database;

    final result = db.select('''
      SELECT * FROM appointments WHERE id = $id
    ''');

    if (result.isEmpty) return null;

    return AppointmentModel.fromMap(result.first);
  }

  /// Get doctor's appointments with patient name JOIN
  Future<List<AppointmentModel>> getDoctorsAppointments(int doctorId) async {
    final db = await DatabaseHelper.database;

    final result = db.select('''
  SELECT a.*, p.name as patient_name 
  FROM appointments a 
  LEFT JOIN patients p ON a.patient_id = p.id 
  WHERE a.deleted_at IS NULL AND a.doctor_id = ?
  ORDER BY a.date ASC, a.time ASC
''', [doctorId]);

    return result.map((row) => AppointmentModel.fromMap(row)).toList();
  }

  /// Get patient's appointments
  Future<List<AppointmentModel>> getPatientAppointments(int patientId) async {
    await _ensureTableExists();
    final db = await DatabaseHelper.database;

    final result = db.select('''
      SELECT * FROM appointments 
      WHERE patient_id = ? AND deleted_at IS NULL
      ORDER BY date DESC, time DESC
    ''', [patientId]);

    return result.map((row) => AppointmentModel.fromMap(row)).toList();
  }
}

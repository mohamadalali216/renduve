import 'package:randevu_app/data/datasources/database/database_helper.dart';
import 'package:randevu_app/data/models/user_model.dart';

class UserLocalDataSource {
  /// INSERT USER
  Future<int> insertUser(UserModel model) async {
    final db = await DatabaseHelper.database;

    final stmt = db.prepare('''
  INSERT INTO users (username, password, role, isSynced, createdAt, updatedAt, deletedAt)
  VALUES (?, ?, ?, ?, ?, ?, ?)
''');

    stmt.execute([
      model.username,
      model.password,
      model.role,
      model.isSynced,
      model.createdAt,
      model.updatedAt,
      model.deletedAt,
    ]);

    stmt.dispose();

    return db.getUpdatedRows();
  }

  /// UPDATE USER
  Future<int> updateUser(UserModel model) async {
    if (model.id == null) return 0;

    final db = await DatabaseHelper.database;

    final stmt = db.prepare('''
      UPDATE users SET
        username = ?,
        password = ?,
        role = ?,
        isSynced = ?,
        updatedAt = ?
      WHERE id = ?
    ''');

    stmt.execute([
      model.username,
      model.password,
      model.role,
      0, // always mark unsynced
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
      UPDATE users SET
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

  /// GET ALL USERS (not deleted)
  Future<List<UserModel>> getAllUsers() async {
    final db = await DatabaseHelper.database;

    final result = db.select('''
      SELECT * FROM users WHERE deletedAt IS NULL
    ''');

    return result.map((row) => UserModel.fromMap(row)).toList();
  }

  /// GET UNSYNCED USERS
  Future<List<UserModel>> getUnsyncedUsers() async {
    final db = await DatabaseHelper.database;

    final result = db.select('''
      SELECT * FROM users WHERE isSynced = 0
    ''');

    return result.map((row) => UserModel.fromMap(row)).toList();
  }

  /// MARK AS SYNCED
  Future<int> markAsSynced(int id) async {
    final db = await DatabaseHelper.database;

    final stmt = db.prepare('''
      UPDATE users SET isSynced = 1 WHERE id = ?
    ''');

    stmt.execute([id]);
    stmt.dispose();

    return db.getUpdatedRows();
  }

  /// GET USER BY ID
  Future<UserModel?> getUserById(int id) async {
    final db = await DatabaseHelper.database;

    final result = db.select('''
      SELECT * FROM users WHERE id = $id
    ''');

    if (result.isEmpty) return null;

    return UserModel.fromMap(result.first);
  }

  /// LOGIN: GET USER BY USERNAME AND PASSWORD
  Future<UserModel?> getUserByUsernameAndPassword(
    String username,
    String password,
  ) async {
    final db = await DatabaseHelper.database;

    // Debug: طباعة الاستعلام
    
    final result = db.select(
      'SELECT * FROM users WHERE username = ? AND password = ? AND deletedAt IS NULL',
      [username, password],
    );

    // Debug: طباعة عدد النتائج
    
    if (result.isEmpty) return null;

    // Debug: طباعة أول نتيجة

    return UserModel.fromMap(result.first);
  }
}

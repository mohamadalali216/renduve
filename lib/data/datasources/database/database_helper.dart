import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
class DatabaseHelper {
  static Database? _db;


  static Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, 'medical_app.db');

    final file = File(dbPath);
    final db = sqlite3.open(file.path);

    // إنشاء الجداول دائماً للتأكد من وجود جميع الجداول
    _createTables(db);


    return db;
  }

  static void _createTables(Database db) {

    db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL,
        isSynced INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT,
        deletedAt TEXT
      );
    ''');

    // إدخال حساب تجريبي
    _insertTestUser(db);

db.execute('''
CREATE TABLE IF NOT EXISTS doctors (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  specialty TEXT NOT NULL,
  phone TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  is_synced INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  deleted_at TEXT
);
''');

_insertTestDoctors(db);

    db.execute('''
      CREATE TABLE IF NOT EXISTS patients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER,
        gender TEXT,
        phone TEXT,
        address TEXT,
        city TEXT,
        idNumber TEXT,
        userId INTEGER NOT NULL,
        isSynced INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT,
        deletedAt TEXT
      );
    ''');

    // تهجير قاعدة البيانات: إضافة الأعمدة الجديدة إذا لم تكن موجودة
    _migratePatientsTable(db);
    _migrateAllTables(db);
    
    // إنشاء جدول المواعيد
    _createAppointmentsTable(db);
  }

  /// إنشاء جدول المواعيد
  static void _createAppointmentsTable(Database db) {
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
      );
    ''');
  }

  /// تهجير جدول المرضى لإضافة الأعمدة الجديدة
  static void _migratePatientsTable(Database db) {
    try {
      // إضافة عمود city إذا لم يكن موجوداً
      db.execute("ALTER TABLE patients ADD COLUMN city TEXT");
    } catch (e) {
      // العمود موجود بالفعل - تجاهل الخطأ
    }

    try {
      // إضافة عمود idNumber إذا لم يكن موجوداً
      db.execute("ALTER TABLE patients ADD COLUMN idNumber TEXT");
    } catch (e) {
      // العمود موجود بالفعل - تجاهل الخطأ
    }
  }

  /// تهجير جميع الجداول - يضيف الأعمدة المفقودة للجداول القديمة
static void _migrateAllTables(Database db) {
    // ======== users ========
    try { db.execute("ALTER TABLE users ADD COLUMN isSynced INTEGER DEFAULT 0"); } catch (e) { kDebugMode ? debugPrint('Migration warning: $e') : null; }
    try { db.execute("ALTER TABLE users ADD COLUMN createdAt TEXT"); } catch (e) { kDebugMode ? debugPrint('Migration warning: $e') : null; }
    try { db.execute("ALTER TABLE users ADD COLUMN updatedAt TEXT"); } catch (e) {}
    try { db.execute("ALTER TABLE users ADD COLUMN deletedAt TEXT"); } catch (e) {}

    // ======== doctors ========
    try { db.execute("ALTER TABLE doctors ADD COLUMN userId INTEGER"); } catch (e) {}
    try { db.execute("ALTER TABLE doctors ADD COLUMN isSynced INTEGER DEFAULT 0"); } catch (e) {}
    try { db.execute("ALTER TABLE doctors ADD COLUMN createdAt TEXT"); } catch (e) {}
    try { db.execute("ALTER TABLE doctors ADD COLUMN updatedAt TEXT"); } catch (e) {}
    try { db.execute("ALTER TABLE doctors ADD COLUMN deletedAt TEXT"); } catch (e) {}

    // ======== patients ========
    try { db.execute("ALTER TABLE patients ADD COLUMN city TEXT"); } catch (e) {}
    try { db.execute("ALTER TABLE patients ADD COLUMN idNumber TEXT"); } catch (e) {}
    try { db.execute("ALTER TABLE patients ADD COLUMN userId INTEGER"); } catch (e) {}
    try { db.execute("ALTER TABLE patients ADD COLUMN isSynced INTEGER DEFAULT 0"); } catch (e) {}
    try { db.execute("ALTER TABLE patients ADD COLUMN createdAt TEXT"); } catch (e) {}
    try { db.execute("ALTER TABLE patients ADD COLUMN updatedAt TEXT"); } catch (e) {}
    try { db.execute("ALTER TABLE patients ADD COLUMN deletedAt TEXT"); } catch (e) {}

    // ======== patient_complaints ========
    try {
      db.execute('''CREATE TABLE IF NOT EXISTS patient_complaints (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL,
        patient_id INTEGER NOT NULL,
        is_synced INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )''');
    } catch (e) {}
    try { db.execute("ALTER TABLE patient_complaints ADD COLUMN patient_id INTEGER"); } catch (e) {}
    try { db.execute("ALTER TABLE patient_complaints ADD COLUMN medical_exam_id INTEGER"); } catch (e) {}   // ← أضف هذا السطر

    try { db.execute("ALTER TABLE patient_complaints ADD COLUMN is_synced INTEGER DEFAULT 0"); } catch (e) {}
    try { db.execute("ALTER TABLE patient_complaints ADD COLUMN created_at TEXT"); } catch (e) {}
    try { db.execute("ALTER TABLE patient_complaints ADD COLUMN updated_at TEXT"); } catch (e) {}
    try { db.execute("ALTER TABLE patient_complaints ADD COLUMN deleted_at TEXT"); } catch (e) {}

    // ======== diagnoses ========
    try {
      db.execute('''CREATE TABLE IF NOT EXISTS diagnoses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        condition_name TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL,
        exam_id INTEGER NOT NULL DEFAULT 0,
        doctor_id INTEGER NOT NULL DEFAULT 0,
        is_synced INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )''');
    } catch (e) {}

    // ======== medical_exams ========
    try {
      db.execute('''CREATE TABLE IF NOT EXISTS medical_exams (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        content TEXT,
        date TEXT NOT NULL,
        doctor_id INTEGER NOT NULL,
        patient_id INTEGER NOT NULL,
        appointment_id INTEGER NOT NULL DEFAULT 0,
        is_synced INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )''');
    } catch (e) {}

    // ======== prescriptions ========
    try {
      db.execute('''CREATE TABLE IF NOT EXISTS prescriptions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medical_exam_id INTEGER NOT NULL,
        medication_id INTEGER NOT NULL,
        dosage TEXT NOT NULL,
        time TEXT NOT NULL,
        medicine TEXT,
        notes TEXT,
        is_synced INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )''');
    } catch (e) {}

    // ======== medications ========
    try {
      db.execute('''CREATE TABLE IF NOT EXISTS medications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        prescription_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        instructions TEXT,
        is_synced INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )''');
    } catch (e) {}

    // ======== appointments - إنشاء الجدول ========
    _createAppointmentsTable(db);
  }

  static void _insertTestUser(Database db) {
    final result = db.select(
      'SELECT * FROM users WHERE username = ?',
      ['admin'],
    );

    if (result.isEmpty) {
      db.execute(
        '''
        INSERT INTO users (username, password, role, isSynced, createdAt)
        VALUES (?, ?, ?, ?, ?)
        ''',
        [
          'admin',
          '1234',
          'doctor',
          1,
          DateTime.now().toIso8601String()
        ],
      );
    }
  }
static void _insertTestDoctors(Database db) {
  final result = db.select('SELECT * FROM doctors');

  if (result.isEmpty) {
    final now = DateTime.now().toIso8601String();

    db.execute('''
      INSERT INTO doctors
      (name, specialty, phone, user_id, is_synced, created_at, updated_at)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [
      'Dr. Ahmad Ali',
      'Dentist',
      '0900000001',
      1,
      1,
      now,
      now
    ]);

    db.execute('''
      INSERT INTO doctors
      (name, specialty, phone, user_id, is_synced, created_at, updated_at)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [
      'Dr. Sara Omar',
      'Cardiology',
      '0900000002',
      1,
      1,
      now,
      now
    ]);

    db.execute('''
      INSERT INTO doctors
      (name, specialty, phone, user_id, is_synced, created_at, updated_at)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [
      'Toka Farawati',
      'General',
      '0900000003',
      1,
      1,
      now,
      now
    ]);
  }
}

}

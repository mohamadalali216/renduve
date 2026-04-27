class AppointmentModel {
  final int? id;

  final String date;        // التاريخ
  final String time;        // الوقت
  final String status;      // الحالة (pending, done, cancelled...)
  final String? notes;      // الملاحظات

  final int doctorId;       // FK -> doctors
  final int patientId;      // FK -> patients
final int nurseId;        // FK -> nurses
  final String? patientName;

  final int isSynced;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  AppointmentModel({
    this.id,
    required this.date,
    required this.time,
    required this.status,
    this.notes,
    required this.doctorId,
    required this.patientId,
required this.nurseId,
    this.patientName,
    this.isSynced = 0,
    String? createdAt,
    String? updatedAt,
    this.deletedAt,
  })  : createdAt = createdAt ?? DateTime.now().toIso8601String(),
        updatedAt = updatedAt ?? DateTime.now().toIso8601String();
        

  /// ================= FROM MAP (SQLite) =================
  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] as int?,
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      status: map['status'] ?? '',
notes: map['notes'],
      patientName: map['patient_name'],
      doctorId: map['doctor_id'] as int,
      patientId: map['patient_id'] as int,
      nurseId: map['nurse_id'] as int,
      isSynced: map['is_synced'] ?? 0,
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      deletedAt: map['deleted_at'],
    );
  }

  /// ================= TO MAP (SQLite) =================
  Map<String, dynamic> toMap({bool includeId = false}) {
    final map = <String, dynamic>{
      'date': date,
      'time': time,
      'status': status,
      'notes': notes,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'nurse_id': nurseId,
      'is_synced': isSynced,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };

    if (includeId && id != null) {
      map['id'] = id;
    }

    return map;
  }

  /// ================= FROM JSON (API) =================
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as int?,
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      status: json['status'] ?? '',
      notes: json['notes'],
      doctorId: json['doctor_id'] as int,
      patientId: json['patient_id'] as int,
      nurseId: json['nurse_id'] as int,
      isSynced: 1,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
    );
  }

  /// ================= TO JSON (API) =================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'status': status,
      'notes': notes,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'nurse_id': nurseId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  /// ================= COPY WITH =================
  AppointmentModel copyWith({
    int? id,
    String? date,
    String? time,
    String? status,
String? notes,
    String? patientName,
    int? doctorId,
    int? patientId,
    int? nurseId,
    int? isSynced,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      nurseId: nurseId ?? this.nurseId,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
    
  }
  DateTime? get dateTime {
  try {
    return DateTime.parse("${date}T${time}");
  } catch (e) {
    return null;
  }
}

  /// ================= MARK AS UPDATED =================
  AppointmentModel markUpdated() {
    return copyWith(
      updatedAt: DateTime.now().toIso8601String(),
      isSynced: 0,
    );
  }

  /// ================= SOFT DELETE =================
  AppointmentModel softDelete() {
    return copyWith(
      deletedAt: DateTime.now().toIso8601String(),
      isSynced: 0,
    );
  }

  /// ================= HELPERS =================
  
  bool get isDeleted => deletedAt != null;
  bool get needsSync => isSynced == 0;
}

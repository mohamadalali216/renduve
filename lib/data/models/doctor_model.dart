class DoctorModel {
  final int? id;
  final String name;
  final String specialty;
  final String phone;
  final int userId;

  final int isSynced; // 0 = not synced, 1 = synced
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  DoctorModel({
    this.id,
    required this.name,
    required this.specialty,
    required this.phone,
    required this.userId,
    this.isSynced = 0,
    String? createdAt,
    String? updatedAt,
    this.deletedAt,
  })  : createdAt = createdAt ?? DateTime.now().toIso8601String(),
        updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  /// ================= FROM MAP (SQLite) =================
  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] as int?,
      name: map['name'] ?? '',
      specialty: map['specialty'] ?? '',
      phone: map['phone'] ?? '',
      userId: map['user_id'] as int,
      isSynced: map['is_synced'] ?? 0,
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      deletedAt: map['deleted_at'],
    );
  }

  /// ================= TO MAP (SQLite) =================
  /// includeId = true فقط أثناء update أو sync
  Map<String, dynamic> toMap({bool includeId = false}) {
    final map = <String, dynamic>{
      'name': name,
      'specialty': specialty,
      'phone': phone,
      'user_id': userId,
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
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as int?,
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      phone: json['phone'] ?? '',
      userId: json['user_id'] as int,
      isSynced: 1, // جاي من السيرفر => متزامن
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
    );
  }

  /// ================= TO JSON (API) =================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'phone': phone,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  /// ================= COPY WITH =================
  DoctorModel copyWith({
    int? id,
    String? name,
    String? specialty,
    String? phone,
    int? userId,
    int? isSynced,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      phone: phone ?? this.phone,
      userId: userId ?? this.userId,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  /// ================= MARK AS UPDATED =================
  DoctorModel markUpdated() {
    return copyWith(
      updatedAt: DateTime.now().toIso8601String(),
      isSynced: 0,
    );
  }

  /// ================= SOFT DELETE =================
  DoctorModel softDelete() {
    return copyWith(
      deletedAt: DateTime.now().toIso8601String(),
      isSynced: 0,
    );
  }

  /// ================= HELPERS =================
  bool get isDeleted => deletedAt != null;
  bool get needsSync => isSynced == 0;
}

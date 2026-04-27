class NurseModel {
  final int? id;

  final String name;
  final String phone;
  final String shift;

  final int userId;

  final int isSynced;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  NurseModel({
    this.id,
    required this.name,
    required this.phone,
    required this.shift,
    required this.userId,
    this.isSynced = 0,
    String? createdAt,
    String? updatedAt,
    this.deletedAt,
  })  : createdAt = createdAt ?? DateTime.now().toIso8601String(),
        updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  /// ================= FROM MAP (SQLite) =================
  factory NurseModel.fromMap(Map<String, dynamic> map) {
    return NurseModel(
      id: map['id'] as int?,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      shift: map['shift'] ?? '',
      userId: map['user_id'] ?? 0,
      isSynced: map['is_synced'] ?? 0,
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      deletedAt: map['deleted_at'],
    );
  }

  /// ================= TO MAP (SQLite) =================
  Map<String, dynamic> toMap({bool includeId = false}) {
    final map = <String, dynamic>{
      'name': name,
      'phone': phone,
      'shift': shift,
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
  factory NurseModel.fromJson(Map<String, dynamic> json) {
    return NurseModel(
      id: json['id'] as int?,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      shift: json['shift'] ?? '',
      userId: json['user_id'] ?? 0,
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
      'name': name,
      'phone': phone,
      'shift': shift,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  /// ================= COPY WITH =================
  NurseModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? shift,
    int? userId,
    int? isSynced,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) {
    return NurseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      shift: shift ?? this.shift,
      userId: userId ?? this.userId,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  /// ================= MARK AS UPDATED =================
  NurseModel markUpdated() {
    return copyWith(
      updatedAt: DateTime.now().toIso8601String(),
      isSynced: 0,
    );
  }

  /// ================= SOFT DELETE =================
  NurseModel softDelete() {
    return copyWith(
      deletedAt: DateTime.now().toIso8601String(),
      isSynced: 0,
    );
  }

  /// ================= HELPERS =================
  bool get isDeleted => deletedAt != null;
  bool get needsSync => isSynced == 0;
}

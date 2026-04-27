class UserModel {
  final int? id;

  final String username;     // اسم المستخدم
  final String password;     // كلمة المرور (يفضل تكون مشفرة من السيرفر)
  final String role;         // الصفة (admin, doctor, nurse...)

  final int isSynced;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  UserModel({
    this.id,
    required this.username,
    required this.password,
    required this.role,
    this.isSynced = 0,
    String? createdAt,
    String? updatedAt,
    this.deletedAt,
  })  : createdAt = createdAt ?? DateTime.now().toIso8601String(),
        updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  /// ================= FROM MAP (SQLite) =================
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? '',
      isSynced: map['isSynced'] ?? 0,
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
      deletedAt: map['deletedAt'],
    );
  }

  /// ================= TO MAP (SQLite) =================
  Map<String, dynamic> toMap({bool includeId = false}) {
    final map = <String, dynamic>{
      'username': username,
      'password': password,
      'role': role,
      'isSynced': isSynced,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };

    if (includeId && id != null) {
      map['id'] = id;
    }

    return map;
  }

  /// ================= FROM JSON (API) =================
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      isSynced: 1,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      deletedAt: json['deletedAt'],
    );
  }

  /// ================= TO JSON (API) =================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'role': role,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }

  /// ================= COPY WITH =================
  UserModel copyWith({
    int? id,
    String? username,
    String? password,
    String? role,
    int? isSynced,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  /// ================= MARK AS UPDATED =================
  UserModel markUpdated() {
    return copyWith(
      updatedAt: DateTime.now().toIso8601String(),
      isSynced: 0,
    );
  }

  /// ================= SOFT DELETE =================
  UserModel softDelete() {
    return copyWith(
      deletedAt: DateTime.now().toIso8601String(),
      isSynced: 0,
    );
  }

  /// ================= HELPERS =================
  bool get isDeleted => deletedAt != null;
  bool get needsSync => isSynced == 0;
}

class PatientModel {
  final int? id;

  final String name;        // الاسم
  final int? age;           // العمر
  final String? gender;     // الجنس
  final String? phone;      // رقم الهاتف
  final String? address;    // العنوان
  final String? city;       // المدينة
  final String? idNumber;   // رقم الهوية

  final int userId;         // FK → ID_USER

  final int isSynced;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  PatientModel({
    this.id,
    required this.name,
    this.age,
    this.gender,
    this.phone,
    this.address,
    this.city,
    this.idNumber,
    required this.userId,
    this.isSynced = 0,
    String? createdAt,
    String? updatedAt,
    this.deletedAt,
  })  : createdAt = createdAt ?? DateTime.now().toIso8601String(),
        updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  /// ================= FROM MAP (SQLite) =================
 factory PatientModel.fromMap(Map<String, dynamic> map) {
  return PatientModel(
    id: map['id'] as int?,
    name: map['name'] ?? '',
    age: map['age'],
    gender: map['gender'],
    phone: map['phone'],
    address: map['address'],
    city: map['city'],
    idNumber: map['idNumber'],
    userId: map['userId'] ?? 0,
    isSynced: map['isSynced'] ?? 0,
    createdAt: map['createdAt'] ?? '',
    updatedAt: map['updatedAt'] ?? '',
    deletedAt: map['deletedAt'],
  );
}

  /// ================= TO MAP (SQLite) =================
  Map<String, dynamic> toMap({bool includeId = false}) {
  final map = <String, dynamic>{
    'name': name,
    'age': age,
    'gender': gender,
    'phone': phone,
    'address': address,
    'city': city,
    'idNumber': idNumber,
    'userId': userId,
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
  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      name: json['name'] ?? '',
      age: json['age'],
      gender: json['gender'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      idNumber: json['id_number'],
      userId: json['user_id'],
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
      'age': age,
      'gender': gender,
      'phone': phone,
      'address': address,
      'city': city,
      'id_number': idNumber,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  /// ================= COPY WITH =================
  PatientModel copyWith({
    int? id,
    String? name,
    int? age,
    String? gender,
    String? phone,
    String? address,
    int? userId,
    int? isSynced,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      userId: userId ?? this.userId,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  /// ================= MARK AS UPDATED =================
  PatientModel markUpdated() {
    return copyWith(
      updatedAt: DateTime.now().toIso8601String(),
      isSynced: 0,
    );
  }

  /// ================= SOFT DELETE =================
  PatientModel softDelete() {
    return copyWith(
      deletedAt: DateTime.now().toIso8601String(),
      isSynced: 0,
    );
  }

  /// ================= HELPERS =================
  bool get isDeleted => deletedAt != null;
  bool get needsSync => isSynced == 0;
}

class UserModel {
  final String id;
  final String email;
  final String? phone;
  final String name;
  final String role; // student, teacher, admin, guest
  final String? profilePicture;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool isVip;
  final DateTime? vipExpiryDate;

  // Student specific
  final String? studentId;
  final String? department;
  final String? classId;
  final String? year;
  final String? semester;

  // Teacher specific
  final String? teacherId;
  final List<String>? subjectsTeaching;
  final bool? isVerified;

  UserModel({
    required this.id,
    required this.email,
    this.phone,
    required this.name,
    required this.role,
    this.profilePicture,
    required this.createdAt,
    this.lastLogin,
    this.isVip = false,
    this.vipExpiryDate,
    this.studentId,
    this.department,
    this.classId,
    this.year,
    this.semester,
    this.teacherId,
    this.subjectsTeaching,
    this.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      name: json['name'] ?? '',
      role: json['role'] ?? 'guest',
      profilePicture: json['profilePicture'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'])
          : null,
      isVip: json['isVip'] ?? false,
      vipExpiryDate: json['vipExpiryDate'] != null
          ? DateTime.parse(json['vipExpiryDate'])
          : null,
      studentId: json['studentId'],
      department: json['department'],
      classId: json['classId'],
      year: json['year'],
      semester: json['semester'],
      teacherId: json['teacherId'],
      subjectsTeaching: json['subjectsTeaching'] != null
          ? List<String>.from(json['subjectsTeaching'])
          : null,
      isVerified: json['isVerified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'name': name,
      'role': role,
      'profilePicture': profilePicture,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'isVip': isVip,
      'vipExpiryDate': vipExpiryDate?.toIso8601String(),
      'studentId': studentId,
      'department': department,
      'classId': classId,
      'year': year,
      'semester': semester,
      'teacherId': teacherId,
      'subjectsTeaching': subjectsTeaching,
      'isVerified': isVerified,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? phone,
    String? name,
    String? role,
    String? profilePicture,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isVip,
    DateTime? vipExpiryDate,
    String? studentId,
    String? department,
    String? classId,
    String? year,
    String? semester,
    String? teacherId,
    List<String>? subjectsTeaching,
    bool? isVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      role: role ?? this.role,
      profilePicture: profilePicture ?? this.profilePicture,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isVip: isVip ?? this.isVip,
      vipExpiryDate: vipExpiryDate ?? this.vipExpiryDate,
      studentId: studentId ?? this.studentId,
      department: department ?? this.department,
      classId: classId ?? this.classId,
      year: year ?? this.year,
      semester: semester ?? this.semester,
      teacherId: teacherId ?? this.teacherId,
      subjectsTeaching: subjectsTeaching ?? this.subjectsTeaching,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

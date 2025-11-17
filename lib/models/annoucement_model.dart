class AnnouncementModel {
  final String id;
  final String title;
  final String message;
  final String authorId;
  final String authorName;
  final String authorRole;
  final DateTime createdAt;
  final List<String> targetAudience; // classIds or 'all'
  final String? attachmentUrl;
  final bool isPinned;
  final int priority; // 1-3 (high-low)

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.message,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.createdAt,
    required this.targetAudience,
    this.attachmentUrl,
    this.isPinned = false,
    this.priority = 2,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      authorRole: json['authorRole'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      targetAudience: json['targetAudience'] != null
          ? List<String>.from(json['targetAudience'])
          : [],
      attachmentUrl: json['attachmentUrl'],
      isPinned: json['isPinned'] ?? false,
      priority: json['priority'] ?? 2,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'authorId': authorId,
      'authorName': authorName,
      'authorRole': authorRole,
      'createdAt': createdAt.toIso8601String(),
      'targetAudience': targetAudience,
      'attachmentUrl': attachmentUrl,
      'isPinned': isPinned,
      'priority': priority,
    };
  }
}

class ClassModel {
  final String id;
  final String name;
  final String departmentId;
  final String year;
  final String semester;
  final List<String> subjectIds;
  final int totalStudents;

  ClassModel({
    required this.id,
    required this.name,
    required this.departmentId,
    required this.year,
    required this.semester,
    required this.subjectIds,
    this.totalStudents = 0,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      departmentId: json['departmentId'] ?? '',
      year: json['year'] ?? '',
      semester: json['semester'] ?? '',
      subjectIds: json['subjectIds'] != null
          ? List<String>.from(json['subjectIds'])
          : [],
      totalStudents: json['totalStudents'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'departmentId': departmentId,
      'year': year,
      'semester': semester,
      'subjectIds': subjectIds,
      'totalStudents': totalStudents,
    };
  }
}

class SubjectModel {
  final String id;
  final String name;
  final String code;
  final String departmentId;
  final int credits;
  final String? description;

  SubjectModel({
    required this.id,
    required this.name,
    required this.code,
    required this.departmentId,
    required this.credits,
    this.description,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      departmentId: json['departmentId'] ?? '',
      credits: json['credits'] ?? 0,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'departmentId': departmentId,
      'credits': credits,
      'description': description,
    };
  }
}

class DepartmentModel {
  final String id;
  final String name;
  final String code;
  final String? description;
  final String? headOfDepartment;

  DepartmentModel({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    this.headOfDepartment,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'],
      headOfDepartment: json['headOfDepartment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'headOfDepartment': headOfDepartment,
    };
  }
}

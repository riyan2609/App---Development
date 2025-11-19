class AttendanceModel {
  final String id;
  final String studentId;
  final String classId;
  final String subjectId;
  final String subjectName;
  final DateTime date;
  final String status; // present, absent, late
  final String? teacherId;
  final String? teacherName;
  final String? lectureTime;
  final String? roomNumber;
  final String? remarks;
  final DateTime markedAt;

  AttendanceModel({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.subjectId,
    required this.subjectName,
    required this.date,
    required this.status,
    this.teacherId,
    this.teacherName,
    this.lectureTime,
    this.roomNumber,
    this.remarks,
    required this.markedAt,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      classId: json['classId'] ?? '',
      subjectId: json['subjectId'] ?? '',
      subjectName: json['subjectName'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      status: json['status'] ?? 'absent',
      teacherId: json['teacherId'],
      teacherName: json['teacherName'],
      lectureTime: json['lectureTime'],
      roomNumber: json['roomNumber'],
      remarks: json['remarks'],
      markedAt: json['markedAt'] != null
          ? DateTime.parse(json['markedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'classId': classId,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'date': date.toIso8601String(),
      'status': status,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'lectureTime': lectureTime,
      'roomNumber': roomNumber,
      'remarks': remarks,
      'markedAt': markedAt.toIso8601String(),
    };
  }

  AttendanceModel copyWith({
    String? id,
    String? studentId,
    String? classId,
    String? subjectId,
    String? subjectName,
    DateTime? date,
    String? status,
    String? teacherId,
    String? teacherName,
    String? lectureTime,
    String? roomNumber,
    String? remarks,
    DateTime? markedAt,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      classId: classId ?? this.classId,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      date: date ?? this.date,
      status: status ?? this.status,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      lectureTime: lectureTime ?? this.lectureTime,
      roomNumber: roomNumber ?? this.roomNumber,
      remarks: remarks ?? this.remarks,
      markedAt: markedAt ?? this.markedAt,
    );
  }
}

class AttendanceSummary {
  final int totalLectures;
  final int present;
  final int absent;
  final int late;
  final double percentage;
  final Map<String, SubjectAttendance> subjectWise;

  AttendanceSummary({
    required this.totalLectures,
    required this.present,
    required this.absent,
    required this.late,
    required this.percentage,
    required this.subjectWise,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    Map<String, SubjectAttendance> subjectWiseMap = {};
    if (json['subjectWise'] != null) {
      (json['subjectWise'] as Map<String, dynamic>).forEach((key, value) {
        subjectWiseMap[key] = SubjectAttendance.fromJson(value);
      });
    }

    return AttendanceSummary(
      totalLectures: json['totalLectures'] ?? 0,
      present: json['present'] ?? 0,
      absent: json['absent'] ?? 0,
      late: json['late'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
      subjectWise: subjectWiseMap,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> subjectWiseJson = {};
    subjectWise.forEach((key, value) {
      subjectWiseJson[key] = value.toJson();
    });

    return {
      'totalLectures': totalLectures,
      'present': present,
      'absent': absent,
      'late': late,
      'percentage': percentage,
      'subjectWise': subjectWiseJson,
    };
  }
}

class SubjectAttendance {
  final String subjectId;
  final String subjectName;
  final int total;
  final int present;
  final int absent;
  final int late;
  final double percentage;

  SubjectAttendance({
    required this.subjectId,
    required this.subjectName,
    required this.total,
    required this.present,
    required this.absent,
    required this.late,
    required this.percentage,
  });

  factory SubjectAttendance.fromJson(Map<String, dynamic> json) {
    return SubjectAttendance(
      subjectId: json['subjectId'] ?? '',
      subjectName: json['subjectName'] ?? '',
      total: json['total'] ?? 0,
      present: json['present'] ?? 0,
      absent: json['absent'] ?? 0,
      late: json['late'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjectId': subjectId,
      'subjectName': subjectName,
      'total': total,
      'present': present,
      'absent': absent,
      'late': late,
      'percentage': percentage,
    };
  }
}

class TimetableModel {
  final String id;
  final String classId;
  final String subjectId;
  final String subjectName;
  final String teacherId;
  final String teacherName;
  final int dayOfWeek; // 1-7 (Monday-Sunday)
  final String startTime;
  final String endTime;
  final String roomNumber;
  final String? notes;

  TimetableModel({
    required this.id,
    required this.classId,
    required this.subjectId,
    required this.subjectName,
    required this.teacherId,
    required this.teacherName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.roomNumber,
    this.notes,
  });

  factory TimetableModel.fromJson(Map<String, dynamic> json) {
    return TimetableModel(
      id: json['id'] ?? '',
      classId: json['classId'] ?? '',
      subjectId: json['subjectId'] ?? '',
      subjectName: json['subjectName'] ?? '',
      teacherId: json['teacherId'] ?? '',
      teacherName: json['teacherName'] ?? '',
      dayOfWeek: json['dayOfWeek'] ?? 1,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classId': classId,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'roomNumber': roomNumber,
      'notes': notes,
    };
  }

  String getDayName() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dayOfWeek - 1];
  }
}

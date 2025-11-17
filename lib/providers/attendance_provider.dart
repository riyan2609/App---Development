import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attendance_model.dart';
import '../core/constants/app_constants.dart';

class AttendanceProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<AttendanceModel> _attendanceList = [];
  AttendanceSummary? _attendanceSummary;
  bool _isLoading = false;
  String? _errorMessage;

  List<AttendanceModel> get attendanceList => _attendanceList;
  AttendanceSummary? get attendanceSummary => _attendanceSummary;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load student attendance
  Future<void> loadStudentAttendance(
    String studentId, {
    DateTime? month,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      DateTime startDate = month ?? DateTime.now();
      DateTime monthStart = DateTime(startDate.year, startDate.month, 1);
      DateTime monthEnd = DateTime(startDate.year, startDate.month + 1, 0);

      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.attendanceCollection)
          .where('studentId', isEqualTo: studentId)
          .where('date', isGreaterThanOrEqualTo: monthStart)
          .where('date', isLessThanOrEqualTo: monthEnd)
          .orderBy('date', descending: true)
          .get();

      _attendanceList = snapshot.docs
          .map(
            (doc) =>
                AttendanceModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();

      _calculateAttendanceSummary();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load attendance');
      _setLoading(false);
    }
  }

  // Calculate attendance summary
  void _calculateAttendanceSummary() {
    int totalLectures = _attendanceList.length;
    int present = _attendanceList
        .where((a) => a.status == AppConstants.statusPresent)
        .length;
    int absent = _attendanceList
        .where((a) => a.status == AppConstants.statusAbsent)
        .length;
    int late = _attendanceList
        .where((a) => a.status == AppConstants.statusLate)
        .length;

    double percentage = totalLectures > 0 ? (present / totalLectures) * 100 : 0;

    // Calculate subject-wise attendance
    Map<String, SubjectAttendance> subjectWise = {};
    for (var attendance in _attendanceList) {
      String subjectId = attendance.subjectId;

      if (subjectWise.containsKey(subjectId)) {
        var subject = subjectWise[subjectId]!;
        int newTotal = subject.total + 1;
        int newPresent =
            subject.present +
            (attendance.status == AppConstants.statusPresent ? 1 : 0);
        int newAbsent =
            subject.absent +
            (attendance.status == AppConstants.statusAbsent ? 1 : 0);
        int newLate =
            subject.late +
            (attendance.status == AppConstants.statusLate ? 1 : 0);
        double newPercentage = (newPresent / newTotal) * 100;

        subjectWise[subjectId] = SubjectAttendance(
          subjectId: subjectId,
          subjectName: attendance.subjectName,
          total: newTotal,
          present: newPresent,
          absent: newAbsent,
          late: newLate,
          percentage: newPercentage,
        );
      } else {
        subjectWise[subjectId] = SubjectAttendance(
          subjectId: subjectId,
          subjectName: attendance.subjectName,
          total: 1,
          present: attendance.status == AppConstants.statusPresent ? 1 : 0,
          absent: attendance.status == AppConstants.statusAbsent ? 1 : 0,
          late: attendance.status == AppConstants.statusLate ? 1 : 0,
          percentage: attendance.status == AppConstants.statusPresent ? 100 : 0,
        );
      }
    }

    _attendanceSummary = AttendanceSummary(
      totalLectures: totalLectures,
      present: present,
      absent: absent,
      late: late,
      percentage: percentage,
      subjectWise: subjectWise,
    );
  }

  // Mark attendance (Teacher)
  Future<bool> markAttendance({
    required String studentId,
    required String classId,
    required String subjectId,
    required String subjectName,
    required String status,
    String? teacherId,
    String? teacherName,
    String? lectureTime,
    String? roomNumber,
    String? remarks,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      String attendanceId =
          '${studentId}_${subjectId}_${DateTime.now().millisecondsSinceEpoch}';

      AttendanceModel attendance = AttendanceModel(
        id: attendanceId,
        studentId: studentId,
        classId: classId,
        subjectId: subjectId,
        subjectName: subjectName,
        date: DateTime.now(),
        status: status,
        teacherId: teacherId,
        teacherName: teacherName,
        lectureTime: lectureTime,
        roomNumber: roomNumber,
        remarks: remarks,
        markedAt: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.attendanceCollection)
          .doc(attendanceId)
          .set(attendance.toJson());

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to mark attendance');
      _setLoading(false);
      return false;
    }
  }

  // Bulk mark attendance
  Future<bool> bulkMarkAttendance({
    required List<String> studentIds,
    required String classId,
    required String subjectId,
    required String subjectName,
    required String status,
    String? teacherId,
    String? teacherName,
    String? lectureTime,
    String? roomNumber,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      WriteBatch batch = _firestore.batch();

      for (String studentId in studentIds) {
        String attendanceId =
            '${studentId}_${subjectId}_${DateTime.now().millisecondsSinceEpoch}';

        AttendanceModel attendance = AttendanceModel(
          id: attendanceId,
          studentId: studentId,
          classId: classId,
          subjectId: subjectId,
          subjectName: subjectName,
          date: DateTime.now(),
          status: status,
          teacherId: teacherId,
          teacherName: teacherName,
          lectureTime: lectureTime,
          roomNumber: roomNumber,
          markedAt: DateTime.now(),
        );

        batch.set(
          _firestore
              .collection(AppConstants.attendanceCollection)
              .doc(attendanceId),
          attendance.toJson(),
        );
      }

      await batch.commit();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to mark bulk attendance');
      _setLoading(false);
      return false;
    }
  }

  // Get attendance for specific date
  Future<List<AttendanceModel>> getAttendanceByDate(
    String studentId,
    DateTime date,
  ) async {
    try {
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.attendanceCollection)
          .where('studentId', isEqualTo: studentId)
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThanOrEqualTo: endOfDay)
          .get();

      return snapshot.docs
          .map(
            (doc) =>
                AttendanceModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get class attendance report (Teacher)
  Future<List<AttendanceModel>> getClassAttendance(
    String classId,
    String subjectId,
    DateTime date,
  ) async {
    try {
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.attendanceCollection)
          .where('classId', isEqualTo: classId)
          .where('subjectId', isEqualTo: subjectId)
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThanOrEqualTo: endOfDay)
          .get();

      return snapshot.docs
          .map(
            (doc) =>
                AttendanceModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}

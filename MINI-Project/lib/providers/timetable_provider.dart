import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/timetable_model.dart';
import '../core/constants/app_constants.dart';

class TimetableProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<TimetableModel> _timetable = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TimetableModel> get timetable => _timetable;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load timetable for class
  Future<void> loadTimetable(String classId) async {
    try {
      _setLoading(true);

      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.timetableCollection)
          .where('classId', isEqualTo: classId)
          .orderBy('dayOfWeek')
          .orderBy('startTime')
          .get();

      _timetable = snapshot.docs
          .map(
            (doc) =>
                TimetableModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to load timetable');
      _setLoading(false);
    }
  }

  // Get today's classes
  List<TimetableModel> getTodayClasses() {
    int today = DateTime.now().weekday;
    return _timetable.where((t) => t.dayOfWeek == today).toList();
  }

  // Get classes by day
  List<TimetableModel> getClassesByDay(int dayOfWeek) {
    return _timetable.where((t) => t.dayOfWeek == dayOfWeek).toList();
  }

  // Add/Update timetable entry (Teacher/Admin)
  Future<bool> saveTimetableEntry(TimetableModel timetableEntry) async {
    try {
      _setLoading(true);

      await _firestore
          .collection(AppConstants.timetableCollection)
          .doc(timetableEntry.id)
          .set(timetableEntry.toJson());

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to save timetable entry');
      _setLoading(false);
      return false;
    }
  }

  // Delete timetable entry
  Future<bool> deleteTimetableEntry(String entryId) async {
    try {
      _setLoading(true);

      await _firestore
          .collection(AppConstants.timetableCollection)
          .doc(entryId)
          .delete();

      _timetable.removeWhere((t) => t.id == entryId);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete timetable entry');
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
}

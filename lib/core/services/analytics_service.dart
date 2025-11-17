import '../constants/app_constants.dart';

class AnalyticsService {
  // Predict attendance shortage
  static Map<String, dynamic> predictAttendanceShortage(
    int present,
    int total,
    int remainingLectures,
  ) {
    double currentPercentage = (present / total) * 100;
    double targetPercentage = AppConstants.attendanceWarningThreshold;

    // Calculate required attendance
    int requiredPresent =
        ((targetPercentage * (total + remainingLectures)) / 100).ceil();
    int mustAttend = requiredPresent - present;

    // Calculate how many can be missed
    int canMiss = 0;
    for (int i = 0; i <= remainingLectures; i++) {
      double newPercentage =
          ((present + remainingLectures - i) / (total + remainingLectures)) *
          100;
      if (newPercentage >= targetPercentage) {
        canMiss = i;
      } else {
        break;
      }
    }

    return {
      'currentPercentage': currentPercentage,
      'mustAttend': mustAttend > 0 ? mustAttend : 0,
      'canMiss': canMiss,
      'isAtRisk': currentPercentage < targetPercentage,
      'remainingLectures': remainingLectures,
      'status': _getAttendanceStatus(currentPercentage),
    };
  }

  // Get attendance status
  static String _getAttendanceStatus(double percentage) {
    if (percentage >= AppConstants.attendanceWarningThreshold) {
      return 'good';
    } else if (percentage >= AppConstants.attendanceDangerThreshold) {
      return 'warning';
    } else {
      return 'critical';
    }
  }

  // Calculate attendance trends
  static List<Map<String, dynamic>> calculateWeeklyTrend(
    List<Map<String, dynamic>> attendanceData,
  ) {
    Map<int, Map<String, int>> weeklyData = {};

    for (var record in attendanceData) {
      DateTime date = record['date'] as DateTime;
      int weekNumber = _getWeekNumber(date);

      if (!weeklyData.containsKey(weekNumber)) {
        weeklyData[weekNumber] = {'present': 0, 'absent': 0, 'total': 0};
      }

      weeklyData[weekNumber]!['total'] = weeklyData[weekNumber]!['total']! + 1;

      if (record['status'] == AppConstants.statusPresent) {
        weeklyData[weekNumber]!['present'] =
            weeklyData[weekNumber]!['present']! + 1;
      } else {
        weeklyData[weekNumber]!['absent'] =
            weeklyData[weekNumber]!['absent']! + 1;
      }
    }

    return weeklyData.entries.map((entry) {
      int present = entry.value['present']!;
      int total = entry.value['total']!;
      double percentage = total > 0 ? (present / total) * 100 : 0;

      return {
        'week': entry.key,
        'percentage': percentage,
        'present': present,
        'absent': entry.value['absent'],
        'total': total,
      };
    }).toList();
  }

  // Get week number
  static int _getWeekNumber(DateTime date) {
    int dayOfYear = int.parse(
      date.difference(DateTime(date.year, 1, 1)).inDays.toString(),
    );
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  // Subject weakness analysis
  static List<Map<String, dynamic>> analyzeSubjectWeakness(
    Map<String, dynamic> subjectWiseAttendance,
  ) {
    List<Map<String, dynamic>> weakSubjects = [];

    subjectWiseAttendance.forEach((subjectId, data) {
      double percentage = data['percentage'] ?? 0.0;

      if (percentage < AppConstants.attendanceWarningThreshold) {
        weakSubjects.add({
          'subjectId': subjectId,
          'subjectName': data['subjectName'],
          'percentage': percentage,
          'present': data['present'],
          'total': data['total'],
          'severity': _getSeverity(percentage),
        });
      }
    });

    // Sort by severity (lowest percentage first)
    weakSubjects.sort((a, b) => a['percentage'].compareTo(b['percentage']));

    return weakSubjects;
  }

  static String _getSeverity(double percentage) {
    if (percentage < AppConstants.attendanceDangerThreshold) {
      return 'critical';
    } else if (percentage < AppConstants.attendanceWarningThreshold) {
      return 'warning';
    } else {
      return 'good';
    }
  }

  // Monthly comparison
  static Map<String, dynamic> compareMonthlyAttendance(
    List<Map<String, dynamic>> currentMonth,
    List<Map<String, dynamic>> previousMonth,
  ) {
    double currentPercentage = _calculateAveragePercentage(currentMonth);
    double previousPercentage = _calculateAveragePercentage(previousMonth);

    double change = currentPercentage - previousPercentage;

    return {
      'currentMonth': currentPercentage,
      'previousMonth': previousPercentage,
      'change': change,
      'trend': change > 0
          ? 'improving'
          : change < 0
          ? 'declining'
          : 'stable',
    };
  }

  static double _calculateAveragePercentage(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 0.0;

    int totalPresent = 0;
    int totalLectures = 0;

    for (var record in data) {
      totalLectures++;
      if (record['status'] == AppConstants.statusPresent) {
        totalPresent++;
      }
    }

    return totalLectures > 0 ? (totalPresent / totalLectures) * 100 : 0.0;
  }

  // Best and worst days analysis
  static Map<String, dynamic> analyzeBestWorstDays(
    List<Map<String, dynamic>> attendanceData,
  ) {
    Map<int, Map<String, int>> dayWiseData = {
      1: {'present': 0, 'total': 0},
      2: {'present': 0, 'total': 0},
      3: {'present': 0, 'total': 0},
      4: {'present': 0, 'total': 0},
      5: {'present': 0, 'total': 0},
      6: {'present': 0, 'total': 0},
      7: {'present': 0, 'total': 0},
    };

    for (var record in attendanceData) {
      DateTime date = record['date'] as DateTime;
      int dayOfWeek = date.weekday;

      dayWiseData[dayOfWeek]!['total'] = dayWiseData[dayOfWeek]!['total']! + 1;

      if (record['status'] == AppConstants.statusPresent) {
        dayWiseData[dayOfWeek]!['present'] =
            dayWiseData[dayOfWeek]!['present']! + 1;
      }
    }

    // Calculate percentages
    Map<String, dynamic> dayPercentages = {};
    dayWiseData.forEach((day, data) {
      int present = data['present']!;
      int total = data['total']!;
      double percentage = total > 0 ? (present / total) * 100 : 0;

      String dayName = _getDayName(day);
      dayPercentages[dayName] = {
        'percentage': percentage,
        'present': present,
        'total': total,
      };
    });

    // Find best and worst days
    String bestDay = '';
    String worstDay = '';
    double maxPercentage = 0;
    double minPercentage = 100;

    dayPercentages.forEach((day, data) {
      double percentage = data['percentage'];
      if (data['total'] > 0) {
        if (percentage > maxPercentage) {
          maxPercentage = percentage;
          bestDay = day;
        }
        if (percentage < minPercentage) {
          minPercentage = percentage;
          worstDay = day;
        }
      }
    });

    return {
      'bestDay': bestDay,
      'worstDay': worstDay,
      'dayWiseData': dayPercentages,
    };
  }

  static String _getDayName(int day) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[day - 1];
  }
}

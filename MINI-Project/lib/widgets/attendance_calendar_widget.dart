import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../core/constants/app_constants.dart';

class AttendanceCalendarWidget extends StatefulWidget {
  const AttendanceCalendarWidget({super.key});

  @override
  State<AttendanceCalendarWidget> createState() =>
      _AttendanceCalendarWidgetState();
}

class _AttendanceCalendarWidgetState extends State<AttendanceCalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Mock data - replace with actual attendance data
  final Map<DateTime, String> _attendanceData = {
    DateTime.now().subtract(const Duration(days: 1)): 'present',
    DateTime.now().subtract(const Duration(days: 2)): 'absent',
    DateTime.now().subtract(const Duration(days: 3)): 'present',
    DateTime.now().subtract(const Duration(days: 4)): 'late',
    DateTime.now().subtract(const Duration(days: 5)): 'present',
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: AppConstants.primaryColor,
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: AppConstants.successColor,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final status = _getAttendanceStatus(day);
                  if (status != null) {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  String? _getAttendanceStatus(DateTime day) {
    for (var entry in _attendanceData.entries) {
      if (isSameDay(entry.key, day)) {
        return entry.value;
      }
    }
    return null;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'present':
        return AppConstants.presentColor;
      case 'absent':
        return AppConstants.absentColor;
      case 'late':
        return AppConstants.lateColor;
      default:
        return Colors.grey;
    }
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem('Present', AppConstants.presentColor),
        _buildLegendItem('Absent', AppConstants.absentColor),
        _buildLegendItem('Late', AppConstants.lateColor),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

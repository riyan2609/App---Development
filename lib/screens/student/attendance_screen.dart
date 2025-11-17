import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/attendance_calendar_widget.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String? _selectedSubject;

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final attendanceProvider = Provider.of<AttendanceProvider>(
      context,
      listen: false,
    );

    if (authProvider.currentUser != null) {
      await attendanceProvider.loadStudentAttendance(
        authProvider.currentUser!.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter dialog
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAttendance,
        child: Consumer<AttendanceProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overall Stats
                  _buildOverallStats(provider),
                  const SizedBox(height: 20),

                  // Calendar
                  const Text(
                    'Attendance Calendar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const AttendanceCalendarWidget(),
                  const SizedBox(height: 20),

                  // Subject Filter
                  _buildSubjectFilter(provider),
                  const SizedBox(height: 20),

                  // Attendance List
                  _buildAttendanceList(provider),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOverallStats(AttendanceProvider provider) {
    final summary = provider.attendanceSummary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStat(
              'Present',
              '${summary?.present ?? 0}',
              AppConstants.presentColor,
            ),
            _buildStat(
              'Absent',
              '${summary?.absent ?? 0}',
              AppConstants.absentColor,
            ),
            _buildStat('Late', '${summary?.late ?? 0}', AppConstants.lateColor),
            _buildStat('Total', '${summary?.totalLectures ?? 0}', Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildSubjectFilter(AttendanceProvider provider) {
    final subjects =
        provider.attendanceSummary?.subjectWise.values.toList() ?? [];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: subjects.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: const Text('All'),
                selected: _selectedSubject == null,
                onSelected: (selected) {
                  setState(() {
                    _selectedSubject = null;
                  });
                },
              ),
            );
          }

          final subject = subjects[index - 1];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(subject.subjectName),
              selected: _selectedSubject == subject.subjectId,
              onSelected: (selected) {
                setState(() {
                  _selectedSubject = selected ? subject.subjectId : null;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAttendanceList(AttendanceProvider provider) {
    var attendanceList = provider.attendanceList;

    if (_selectedSubject != null) {
      attendanceList = attendanceList
          .where((a) => a.subjectId == _selectedSubject)
          .toList();
    }

    if (attendanceList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No attendance records found'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attendanceList.length,
      itemBuilder: (context, index) {
        final attendance = attendanceList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(
                attendance.status,
              ).withOpacity(0.1),
              child: Icon(
                _getStatusIcon(attendance.status),
                color: _getStatusColor(attendance.status),
              ),
            ),
            title: Text(
              attendance.subjectName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              '${attendance.date.toString().split(' ')[0]}\n${attendance.teacherName ?? ""}',
            ),
            isThreeLine: true,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(attendance.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                attendance.status.toUpperCase(),
                style: TextStyle(
                  color: _getStatusColor(attendance.status),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case AppConstants.statusPresent:
        return AppConstants.presentColor;
      case AppConstants.statusAbsent:
        return AppConstants.absentColor;
      case AppConstants.statusLate:
        return AppConstants.lateColor;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case AppConstants.statusPresent:
        return Icons.check_circle;
      case AppConstants.statusAbsent:
        return Icons.cancel;
      case AppConstants.statusLate:
        return Icons.access_time;
      default:
        return Icons.help;
    }
  }
}

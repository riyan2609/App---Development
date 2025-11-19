import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/custom_button.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  String? _selectedClass;
  String? _selectedSubject;
  final Map<String, String> _studentAttendance = {};
  bool _showStudentList = false;

  // Mock data
  final List<String> _classes = [
    'B.Tech 1st Year',
    'B.Tech 2nd Year',
    'B.Tech 3rd Year',
  ];
  final List<String> _subjects = [
    'Computer Science',
    'Data Structures',
    'Algorithms',
  ];
  final List<Map<String, String>> _students = [
    {'id': '1', 'name': 'John Doe', 'rollNo': '101'},
    {'id': '2', 'name': 'Jane Smith', 'rollNo': '102'},
    {'id': '3', 'name': 'Mike Johnson', 'rollNo': '103'},
    {'id': '4', 'name': 'Sarah Williams', 'rollNo': '104'},
    {'id': '5', 'name': 'David Brown', 'rollNo': '105'},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize all students as present by default
    for (var student in _students) {
      _studentAttendance[student['id']!] = AppConstants.statusPresent;
    }
  }

  void _markAllPresent() {
    setState(() {
      for (var student in _students) {
        _studentAttendance[student['id']!] = AppConstants.statusPresent;
      }
    });
  }

  void _markAllAbsent() {
    setState(() {
      for (var student in _students) {
        _studentAttendance[student['id']!] = AppConstants.statusAbsent;
      }
    });
  }

  Future<void> _submitAttendance() async {
    if (_selectedClass == null || _selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select class and subject'),
          backgroundColor: AppConstants.errorColor,
        ),
      );
      return;
    }

    final attendanceProvider = Provider.of<AttendanceProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Here you would call the bulk mark attendance
    bool success = await attendanceProvider.bulkMarkAttendance(
      studentIds: _students.map((s) => s['id']!).toList(),
      classId: 'class_1',
      subjectId: 'subject_1',
      subjectName: _selectedSubject!,
      status: AppConstants.statusPresent,
      teacherId: authProvider.currentUser?.id,
      teacherName: authProvider.currentUser?.name,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attendance marked successfully'),
          backgroundColor: AppConstants.successColor,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mark Attendance')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Class Selection
            _buildDropdown(
              label: 'Select Class',
              value: _selectedClass,
              items: _classes,
              onChanged: (value) {
                setState(() {
                  _selectedClass = value;
                  _showStudentList =
                      _selectedClass != null && _selectedSubject != null;
                });
              },
            ),
            const SizedBox(height: 20),

            // Subject Selection
            _buildDropdown(
              label: 'Select Subject',
              value: _selectedSubject,
              items: _subjects,
              onChanged: (value) {
                setState(() {
                  _selectedSubject = value;
                  _showStudentList =
                      _selectedClass != null && _selectedSubject != null;
                });
              },
            ),
            const SizedBox(height: 20),

            if (_showStudentList) ...[
              // Bulk Actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _markAllPresent,
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Mark All Present'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.successColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _markAllAbsent,
                      icon: const Icon(Icons.cancel),
                      label: const Text('Mark All Absent'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.errorColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Student List
              Card(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Students (${_students.length})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total Present: ${_studentAttendance.values.where((s) => s == AppConstants.statusPresent).length}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.successColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _students.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final student = _students[index];
                        final status = _studentAttendance[student['id']]!;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppConstants.primaryColor
                                .withOpacity(0.1),
                            child: Text(
                              student['rollNo']!,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.primaryColor,
                              ),
                            ),
                          ),
                          title: Text(
                            student['name']!,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('Roll No: ${student['rollNo']}'),
                          trailing: _buildStatusButtons(student['id']!, status),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Submit Button
              CustomButton(
                text: 'Submit Attendance',
                onPressed: _submitAttendance,
                icon: Icons.check_circle,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text('Select $label'),
              items: items.map((item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusButtons(String studentId, String status) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStatusButton(
          studentId,
          AppConstants.statusPresent,
          Icons.check_circle,
          AppConstants.presentColor,
          status == AppConstants.statusPresent,
        ),
        const SizedBox(width: 8),
        _buildStatusButton(
          studentId,
          AppConstants.statusAbsent,
          Icons.cancel,
          AppConstants.absentColor,
          status == AppConstants.statusAbsent,
        ),
        const SizedBox(width: 8),
        _buildStatusButton(
          studentId,
          AppConstants.statusLate,
          Icons.access_time,
          AppConstants.lateColor,
          status == AppConstants.statusLate,
        ),
      ],
    );
  }

  Widget _buildStatusButton(
    String studentId,
    String statusValue,
    IconData icon,
    Color color,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          _studentAttendance[studentId] = statusValue;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: isSelected ? Colors.white : color),
      ),
    );
  }
}

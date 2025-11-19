import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../providers/auth_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/attendance_calendar_widget.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
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
        title: const Text('Dashboard'),
        actions: [
          // VIP Badge
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.currentUser?.isVip ?? false) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppConstants.vipGradientStart,
                          AppConstants.vipGradientEnd,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.stars, size: 16, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'VIP',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.workspace_premium_outlined),
                onPressed: () => Get.toNamed(AppRoutes.vip),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigate to notifications
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Consumer2<AuthProvider, AttendanceProvider>(
          builder: (context, authProvider, attendanceProvider, child) {
            final user = authProvider.currentUser;
            final summary = attendanceProvider.attendanceSummary;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  _buildWelcomeCard(user?.name ?? 'Student'),
                  const SizedBox(height: 20),

                  // Overall Attendance
                  _buildOverallAttendance(summary?.percentage ?? 0),
                  const SizedBox(height: 20),

                  // Quick Stats
                  _buildQuickStats(summary),
                  const SizedBox(height: 20),

                  // Today's Status
                  _buildTodayStatus(),
                  const SizedBox(height: 20),

                  // Subject-wise Attendance
                  if (summary != null && summary.subjectWise.isNotEmpty) ...[
                    _buildSectionHeader('Subject-wise Attendance'),
                    const SizedBox(height: 10),
                    _buildSubjectWiseAttendance(summary.subjectWise),
                    const SizedBox(height: 20),
                  ],

                  // Attendance Calendar
                  _buildSectionHeader('Monthly Calendar'),
                  const SizedBox(height: 10),
                  const AttendanceCalendarWidget(),
                  const SizedBox(height: 20),

                  // Upcoming Lectures
                  _buildSectionHeader('Upcoming Lectures'),
                  const SizedBox(height: 10),
                  _buildUpcomingLectures(),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          switch (index) {
            case 0:
              // Already on dashboard
              break;
            case 1:
              Get.toNamed(AppRoutes.attendance);
              break;
            case 2:
              Get.toNamed(AppRoutes.timetable);
              break;
            case 3:
              Get.toNamed(AppRoutes.profile);
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_reg_outlined),
            activeIcon: Icon(Icons.how_to_reg),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Timetable',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(String name) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryColor,
            AppConstants.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello,',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  DateTime.now().toString().split(' ')[0],
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const Icon(Icons.school_rounded, size: 60, color: Colors.white24),
        ],
      ),
    );
  }

  Widget _buildOverallAttendance(double percentage) {
    Color getColor() {
      if (percentage >= AppConstants.attendanceWarningThreshold) {
        return AppConstants.successColor;
      } else if (percentage >= AppConstants.attendanceDangerThreshold) {
        return AppConstants.warningColor;
      }
      return AppConstants.errorColor;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Overall Attendance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            CircularPercentIndicator(
              radius: 80,
              lineWidth: 12,
              percent: percentage / 100,
              center: Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: getColor(),
                ),
              ),
              progressColor: getColor(),
              backgroundColor: Colors.grey[200]!,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(height: 15),
            Text(
              percentage >= AppConstants.attendanceWarningThreshold
                  ? 'Great! Keep it up!'
                  : percentage >= AppConstants.attendanceDangerThreshold
                  ? 'Warning: Attendance is low'
                  : 'Danger: Attendance critical!',
              style: TextStyle(color: getColor(), fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(summary) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Present',
            value: '${summary?.present ?? 0}',
            icon: Icons.check_circle_outline,
            color: AppConstants.successColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'Absent',
            value: '${summary?.absent ?? 0}',
            icon: Icons.cancel_outlined,
            color: AppConstants.errorColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'Late',
            value: '${summary?.late ?? 0}',
            icon: Icons.access_time,
            color: AppConstants.warningColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTodayStatus() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Status",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Present',
                    style: TextStyle(
                      color: AppConstants.successColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              '5 out of 6 lectures attended',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectWiseAttendance(Map<String, dynamic> subjectWise) {
    return Column(
      children: subjectWise.entries.map((entry) {
        final subject = entry.value;
        final percentage = subject.percentage ?? 0.0;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
              child: const Icon(
                Icons.book_outlined,
                color: AppConstants.primaryColor,
              ),
            ),
            title: Text(
              subject.subjectName ?? 'Subject',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('${subject.present}/${subject.total} lectures'),
            trailing: Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: percentage >= 75
                    ? AppConstants.successColor
                    : AppConstants.errorColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUpcomingLectures() {
    return Card(
      child: Column(
        children: [
          _buildLectureItem(
            'Mathematics',
            '10:00 AM - 11:00 AM',
            'Room 301',
            'Dr. Smith',
          ),
          const Divider(height: 1),
          _buildLectureItem(
            'Physics',
            '11:15 AM - 12:15 PM',
            'Lab 2',
            'Prof. Johnson',
          ),
          const Divider(height: 1),
          _buildLectureItem(
            'Computer Science',
            '02:00 PM - 03:00 PM',
            'Room 205',
            'Dr. Williams',
          ),
        ],
      ),
    );
  }

  Widget _buildLectureItem(
    String subject,
    String time,
    String room,
    String teacher,
  ) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: AppConstants.secondaryColor,
        child: Icon(Icons.book, color: Colors.white, size: 20),
      ),
      title: Text(subject, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('$time • $room\n$teacher'),
      isThreeLine: true,
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.primaryColor,
                      AppConstants.secondaryColor,
                    ],
                  ),
                ),
                accountName: Text(user?.name ?? 'Student'),
                accountEmail: Text(user?.email ?? ''),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    (user?.name != null && user!.name.isNotEmpty)
                        ? user.name.substring(0, 1).toUpperCase()
                        : 'S',
                    style: const TextStyle(
                      fontSize: 32,
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () {
                  Get.back();
                },
              ),
              ListTile(
                leading: const Icon(Icons.how_to_reg),
                title: const Text('Attendance'),
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.attendance);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Timetable'),
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.timetable);
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                onTap: () {
                  Get.back();
                  // Navigate to notifications
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.workspace_premium,
                  color: AppConstants.vipGold,
                ),
                title: const Text('Upgrade to VIP'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppConstants.vipGradientStart,
                        AppConstants.vipGradientEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'PRO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.vip);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Get.back();
                  // Navigate to settings
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & Support'),
                onTap: () {
                  Get.back();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: AppConstants.errorColor,
                ),
                title: const Text('Logout'),
                onTap: () async {
                  await authProvider.logout();
                  Get.offAllNamed(AppRoutes.login);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

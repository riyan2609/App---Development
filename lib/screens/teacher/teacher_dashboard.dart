import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/stat_card.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh data
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 20),
              _buildQuickActions(),
              const SizedBox(height: 20),
              _buildTodayStats(),
              const SizedBox(height: 20),
              _buildSectionHeader('Today\'s Classes'),
              const SizedBox(height: 10),
              _buildTodayClasses(),
              const SizedBox(height: 20),
              _buildSectionHeader('Recent Activities'),
              const SizedBox(height: 10),
              _buildRecentActivities(),
            ],
          ),
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
              break;
            case 1:
              Get.toNamed(AppRoutes.markAttendance);
              break;
            case 2:
              Get.toNamed(AppRoutes.classReports);
              break;
            case 3:
              Get.toNamed(AppRoutes.announcements);
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
            label: 'Mark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment_outlined),
            activeIcon: Icon(Icons.assessment),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign_outlined),
            activeIcon: Icon(Icons.campaign),
            label: 'Announce',
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppConstants.secondaryColor,
                AppConstants.secondaryColor.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppConstants.secondaryColor.withOpacity(0.3),
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
                      'Welcome Back,',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      authProvider.currentUser?.name ?? 'Teacher',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      DateTime.now().toString().split(' ')[0],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.school_rounded, size: 60, color: Colors.white24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  'Mark\nAttendance',
                  Icons.how_to_reg,
                  AppConstants.primaryColor,
                  () => Get.toNamed(AppRoutes.markAttendance),
                ),
                _buildActionButton(
                  'View\nReports',
                  Icons.assessment,
                  AppConstants.secondaryColor,
                  () => Get.toNamed(AppRoutes.classReports),
                ),
                _buildActionButton(
                  'Make\nAnnouncement',
                  Icons.campaign,
                  AppConstants.accentColor,
                  () => Get.toNamed(AppRoutes.announcements),
                ),
                _buildActionButton(
                  'Manage\nTimetable',
                  Icons.calendar_today,
                  AppConstants.warningColor,
                  () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayStats() {
    return const Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Classes Today',
            value: '5',
            icon: Icons.class_outlined,
            color: AppConstants.primaryColor,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'Completed',
            value: '3',
            icon: Icons.check_circle_outline,
            color: AppConstants.successColor,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'Pending',
            value: '2',
            icon: Icons.pending_outlined,
            color: AppConstants.warningColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTodayClasses() {
    return Card(
      child: Column(
        children: [
          _buildClassItem(
            'Computer Science',
            '09:00 AM - 10:00 AM',
            'Room 301',
            'B.Tech 3rd Year',
            true,
          ),
          const Divider(height: 1),
          _buildClassItem(
            'Data Structures',
            '10:15 AM - 11:15 AM',
            'Room 205',
            'B.Tech 2nd Year',
            true,
          ),
          const Divider(height: 1),
          _buildClassItem(
            'Algorithms',
            '11:30 AM - 12:30 PM',
            'Room 301',
            'B.Tech 3rd Year',
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildClassItem(
    String subject,
    String time,
    String room,
    String className,
    bool isCompleted,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isCompleted
            ? AppConstants.successColor.withOpacity(0.1)
            : AppConstants.primaryColor.withOpacity(0.1),
        child: Icon(
          isCompleted ? Icons.check : Icons.schedule,
          color: isCompleted
              ? AppConstants.successColor
              : AppConstants.primaryColor,
        ),
      ),
      title: Text(subject, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('$time • $room\n$className'),
      isThreeLine: true,
      trailing: !isCompleted
          ? ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.markAttendance),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text('Mark'),
            )
          : const Icon(Icons.check_circle, color: AppConstants.successColor),
    );
  }

  Widget _buildRecentActivities() {
    return Card(
      child: Column(
        children: [
          _buildActivityItem(
            'Marked attendance for CS-301',
            '2 hours ago',
            Icons.how_to_reg,
            AppConstants.successColor,
          ),
          const Divider(height: 1),
          _buildActivityItem(
            'Posted announcement',
            '5 hours ago',
            Icons.campaign,
            AppConstants.primaryColor,
          ),
          const Divider(height: 1),
          _buildActivityItem(
            'Updated timetable',
            'Yesterday',
            Icons.calendar_today,
            AppConstants.warningColor,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title),
      subtitle: Text(time),
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
                accountName: Text(user?.name ?? 'Teacher'),
                accountEmail: Text(user?.email ?? ''),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    (user?.name != null && user!.name.isNotEmpty)
                        ? user.name.substring(0, 1).toUpperCase()
                        : 'T',
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
                onTap: () => Get.back(),
              ),
              ListTile(
                leading: const Icon(Icons.how_to_reg),
                title: const Text('Mark Attendance'),
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.markAttendance);
                },
              ),
              ListTile(
                leading: const Icon(Icons.assessment),
                title: const Text('Reports'),
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.classReports);
                },
              ),
              ListTile(
                leading: const Icon(Icons.campaign),
                title: const Text('Announcements'),
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.announcements);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () => Get.back(),
              ),
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

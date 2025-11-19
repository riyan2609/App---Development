import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/stat_card.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats
            const Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Students',
                    value: '1250',
                    icon: Icons.people,
                    color: AppConstants.primaryColor,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Teachers',
                    value: '85',
                    icon: Icons.school,
                    color: AppConstants.secondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Classes',
                    value: '24',
                    icon: Icons.class_,
                    color: AppConstants.warningColor,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'VIP Users',
                    value: '120',
                    icon: Icons.workspace_premium,
                    color: AppConstants.vipGold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildActionCard(
                  'User Management',
                  Icons.people,
                  AppConstants.primaryColor,
                  () => Get.toNamed(AppRoutes.userManagement),
                ),
                _buildActionCard(
                  'Class Management',
                  Icons.class_,
                  AppConstants.secondaryColor,
                  () => Get.toNamed(AppRoutes.classManagement),
                ),
                _buildActionCard(
                  'Reports',
                  Icons.assessment,
                  AppConstants.accentColor,
                  () {},
                ),
                _buildActionCard(
                  'Settings',
                  Icons.settings,
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

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppConstants.primaryColor,
                  AppConstants.secondaryColor,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.admin_panel_settings,
                    size: 32,
                    color: AppConstants.primaryColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Admin Panel',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => Get.back(),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('User Management'),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.userManagement);
            },
          ),
          ListTile(
            leading: const Icon(Icons.class_),
            title: const Text('Class Management'),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.classManagement);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppConstants.errorColor),
            title: const Text('Logout'),
            onTap: () {
              Get.offAllNamed(AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}

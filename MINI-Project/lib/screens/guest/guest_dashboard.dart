import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';

class GuestDashboard extends StatelessWidget {
  const GuestDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guest Mode'),
        actions: [
          TextButton(
            onPressed: () => Get.offAllNamed(AppRoutes.login),
            child: const Text(
              'Sign In',
              style: TextStyle(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppConstants.primaryColor,
                    AppConstants.secondaryColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to Attendance Pro!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'You\'re currently in guest mode with limited features',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Get.offAllNamed(AppRoutes.signup),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppConstants.primaryColor,
                    ),
                    child: const Text('Create Account'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Preview Features
            const Text(
              'Preview Features',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildFeatureCard(
              'Track Attendance',
              'Monitor your daily attendance records',
              Icons.how_to_reg,
              AppConstants.primaryColor,
              true,
            ),
            _buildFeatureCard(
              'View Timetable',
              'Check your class schedule',
              Icons.calendar_today,
              AppConstants.secondaryColor,
              true,
            ),
            _buildFeatureCard(
              'Announcements',
              'Stay updated with latest news',
              Icons.campaign,
              AppConstants.accentColor,
              true,
            ),
            _buildFeatureCard(
              'Detailed Analytics',
              'Requires account signup',
              Icons.analytics,
              Colors.grey,
              false,
            ),
            _buildFeatureCard(
              'Export Reports',
              'Requires account signup',
              Icons.download,
              Colors.grey,
              false,
            ),
            _buildFeatureCard(
              'VIP Features',
              'Premium features available',
              Icons.workspace_premium,
              AppConstants.vipGold,
              false,
            ),

            const SizedBox(height: 30),

            // Demo Content
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConstants.warningColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppConstants.warningColor),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 48,
                    color: AppConstants.warningColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Limited Access',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign up to unlock full features including:',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('✓ Full attendance tracking'),
                      Text('✓ Subject-wise analytics'),
                      Text('✓ Push notifications'),
                      Text('✓ Export reports'),
                      Text('✓ And much more...'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Get.offAllNamed(AppRoutes.signup),
                    child: const Text('Get Started'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    String title,
    String description,
    IconData icon,
    Color color,
    bool isAvailable,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: isAvailable
            ? const Icon(Icons.check_circle, color: AppConstants.successColor)
            : const Icon(Icons.lock, color: Colors.grey),
      ),
    );
  }
}

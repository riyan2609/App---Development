import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../providers/auth_provider.dart';
import '../../providers/vip_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/custom_button.dart';

class VipScreen extends StatelessWidget {
  const VipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppConstants.vipGradientStart.withOpacity(0.2),
              AppConstants.vipGradientEnd.withOpacity(0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer2<AuthProvider, VipProvider>(
            builder: (context, authProvider, vipProvider, child) {
              final isVip = authProvider.currentUser?.isVip ?? false;

              if (isVip) {
                return _buildVipActiveScreen(
                  context,
                  authProvider,
                  vipProvider,
                );
              }

              return _buildVipUpgradeScreen(context, authProvider, vipProvider);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVipUpgradeScreen(
    BuildContext context,
    AuthProvider authProvider,
    VipProvider vipProvider,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Get.back(),
            ),
          ),
          const SizedBox(height: 20),

          // VIP Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppConstants.vipGradientStart,
                  AppConstants.vipGradientEnd,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppConstants.vipGold.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.workspace_premium,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),

          // Title
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                AppConstants.vipGradientStart,
                AppConstants.vipGradientEnd,
              ],
            ).createShader(bounds),
            child: const Text(
              'Upgrade to VIP',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Unlock premium features and boost your experience',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 40),

          // Features
          _buildFeaturesList(),
          const SizedBox(height: 40),

          // Pricing Plans
          _buildPricingPlans(context, authProvider, vipProvider),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      {
        'icon': Icons.analytics,
        'title': 'Detailed Analytics',
        'desc': 'AI-powered attendance predictions',
      },
      {
        'icon': Icons.notifications_active,
        'title': 'Priority Notifications',
        'desc': '10 min early class reminders',
      },
      {
        'icon': Icons.download,
        'title': 'Export Reports',
        'desc': 'Download attendance as PDF',
      },
      {
        'icon': Icons.trending_up,
        'title': 'Attendance Booster',
        'desc': 'Track and improve attendance',
      },
      {
        'icon': Icons.palette,
        'title': 'Custom Themes',
        'desc': 'Dark mode and color options',
      },
      {
        'icon': Icons.block,
        'title': 'Ad-Free',
        'desc': 'Enjoy without interruptions',
      },
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppConstants.vipGradientStart,
                      AppConstants.vipGradientEnd,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(feature['icon'] as IconData, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      feature['desc'] as String,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPricingPlans(
    BuildContext context,
    AuthProvider authProvider,
    VipProvider vipProvider,
  ) {
    return Column(
      children: [
        // Monthly Plan
        _buildPricingCard(
          context,
          'Monthly',
          '₹${AppConstants.vipMonthlyPrice.toInt()}',
          'per month',
          false,
          () async {
            final userId = authProvider.currentUser?.id;
            if (userId != null) {
              bool success = await vipProvider.subscribeToVip(
                userId,
                'monthly',
              );
              if (success && context.mounted) {
                Get.back();
                Get.snackbar(
                  'Success',
                  'VIP subscription activated!',
                  backgroundColor: AppConstants.successColor,
                  colorText: Colors.white,
                );
              }
            }
          },
        ),
        const SizedBox(height: 16),

        // Yearly Plan (Popular)
        _buildPricingCard(
          context,
          'Yearly',
          '₹${AppConstants.vipYearlyPrice.toInt()}',
          'per year',
          true,
          () async {
            final userId = authProvider.currentUser?.id;
            if (userId != null) {
              bool success = await vipProvider.subscribeToVip(userId, 'yearly');
              if (success && context.mounted) {
                Get.back();
                Get.snackbar(
                  'Success',
                  'VIP subscription activated!',
                  backgroundColor: AppConstants.successColor,
                  colorText: Colors.white,
                );
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildPricingCard(
    BuildContext context,
    String plan,
    String price,
    String period,
    bool isPopular,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: isPopular
            ? const LinearGradient(
                colors: [
                  AppConstants.vipGradientStart,
                  AppConstants.vipGradientEnd,
                ],
              )
            : null,
        color: isPopular ? null : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular ? Colors.transparent : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: const Center(
                child: Text(
                  '⭐ MOST POPULAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  plan,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isPopular ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: isPopular ? Colors.white : AppConstants.vipGold,
                      ),
                    ),
                  ],
                ),
                Text(
                  period,
                  style: TextStyle(
                    fontSize: 14,
                    color: isPopular ? Colors.white70 : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                if (plan == 'Yearly')
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isPopular
                          ? Colors.white.withOpacity(0.2)
                          : AppConstants.successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Save ₹${(AppConstants.vipMonthlyPrice * 12 - AppConstants.vipYearlyPrice).toInt()}',
                      style: TextStyle(
                        color: isPopular
                            ? Colors.white
                            : AppConstants.successColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPopular
                          ? Colors.white
                          : AppConstants.vipGold,
                      foregroundColor: isPopular
                          ? AppConstants.vipGold
                          : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Subscribe Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVipActiveScreen(
    BuildContext context,
    AuthProvider authProvider,
    VipProvider vipProvider,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppConstants.vipGradientStart,
                    AppConstants.vipGradientEnd,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.vipGold.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.workspace_premium,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'VIP Member',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'You\'re enjoying all premium features',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.vipGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Status:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
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
                          'ACTIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Valid Until:'),
                      Text(
                        authProvider.currentUser?.vipExpiryDate
                                ?.toString()
                                .split(' ')[0] ??
                            'N/A',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Manage Subscription',
              onPressed: () {},
              outlined: true,
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: () => Get.back(), child: const Text('Close')),
          ],
        ),
      ),
    );
  }
}

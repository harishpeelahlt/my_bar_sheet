import 'package:flutter/material.dart';
import 'package:mybarsheet/core/constants/appBar.dart';
import 'package:mybarsheet/core/constants/appColors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Profile',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  AssetImage('assets/images/avif/ic_launcher.avif'),
              backgroundColor: AppColors.card,
            ),
            const SizedBox(height: 16),
            Text(
              "Jagadeesh",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Manager - Blue Lagoon Bar",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildInfoRow("Username", "gymratmaxx"),
                  const Divider(color: Colors.grey, height: 24),
                  _buildInfoRow("Email", "jagadeesh@barshop.com"),
                  const Divider(color: Colors.grey, height: 24),
                  _buildInfoRow("Phone", "+91 9700020630"),
                  const Divider(color: Colors.grey, height: 24),
                  _buildInfoRow("Role", "Bar Manager"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title:",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

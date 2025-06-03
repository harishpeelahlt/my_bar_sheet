import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mybarsheet/core/constants/appColors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(24),
      ),
      child: Container(
        height: preferredSize.height,
        color: AppColors.card,
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: showBackButton,
          leading: showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_sharp, color: AppColors.accent),
                  onPressed: () => Navigator.pop(context),
                )
              : null,
          title: Text(
            title,
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          actions: actions,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(110);
}

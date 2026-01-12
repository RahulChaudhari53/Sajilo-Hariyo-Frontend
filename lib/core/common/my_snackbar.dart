import 'package:flutter/material.dart';

class MySnackBar {
  static void showSuccess({
    required BuildContext context,
    required String message,
  }) {
    _showSnackBar(
      context: context,
      message: message,
      color: const Color(0xFF53B386),
      icon: Icons.check_circle_outline,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
  }) {
    _showSnackBar(
      context: context,
      message: message,
      color: const Color(0xFFDC3535), 
      icon: Icons.error_outline,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
  }) {
    _showSnackBar(
      context: context,
      message: message,
      color: const Color(0xFF5A6ECD),
      icon: Icons.info_outline,
    );
  }

  static void _showSnackBar({
    required BuildContext context,
    required String message,
    required Color color,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating, 
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins', 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

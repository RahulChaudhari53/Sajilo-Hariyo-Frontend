import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color cardColor = Color(0xFFF8F3ED);
    const Color darkText = Color(0xFF1B3A29);
    const Color subText = Color(0xFF666666);

    return Scaffold(
      backgroundColor: cardColor,
      appBar: AppBar(
        title: Text(
          "Privacy Policy",
          style: GoogleFonts.poppins(
            color: darkText,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: cardColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: darkText),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Last Updated: January 2026",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: subText,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              "1. Introduction",
              "Welcome to Sajilo Hariyo. We respect your privacy and are committed to protecting your personal data.",
            ),
            _buildSection(
              "2. Data We Collect",
              "We collect personal information such as your name, email address, phone number, and shipping address when you register and place orders. We also use your camera for Augmented Reality (AR) features.",
            ),
            _buildSection(
              "3. How We Use Your Data",
              "Your data is used to process orders, improve our services, and verify deliveries via QR codes.",
            ),
            _buildSection(
              "4. Data Security",
              "We implement industry-standard security measures to protect your data. Your passwords are encrypted, and payment information is not stored on our servers.",
            ),
            _buildSection(
              "5. Contact Us",
              "If you have any questions about this Privacy Policy, please contact our support team.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B3A29),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF666666),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

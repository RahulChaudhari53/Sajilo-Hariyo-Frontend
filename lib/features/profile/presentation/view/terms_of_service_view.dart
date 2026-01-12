import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsOfServiceView extends StatelessWidget {
  const TermsOfServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color cardColor = Color(0xFFF8F3ED);
    const Color darkText = Color(0xFF1B3A29);
    const Color subText = Color(0xFF666666);

    return Scaffold(
      backgroundColor: cardColor,
      appBar: AppBar(
        title: Text(
          "Terms of Service",
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
              "Effective Date: January 2026",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: subText,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              "1. Acceptance of Terms",
              "By accessing and using Sajilo Hariyo, you agree to comply with and be bound by these Terms of Service.",
            ),
            _buildSection(
              "2. User Accounts",
              "You are responsible for maintaining the confidentiality of your account credentials and for all activities under your account.",
            ),
            _buildSection(
              "3. Orders and Payments",
              "All orders are subject to acceptance and availability. Prices described on the app are subject to change.",
            ),
            _buildSection(
              "4. AR Features",
              "The Augmented Reality (AR) features are provided 'as is'. Accuracy of size and appearance may vary based on your device and environment.",
            ),
             _buildSection(
              "5. Prohibited Conduct",
              "You agree not to misuse the app or engage in any unlawful activities.",
            ),
            _buildSection(
              "6. Changes to Terms",
              "We reserve the right to modify these terms at any time. Continued use of the app constitutes acceptance of the new terms.",
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

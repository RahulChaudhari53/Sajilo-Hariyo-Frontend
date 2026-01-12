import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/core/common/custom_elevated_button.dart';
import 'package:sajilo_hariyo/features/dashboard/presentation/view/dashboard_view.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF3A7F5F);
    const Color cardColor = Color(0xFFF8F3ED);
    const Color darkText = Color(0xFF1B3A29);

    return Scaffold(
      backgroundColor: cardColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animation/Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(LucideIcons.check, size: 60, color: primaryGreen),
              ),

              const SizedBox(height: 30),

              Text(
                "Order Placed!",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Your order #ORD-2025-089 has been placed successfully. We will deliver your plants soon.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              CustomElevatedButton(
                text: "Track Order",
                backgroundColor: primaryGreen,
                onPressed: () {
                  // Navigate to Dashboard but switch to Orders Tab (Index 1)
                  // For now, simpler to just go to Dashboard
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const DashboardView(initialIndex: 2),
                    ),
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardView(),
                    ),
                    (route) => false,
                  );
                },
                child: Text(
                  "Continue Shopping",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

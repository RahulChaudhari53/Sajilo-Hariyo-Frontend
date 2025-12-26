import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/core/common/custom_elevated_button.dart';
import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
import 'package:sajilo_hariyo/features/cart/presentation/view/order_success_view.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view/shipping_address_view.dart';

class CheckoutView extends StatefulWidget {
  final double totalAmount;

  const CheckoutView({super.key, required this.totalAmount});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  // Colors
  final Color primaryGreen = const Color(0xFF3A7F5F);
  final Color cardColor = const Color(0xFFF8F3ED);
  final Color darkText = const Color(0xFF1B3A29);

  // Payment Selection
  String _selectedPayment = "COD"; // Default to Cash on Delivery

  // Mock Payment Options
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      "id": "esewa",
      "name": "eSewa Mobile Wallet",
      "icon": "assets/logo/esewa.png",
    }, // You'll need assets for these later
    {"id": "COD", "name": "Cash on Delivery", "icon": "assets/logo/cod.png"},
  ];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: darkText),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Checkout",
          style: GoogleFonts.poppins(
            color: darkText,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. DELIVERY ADDRESS SECTION
                  _buildSectionHeader("Delivery Address"),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(LucideIcons.mapPin, color: primaryGreen),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Home • Rahul Chaudhari",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: darkText,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Lazimpat, Kathmandu\nNear Radisson Hotel, House 123",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "9841XXXXXX",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                LucideIcons.pencil,
                                size: 18,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ShippingAddressView(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 2. PAYMENT METHOD SECTION
                  _buildSectionHeader("Payment Method"),
                  const SizedBox(height: 12),
                  ..._paymentMethods
                      .map((method) => _buildPaymentOption(method))
                      .toList(),

                  const SizedBox(height: 30),

                  // 3. ORDER SUMMARY
                  _buildSectionHeader("Order Summary"),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow(
                          "Subtotal",
                          "Rs. ${(widget.totalAmount - 100).toStringAsFixed(0)}",
                        ),
                        const SizedBox(height: 8),
                        _buildSummaryRow("Shipping", "Rs. 100"),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1),
                        ),
                        _buildSummaryRow(
                          "Total",
                          "Rs. ${widget.totalAmount.toStringAsFixed(0)}",
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. BOTTOM BAR
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: CustomElevatedButton(
              text: "Place Order",
              backgroundColor: primaryGreen,
              isLoading: _isLoading,
              height: 55,
              onPressed: _handlePlaceOrder,
            ),
          ),
        ],
      ),
    );
  }

  void _handlePlaceOrder() async {
    setState(() => _isLoading = true);

    if (_selectedPayment == 'esewa') {
      // --- eSewa Mock Flow ---
      MySnackBar.showInfo(context: context, message: "Redirecting to eSewa...");
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        MySnackBar.showSuccess(context: context, message: "Payment Verified!");
      }
      await Future.delayed(const Duration(seconds: 1));
    } else {
      // --- COD Flow ---
      await Future.delayed(const Duration(seconds: 2));
    }

    if (mounted) {
      setState(() => _isLoading = false);
      // Navigate to Success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OrderSuccessView()),
      );
    }
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: darkText,
      ),
    );
  }

  Widget _buildPaymentOption(Map<String, dynamic> method) {
    final bool isSelected = _selectedPayment == method['id'];

    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = method['id']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: primaryGreen, width: 2)
              : Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5),
          ],
        ),
        child: Row(
          children: [
            // Placeholder for Logo (eSewa/Khalti)
            // In real app, use Image.asset(method['icon'])
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                method['id'] == 'COD'
                    ? LucideIcons.banknote
                    : LucideIcons.wallet,
                color: isSelected ? primaryGreen : Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              method['name'],
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: darkText,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(LucideIcons.checkCircle, color: primaryGreen, size: 20)
            else
              Icon(LucideIcons.circle, color: Colors.grey[300], size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? darkText : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? primaryGreen : darkText,
          ),
        ),
      ],
    );
  }
}

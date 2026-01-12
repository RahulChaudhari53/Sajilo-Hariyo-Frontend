import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/core/common/custom_elevated_button.dart';
import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
import 'package:sajilo_hariyo/features/cart/presentation/view_model/cart_bloc/cart_bloc.dart';
import 'package:sajilo_hariyo/features/cart/presentation/view_model/cart_bloc/cart_event.dart';
import 'package:sajilo_hariyo/features/orders/domain/entity/order_entity.dart';
import 'package:sajilo_hariyo/features/orders/presentation/view_model/order_bloc/order_bloc.dart';
import 'package:sajilo_hariyo/features/orders/presentation/view_model/order_bloc/order_event.dart';
import 'package:sajilo_hariyo/features/orders/presentation/view_model/order_bloc/order_state.dart';
import 'package:sajilo_hariyo/features/profile/domain/entity/address_entity.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view/add_address_view.dart';
import 'order_success_view.dart';

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

  // State
  AddressEntity? _selectedAddress;
  String _selectedPayment = "COD"; // Only COD supported
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Fetch addresses on mount
    context.read<OrderBloc>().add(FetchUserAddresses());
  }

  @override
  Widget build(BuildContext context) {
    // We need access to Cart items for the OrderEntity
    final cartState = context.watch<CartBloc>().state;
    
    return BlocConsumer<OrderBloc, OrderState>(
      listener: (context, state) {
        // Handle Success/Error
        if (state.isSuccess) {
           // Clear Cart locally since backend order is placed
          context.read<CartBloc>().add(ClearCart());
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OrderSuccessView()),
          );
        }
        if (state.errorMessage != null) {
          MySnackBar.showError(context: context, message: state.errorMessage!);
        }
        
        // Auto-select first address if available and none selected
        if (!state.isLoading && state.addresses.isNotEmpty && !_initialized) {
          setState(() {
            _selectedAddress = state.addresses.first;
            _initialized = true;
          });
        }
      },
      builder: (context, state) {
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
                      
                      // Loading State
                      if (state.isLoading && state.addresses.isEmpty)
                        const Center(child: LinearProgressIndicator()),
                        
                      // Empty State
                      if (!state.isLoading && state.addresses.isEmpty)
                         _buildAddAddressButton(),

                      // Address List (If exists)
                      if (state.addresses.isNotEmpty)
                        Column(
                          children: state.addresses.map((addr) => _buildAddressCard(addr)).toList(),
                        ),

                      const SizedBox(height: 30),

                      // 2. PAYMENT METHOD SECTION
                      _buildSectionHeader("Payment Method"),
                      const SizedBox(height: 12),
                      _buildPaymentOption(
                        "COD", 
                        "Cash on Delivery", 
                        LucideIcons.banknote
                      ),

                      const SizedBox(height: 30),

                      // 3. CART ITEMS & SUMMARY
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
                            // List items briefly
                            ...cartState.items.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text("${item.quantity}x ${item.name}", style: GoogleFonts.poppins(fontSize: 13))),
                                  Text("Rs. ${item.price * item.quantity}", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            )),
                            const Divider(height: 24),
                            
                            _buildSummaryRow(
                              "Subtotal",
                              "Rs. ${cartState.subtotal.toStringAsFixed(0)}",
                            ),
                            const SizedBox(height: 8),
                            _buildSummaryRow("Shipping", "Rs. 100"), // Fixed currently
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
                  isLoading: state.isLoading,
                  height: 55,
                  onPressed: () {
                    if (_selectedAddress == null) {
                       MySnackBar.showError(context: context, message: "Please select an address");
                       return;
                    }
                    if (cartState.items.isEmpty) {
                      MySnackBar.showError(context: context, message: "Cart is empty!");
                      return;
                    }

                    // Create Order Entity
                    final order = OrderEntity(
                      items: cartState.items, 
                      totalAmount: widget.totalAmount, 
                      shippingAddress: "${_selectedAddress!.street}, ${_selectedAddress!.detail} (${_selectedAddress!.label})", 
                      city: _selectedAddress!.city, 
                      phone: _selectedAddress!.phone, 
                      status: "Pending", 
                      createdAt: DateTime.now(),
                      paymentMethod: _selectedPayment, // Use the selected variable
                    );

                    context.read<OrderBloc>().add(PlaceOrderEvent(order));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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

  Widget _buildAddressCard(AddressEntity address) {
    final bool isSelected = _selectedAddress == address;
    return GestureDetector(
      onTap: () => setState(() => _selectedAddress = address),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: primaryGreen, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(LucideIcons.mapPin, color: isSelected ? primaryGreen : Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.label,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${address.street}, ${address.city}\n${address.detail}",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.phone,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
               Icon(LucideIcons.checkCircle, color: primaryGreen, size: 20)
            else
               Icon(LucideIcons.circle, color: Colors.grey[300], size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAddressButton() {
     return InkWell(
        onTap: () {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddAddressView()),
             ).then((_) {
                // Refresh addresses after returning
                context.read<OrderBloc>().add(FetchUserAddresses());
             });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, style: BorderStyle.none), // simplified
            color: Colors.white,
            borderRadius: BorderRadius.circular(12)
          ),
          child: Column(
            children: [
               Icon(LucideIcons.plusCircle, color: primaryGreen, size: 30),
               const SizedBox(height: 8),
               Text("Add New Address", style: GoogleFonts.poppins(color: primaryGreen, fontWeight: FontWeight.bold))
            ],
          ),
        ),
     );
  }

  Widget _buildPaymentOption(String id, String name, IconData icon) {
    final bool isSelected = _selectedPayment == id;

    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = id),
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
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: isSelected ? primaryGreen : Colors.grey),
            ),
            const SizedBox(width: 16),
            Text(
              name,
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/app/constant/api_endpoints.dart';
import 'package:sajilo_hariyo/core/common/custom_elevated_button.dart';
import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
import 'package:sajilo_hariyo/features/cart/domain/entity/cart_item_entity.dart';
import 'package:sajilo_hariyo/features/cart/presentation/view/checkout_view.dart';
import 'package:sajilo_hariyo/features/cart/presentation/view_model/cart_bloc/cart_bloc.dart';
import 'package:sajilo_hariyo/features/cart/presentation/view_model/cart_bloc/cart_event.dart';
import 'package:sajilo_hariyo/features/cart/presentation/view_model/cart_bloc/cart_state.dart';
import 'package:sajilo_hariyo/features/orders/presentation/view_model/order_bloc/order_bloc.dart';
import 'package:sajilo_hariyo/features/dashboard/presentation/view/dashboard_view.dart';
import '../../../../app/service_locator/service_locator.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  // Colors
  final Color primaryGreen = const Color(0xFF3A7F5F);
  final Color cardColor = const Color(0xFFF8F3ED);
  final Color darkText = const Color(0xFF1B3A29);

  @override
  void initState() {
    super.initState();
    // Refresh cart when view opens
    context.read<CartBloc>().add(LoadCartItems());
  }

  void _incrementQuantity(CartItemEntity item) {
    context.read<CartBloc>().add(UpdateQuantity(item.productId, item.quantity + 1));
  }

  void _decrementQuantity(CartItemEntity item) {
    if (item.quantity > 1) {
      context.read<CartBloc>().add(UpdateQuantity(item.productId, item.quantity - 1));
    }
  }

  void _removeItem(CartItemEntity item) {
    context.read<CartBloc>().add(RemoveFromCart(item.productId));
    MySnackBar.showInfo(
      context: context,
      message: "${item.name} removed",
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          MySnackBar.showError(context: context, message: state.errorMessage!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: cardColor,
          appBar: AppBar(
            backgroundColor: cardColor,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false, 
            title: Text(
              "My Cart",
              style: GoogleFonts.poppins(
                color: darkText,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(LucideIcons.trash2, color: Colors.grey[600], size: 20),
                tooltip: "Clear Cart",
                onPressed: () {
                  if (state.items.isNotEmpty) {
                    context.read<CartBloc>().add(ClearCart());
                    MySnackBar.showInfo(context: context, message: "Cart Cleared");
                  }
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: (state.isLoading && state.items.isEmpty)
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // 1. SCROLLABLE LIST
                    Expanded(
                      child: state.items.isEmpty
                          ? _buildEmptyState()
                          : ListView.separated(
                              padding: const EdgeInsets.all(20),
                              itemCount: state.items.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                return _buildCartItem(state.items[index]);
                              },
                            ),
                    ),

                    // 2. CHECKOUT SUMMARY FOOTER
                    if (state.items.isNotEmpty)
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
                        child: Column(
                          children: [
                            _buildSummaryRow(
                              "Subtotal",
                              "Rs. ${state.subtotal.toStringAsFixed(0)}",
                            ),
                            const SizedBox(height: 12),
                            // Delivery fee is fixed at 100 for now if subtotal > 0
                            _buildSummaryRow(
                              "Delivery Fee",
                              "Rs. ${(state.items.isNotEmpty ? 100 : 0).toStringAsFixed(0)}",
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Divider(color: Colors.grey, height: 1),
                            ),
                            _buildSummaryRow(
                              "Total",
                              "Rs. ${state.total.toStringAsFixed(0)}",
                              isTotal: true,
                            ),
                            const SizedBox(height: 24),
                            CustomElevatedButton(
                              text: "Proceed to Checkout",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (context) => locator<OrderBloc>(),
                                      child: CheckoutView(
                                        totalAmount: state.total,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              backgroundColor: primaryGreen,
                              height: 55,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }

  // Helper: Cart Item Card with Swipe
  Widget _buildCartItem(CartItemEntity item) {
    return Dismissible(
      key: Key(item.productId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(LucideIcons.trash2, color: Colors.white),
      ),
      onDismissed: (direction) {
        _removeItem(item);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
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
        child: Row(
          children: [
            // Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.hardEdge,
              child: item.image.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: item.image.startsWith('http')
                          ? item.image
                          : "${ApiEndpoints.serverAddress}/${item.image.replaceAll('\\', '/')}",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: primaryGreen,
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(LucideIcons.image, color: Colors.grey[400]),
                    )
                  : Icon(LucideIcons.image, color: Colors.grey[400], size: 30),
            ),
            const SizedBox(width: 16),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: darkText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Rs. ${item.price.toStringAsFixed(0)}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: primaryGreen,
                    ),
                  ),
                ],
              ),
            ),

            // Quantity Buttons
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F3ED),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => _incrementQuantity(item),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(LucideIcons.plus, size: 16),
                    ),
                  ),
                  Text(
                    "${item.quantity}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  InkWell(
                    onTap: () => _decrementQuantity(item),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(LucideIcons.minus, size: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? darkText : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? primaryGreen : darkText,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.shoppingCart, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "Your cart is empty",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
               // Navigate to Home Tab (Index 0)
               Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const DashboardView(initialIndex: 0),
                ),
              );
            },
            child: Text(
              "Start Shopping",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

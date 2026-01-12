import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/features/orders/presentation/view/order_detail_view.dart';
import 'package:sajilo_hariyo/features/orders/presentation/view_model/order_bloc/order_bloc.dart';
import 'package:sajilo_hariyo/features/orders/presentation/view_model/order_bloc/order_event.dart';
import 'package:sajilo_hariyo/features/orders/presentation/view_model/order_bloc/order_state.dart';
import 'package:timeago/timeago.dart' as timeago;

class OrderListView extends StatefulWidget {
  const OrderListView({super.key});

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  // Colors
  final Color primaryGreen = const Color(0xFF3A7F5F);
  final Color cardColor = const Color(0xFFF8F3ED);
  final Color darkText = const Color(0xFF1B3A29);

  // Toggle State
  bool _showActive = true;

  @override
  void initState() {
    super.initState();
    // Fetch initial list
    _fetchOrders();
  }

  void _fetchOrders() {
    context.read<OrderBloc>().add(
          GetMyOrders(filter: _showActive ? 'active' : 'history'),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        title: Text(
          "My Orders",
          style: GoogleFonts.poppins(
            color: darkText,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false, 
        automaticallyImplyLeading: false, 
      ),
      body: Column(
        children: [
          // 1. Custom Segmented Control (Toggle)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                _buildToggleButton("Active", _showActive),
                const SizedBox(width: 12),
                _buildToggleButton("History", !_showActive),
              ],
            ),
          ),

          // 2. Order List
          Expanded(
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (state.errorMessage != null) {
                  return Center(child: Text("Error: ${state.errorMessage}"));
                }

                if (state.orders.isEmpty) {
                   return Center(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(LucideIcons.packageOpen, size: 64, color: Colors.grey[400]),
                         const SizedBox(height: 16),
                         Text("No orders found", style: GoogleFonts.poppins(color: Colors.grey[600])),
                       ],
                     ),
                   );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: state.orders.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final order = state.orders[index];
                    
                    // Determine status color
                    Color statusColor;
                    switch (order.status.toLowerCase()) {
                      case 'pending': statusColor = Colors.orange; break;
                      case 'processing': statusColor = Colors.blue; break;
                      case 'shipped': statusColor = Colors.purple; break;
                      case 'delivered': statusColor = primaryGreen; break;
                      case 'cancelled': statusColor = Colors.red; break;
                      default: statusColor = Colors.grey;
                    }

                    return GestureDetector(
                      onTap: () async {
                         final result = await Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (_) => OrderDetailView(order: order),
                           ),
                         );
                         if (result == true) {
                           _fetchOrders();
                         }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    // Status Dot
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: statusColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      order.id != null && order.id!.length >= 6
                                          ? "ORD - ${order.id!.substring(order.id!.length - 6).toUpperCase()}"
                                          : order.id ?? "ID", // Short ID
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: darkText,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Rs. ${order.totalAmount}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: darkText,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      LucideIcons.calendar,
                                      size: 16,
                                      color: darkText,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "${timeago.format(order.createdAt)} • ${order.status}",
                                      style: GoogleFonts.poppins(
                                        color: darkText,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  LucideIcons.chevronRight,
                                  size: 20,
                                  color: Colors.grey[400],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (_showActive != (text == "Active")) {
           setState(() {
             _showActive = text == "Active";
           });
           _fetchOrders();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey[400]!),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : darkText,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
} 

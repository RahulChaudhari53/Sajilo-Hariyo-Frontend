import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/app/constant/api_endpoints.dart';
import 'package:sajilo_hariyo/core/common/custom_elevated_button.dart';
import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_order_bloc/admin_order_bloc.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_order_bloc/admin_order_event.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_order_bloc/admin_order_state.dart';
import 'package:sajilo_hariyo/features/orders/domain/entity/order_entity.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view/admin_qr_scanner_view.dart';

class AdminOrderDetailView extends StatefulWidget {
  final OrderEntity order;

  const AdminOrderDetailView({super.key, required this.order});

  @override
  State<AdminOrderDetailView> createState() => _AdminOrderDetailViewState();
}

class _AdminOrderDetailViewState extends State<AdminOrderDetailView> {
  // Colors
  final Color primaryGreen = const Color(0xFF3A7F5F);
  final Color cardColor = const Color(0xFFF8F3ED);
  final Color darkText = const Color(0xFF1B3A29);

  late String _currentStatus;

  // Status Colors Mapping
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Processing':
        return Colors.yellow.shade800;
      case 'Shipped':
        return Colors.blue;
      case 'Delivered':
        return const Color(0xFF3A7F5F);
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order.status;
  }

  void _updateStatus(String newStatus) {
    if (newStatus == _currentStatus) return;

    context.read<AdminOrderBloc>().add(
      UpdateOrderStatusEvent(orderId: widget.order.id!, status: newStatus),
    );

    setState(() {
      _currentStatus = newStatus;
    });
    // Navigator.pop(context); // Removed as we use Dialog now
    MySnackBar.showSuccess(
      context: context,
      message: "Order marked as $newStatus",
    );
  }

  String? _getNextStatus(String current) {
    switch (current) {
      case 'Pending': return 'Processing';
      case 'Processing': return 'Shipped';
      case 'Shipped': return 'Delivered';
      default: return null;
    }
  }

  void _handleStatusUpdate() {
    final nextStatus = _getNextStatus(_currentStatus);
    if (nextStatus == null) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Update Status?", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to update status to '$nextStatus'?", style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("No", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _updateStatus(nextStatus);
            },
            child: Text("Yes", style: GoogleFonts.poppins(color: primaryGreen, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  String _getImageUrl(String path) {
    if (path.isEmpty) return "";
    if (path.startsWith('http')) return path;

    final baseUrl = ApiEndpoints.serverAddress;
    // Normalize path separators
    String cleanPath = path.replaceAll('\\', '/');
    if (cleanPath.startsWith('/')) {
      cleanPath = cleanPath.substring(1);
    }

    return "$baseUrl/$cleanPath";
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _getStatusColor(_currentStatus);

    return BlocListener<AdminOrderBloc, AdminOrderState>(
      listener: (context, state) {
        if (state.successMessage != null &&
            state.successMessage!.contains("Delivery Verified")) {
          MySnackBar.showSuccess(
            context: context,
            message: state.successMessage!,
          );
          setState(() {
            _currentStatus = "Delivered";
          });
        }
        if (state.error != null) {
          MySnackBar.showError(context: context, message: state.error!);
        }
      },
      child: Scaffold(
        backgroundColor: cardColor,
        appBar: AppBar(
          backgroundColor: cardColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(LucideIcons.arrowLeft, color: darkText),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "ORD - ${widget.order.id?.substring(widget.order.id!.length - 6).toUpperCase() ?? ''}",
            style: GoogleFonts.poppins(
              color: darkText,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER CARD (Status & Date)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order Date",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          // Format date nicely if needed, leveraging intl package or simple split
                          widget.order.createdAt.toIso8601String().split(
                            'T',
                          )[0],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: darkText,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _currentStatus,
                        style: GoogleFonts.poppins(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 2. CUSTOMER DETAILS
              Text(
                "Customer Details",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: primaryGreen.withOpacity(0.1),
                          child: Icon(LucideIcons.user, color: primaryGreen),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.order.userName ?? "Customer",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: darkText,
                              ),
                            ),
                            Text(
                              widget.order.city,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      children: [
                        Icon(LucideIcons.mapPin, color: Colors.grey, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "${widget.order.shippingAddress}, ${widget.order.city}",
                            style: GoogleFonts.poppins(color: darkText),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(LucideIcons.phone, color: Colors.grey, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          widget.order.phone,
                          style: GoogleFonts.poppins(color: darkText),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            LucideIcons.phoneCall,
                            color: primaryGreen,
                          ),
                          onPressed: () => _makePhoneCall(widget.order.phone),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3. ORDER ITEMS
              Text(
                "Items to Pack",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.order.items.length,
                separatorBuilder: (c, i) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = widget.order.items[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(_getImageUrl(item.image)),
                              fit: BoxFit.cover,
                              onError: (e, s) {},
                            ),
                          ),
                          // child: Icon(LucideIcons.image, color: Colors.grey),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: darkText,
                                ),
                              ),
                              Text(
                                "Rs. ${item.price}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "x${item.quantity}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // 4. PAYMENT SUMMARY
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      "Payment Method",
                      widget.order.paymentMethod == "COD"
                          ? "Cash on Delivery"
                          : widget.order.paymentMethod,
                    ),
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      "Total Amount",
                      "Rs. ${widget.order.totalAmount}",
                      isBold: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 5. ACTION BUTTONS
              if (_currentStatus == "Shipped") ...[
                CustomElevatedButton(
                  text: "Scan to Deliver",
                  backgroundColor: Colors.black, // Distinct color
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminQRScannerView(),
                      ),
                    );

                    if (result != null && mounted) {
                      context.read<AdminOrderBloc>().add(
                        VerifyDeliveryQREvent(
                          orderId: widget.order.id!,
                          qrCode: result,
                        ),
                      );
                      // Optimistically update or wait for Listener?
                      // Listener should handle success message, maybe we should close this view or refresh?
                      // For now, the BlocListener in AdminOrdersView handles refresh,
                      // but here we might want to listen too.
                      // Or just rely on the parent list refreshing when we go back.
                      // Actually, we are in DetailView. We should probably listen here too if we want immediate feedback.
                    }
                  },
                ),
                const SizedBox(height: 12),
              ],

              if (_currentStatus != "Shipped")
                CustomElevatedButton(
                  text:
                      (_currentStatus == "Cancelled" ||
                          _currentStatus == "Delivered")
                      ? "Order $_currentStatus"
                      : "Update Status",
                  backgroundColor:
                      (_currentStatus == "Cancelled" ||
                          _currentStatus == "Delivered")
                      ? Colors.grey
                      : primaryGreen,
                  onPressed:
                      (_currentStatus == "Cancelled" ||
                          _currentStatus == "Delivered")
                      ? null
                      : _handleStatusUpdate,
                ),
              const SizedBox(height: 30),
            ],
          ),
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
          style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 13),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: darkText,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }
}

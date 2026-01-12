import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/core/common/custom_elevated_button.dart';
import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
import 'package:sajilo_hariyo/features/orders/domain/entity/order_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/features/orders/presentation/view_model/order_bloc/order_bloc.dart';
import 'package:sajilo_hariyo/features/orders/presentation/view_model/order_bloc/order_event.dart';
import 'package:sajilo_hariyo/features/orders/presentation/view_model/order_bloc/order_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sajilo_hariyo/app/constant/api_endpoints.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:qr_flutter/qr_flutter.dart';

class OrderDetailView extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF3A7F5F);
    const Color cardColor = Color(0xFFF8F3ED);
    const Color darkText = Color(0xFF1B3A29);

    final String status = order.status;

    // Determine status color
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'processing':
        statusColor = Colors.blue;
        break;
      case 'shipped':
        statusColor = Colors.purple;
        break;
      case 'delivered':
        statusColor = primaryGreen;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          MySnackBar.showError(context: context, message: state.errorMessage!);
        }
        if (state.orderCanceled) {
          MySnackBar.showSuccess(
            context: context,
            message: "Order Cancelled Successfully",
          );
          if (ModalRoute.of(context)?.isCurrent == true) {
            Navigator.pop(context, true); // Return true to trigger refresh
          }
        }
        if (state.deliveryQR != null) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                "Delivery Code",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: QrImageView(
                            data: state.deliveryQR!,
                            version: QrVersions.auto,
                            size: 200.0,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          state.deliveryQR!,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Show this code to the delivery agent.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: cardColor,
        appBar: AppBar(
          backgroundColor: cardColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft, color: darkText),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Track Order",
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
              // 1. Order Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order ID",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            order.id != null && order.id!.length >= 6
                                ? "ORD - ${order.id!.substring(order.id!.length - 6).toUpperCase()}"
                                : order.id ?? "N/A",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: darkText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Total Amount",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Rs. ${order.totalAmount}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: darkText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 2. Order Items
              Text(
                "Order Items",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[100],
                            child: item.image.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: item.image.startsWith('http')
                                        ? item.image
                                        : "${ApiEndpoints.serverAddress}/${item.image.replaceAll('\\', '/')}",
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        const Icon(LucideIcons.image),
                                  )
                                : const Icon(LucideIcons.image),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Name & Qty
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: darkText,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "${item.quantity} x Rs. ${item.price}",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Total Amount for Item
                        Text(
                          "Rs. ${(item.price * item.quantity).toStringAsFixed(0)}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // 2. Order Status (Timeline)
              Text(
                "Order Status",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 20),

              Builder(
                builder: (context) {
                  // Special logic for Cancelled Orders
                  if (status.toLowerCase() == 'cancelled') {
                    return Column(
                      children: [
                        _TimelineTile(
                          title: "Order Placed",
                          date: timeago.format(order.createdAt),
                          isCompleted: true,
                          isFirst: true,
                        ),
                        // Assuming cancellation happens after placement (Step 0)
                        _TimelineTile(
                          title: "Cancelled",
                          date: "Order Cancelled",
                          isCompleted: true,
                          isLast: true,
                          customColor: Colors.red,
                        ),
                      ],
                    );
                  }

                  // Standard Flow
                  int currentStep = 0;
                  switch (status.toLowerCase()) {
                    case 'pending':
                      currentStep = 0;
                      break;
                    case 'processing':
                      currentStep = 1;
                      break;
                    case 'shipped':
                      currentStep = 2;
                      break;
                    case 'delivered':
                      currentStep = 3;
                      break;
                    default:
                      currentStep = 0;
                  }

                  return Column(
                    children: [
                      _TimelineTile(
                        title: "Order Placed",
                        date: timeago.format(order.createdAt),
                        isCompleted:
                            currentStep >=
                            0, // Always true unless cancelled/error
                        isFirst: true,
                      ),
                      _TimelineTile(
                        title: "Processing",
                        date: currentStep >= 1 ? "In Progress" : "Pending...",
                        isCompleted: currentStep >= 1,
                      ),
                      _TimelineTile(
                        title: "Shipped",
                        date: currentStep >= 2 ? "Shipped" : "Pending...",
                        isCompleted: currentStep >= 2,
                      ),
                      _TimelineTile(
                        title: "Delivered",
                        date: currentStep >= 3 ? "Delivered" : "Pending...",
                        isCompleted: currentStep >= 3,
                        isLast: true,
                      ),
                    ],
                  );
                },
              ),

              // const SizedBox(height: 30),

              // 3. Dynamic Action Button
              // BlocBuilder<OrderBloc, OrderState>(
              //   builder: (context, state) {
              //      if (state.isLoading) {
              //        return const Center(child: CircularProgressIndicator());
              //      }

              //     if (status == "Shipped") {
              //        return Column(
              //          children: [
              //            CustomElevatedButton(
              //              text: "View Delivery QR",
              //              onPressed: () {
              //                 context.read<OrderBloc>().add(GetDeliveryQREvent(order.id!));
              //              },
              //              backgroundColor: primaryGreen,
              //            ),
              //            const SizedBox(height: 8),
              //            Center(
              //              child: Text(
              //                "Show this code to the delivery agent to confirm receipt.",
              //                style: GoogleFonts.poppins(
              //                  fontSize: 11,
              //                  color: darkText,
              //                  fontWeight: FontWeight.w600,
              //                ),
              //              ),
              //            ),
              //          ],
              //        );
              //      } else if (status.toLowerCase() == 'cancelled') {
              //         return const CustomElevatedButton(
              //           text: "Order Cancelled",
              //           onPressed: null,
              //           backgroundColor: Colors.grey,
              //         );
              //      } else if (status == "Delivered") {
              //         //  return const SizedBox.shrink(); // Hide button for delivered if not using QR
              //         return const CustomElevatedButton(
              //           text: "View Delivery QR",
              //           onPressed: null,
              //           backgroundColor: Colors.grey,
              //         );
              //        return CustomElevatedButton(
              //          text: "Cancel the Order",
              //          onPressed: () {
              //             showDialog(
              //               context: context,
              //               builder: (context) => AlertDialog(
              //                 title: const Text("Cancel Order"),
              //                 content: const Text("Are you sure you want to cancel this order?"),
              //                 actions: [
              //                   TextButton(
              //                     onPressed: () => Navigator.pop(context),
              //                     child: const Text("No"),
              //                   ),
              //                   TextButton(
              //                     onPressed: () {
              //                       Navigator.pop(context);
              //                       context.read<OrderBloc>().add(CancelOrderEvent(order.id!));
              //                     },
              //                     child: const Text("Yes", style: TextStyle(color: Colors.red)),
              //                   ),
              //                 ],
              //               ),
              //             );
              //          },
              //          backgroundColor: const Color(0xFFD32F2F), // Red
              //        );
              //      }
              //   },
              // ),
              BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (status == "Shipped") {
                    return Column(
                      children: [
                        CustomElevatedButton(
                          text: "View Delivery QR",
                          onPressed: () {
                            context.read<OrderBloc>().add(
                              GetDeliveryQREvent(order.id!),
                            );
                          },
                          backgroundColor: primaryGreen,
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            "Show this code to the delivery agent to confirm receipt.",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: darkText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (status.toLowerCase() == 'cancelled') {
                    return const CustomElevatedButton(
                      text: "Order Cancelled",
                      onPressed: null,
                      backgroundColor: Colors.grey,
                    );
                  } else if (status.toLowerCase() == 'delivered') {
                    return const CustomElevatedButton(
                      text: "Order Delivered",
                      onPressed: null,
                      backgroundColor: Colors.grey,
                    );
                  } else {
                    // For pending, processing, or other statuses - show cancel button
                    return CustomElevatedButton(
                      text: "Cancel the Order",
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Cancel Order"),
                            content: const Text(
                              "Are you sure you want to cancel this order?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("No"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.read<OrderBloc>().add(
                                    CancelOrderEvent(order.id!),
                                  );
                                },
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      backgroundColor: const Color(0xFFD32F2F), // Red
                    );
                  }
                },
              ),

              const SizedBox(height: 30),

              // 4. Delivery Address Card
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivery Address",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(LucideIcons.mapPin, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mobile: ${order.phone}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: darkText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${order.shippingAddress}, ${order.city}",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// CUSTOM TIMELINE WIDGET
// -----------------------------------------------------------------------------
class _TimelineTile extends StatelessWidget {
  final String title;
  final String date;
  final bool isCompleted;
  final bool isFirst;
  final bool isLast;
  final Color? customColor;

  const _TimelineTile({
    required this.title,
    required this.date,
    required this.isCompleted,
    this.isFirst = false,
    this.isLast = false,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF3A7F5F);
    final Color activeColor = customColor ?? primaryGreen;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Line and Dot
          Column(
            children: [
              // Circle
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: isCompleted ? activeColor : Colors.grey[400],
                  shape: BoxShape.circle,
                ),
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
              // Line
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 3,
                    color: isCompleted ? activeColor : Colors.grey[300],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Text Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 32.0,
              ), // Spacing between steps
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: const Color(0xFF1B3A29),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1B3A29),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

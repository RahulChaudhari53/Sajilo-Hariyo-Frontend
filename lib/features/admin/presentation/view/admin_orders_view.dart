import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view/admin_order_detail_view.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_order_bloc/admin_order_bloc.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_order_bloc/admin_order_event.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_order_bloc/admin_order_state.dart';
import 'package:sajilo_hariyo/features/orders/domain/entity/order_entity.dart';

class AdminOrdersView extends StatefulWidget {
  const AdminOrdersView({super.key});

  @override
  State<AdminOrdersView> createState() => _AdminOrdersViewState();
}

class _AdminOrdersViewState extends State<AdminOrdersView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ["New Orders", "Processing", "Shipped", "Delivered", "Cancelled"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    context.read<AdminOrderBloc>().add(const LoadAdminOrdersEvent(status: "New Orders"));
  }

  void _handleTabSelection() {

    if (!_tabController.indexIsChanging) {

       final status = _tabs[_tabController.index];
       if(context.read<AdminOrderBloc>().state.currentFilter != status){
         context.read<AdminOrderBloc>().add(LoadAdminOrdersEvent(status: status));
       }
    } else {
       // Is tap
       final status = _tabs[_tabController.index];
       context.read<AdminOrderBloc>().add(LoadAdminOrdersEvent(status: status));
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending': return Colors.orange;
      case 'Processing': return Colors.yellow.shade800;
      case 'Shipped': return Colors.blue;
      case 'Delivered': return const Color(0xFF3A7F5F);
      case 'Cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3ED),
      appBar: AppBar(
        title: Text("Manage Orders", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: const Color(0xFF3A7F5F),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF3A7F5F),
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
          onTap: (index) {
             // Listener handles
          },
        ),
      ),
      body: BlocBuilder<AdminOrderBloc, AdminOrderState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text(state.error!, style: GoogleFonts.poppins(color: Colors.red)));
          }
          if (state.orders.isEmpty) {
            return Center(child: Text("No orders found", style: GoogleFonts.poppins(color: Colors.grey)));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.orders.length,
            separatorBuilder: (c, i) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return _buildOrderCard(context, order);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderEntity order) {
    final statusColor = _getStatusColor(order.status);

    return GestureDetector(
      onTap: () {
        final bloc = context.read<AdminOrderBloc>();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: bloc,
              child: AdminOrderDetailView(order: order),
            ),
          ),
        ).then((_) {
          // Refresh list when returning, just in case
           context.read<AdminOrderBloc>().add(LoadAdminOrdersEvent(status: context.read<AdminOrderBloc>().state.currentFilter));
        });
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
             )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ORD - ${order.id?.substring(order.id!.length - 6).toUpperCase() ?? ''}",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.status,
                    style: GoogleFonts.poppins(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                 const Icon(LucideIcons.calendar, size: 14, color: Colors.grey),
                 const SizedBox(width: 6),
                 Text(
                   order.createdAt.toIso8601String().split('T')[0],
                   style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
                 ),
                 const SizedBox(width: 16),
                 const Icon(LucideIcons.banknote, size: 14, color: Colors.grey),
                 const SizedBox(width: 6),
                 Text(
                   "Rs. ${order.totalAmount}",
                   style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
                 ),
              ],
            ),
             const SizedBox(height: 12),
             const SizedBox(height: 8),
              // Row(
              //   children: [
              //     const Icon(LucideIcons.user, size: 16, color: Color(0xFF3A7F5F)),
              //     const SizedBox(width: 8),
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             order.shippingAddress,
              //             style: GoogleFonts.poppins(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w500,
              //               color: const Color(0xFF1B3A29),
              //             ),
              //             maxLines: 1,
              //             overflow: TextOverflow.ellipsis,
              //           ),
              //           Text(
              //             order.city,
              //             style: GoogleFonts.poppins(
              //               fontSize: 12,
              //               color: Colors.grey,
              //             ),
              //             maxLines: 1,
              //             overflow: TextOverflow.ellipsis,
              //           ),
              //         ],
              //       ),
              //     ),
              //     const Icon(LucideIcons.chevronRight, size: 16, color: Colors.grey),
              //   ],
              // )
              Row(
  children: [
    const Icon(LucideIcons.user, size: 16, color: Color(0xFF3A7F5F)),
    const SizedBox(width: 8),
    Expanded(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: order.shippingAddress,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1B3A29),
              ),
            ),
            TextSpan(
              text: ' • ',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            TextSpan(
              text: order.city,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        maxLines: null, // Allows wrapping to multiple lines
      ),
    ),
    const SizedBox(width: 8),
    const Icon(LucideIcons.chevronRight, size: 16, color: Colors.grey),
  ],
),
          ],
        ),
      ),
    );
  }
}

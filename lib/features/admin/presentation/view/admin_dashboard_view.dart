import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/core/common/custom_text_form_field.dart';
import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_dashboard_bloc/admin_dashboard_bloc.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_dashboard_bloc/admin_dashboard_event.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_dashboard_bloc/admin_dashboard_state.dart';
import 'package:sajilo_hariyo/features/notification/presentation/view/notification_view.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<AdminDashboardBloc>().add(LoadAdminDashboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3ED),
      appBar: AppBar(
        title: Text(
          "Admin Dashboard",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const Icon(LucideIcons.bell),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationView(),
                  ),
                );
              },
            ),
          ),
          // IconButton(
          //   icon: const Icon(LucideIcons.refreshCw),
          //   onPressed: () {
          //     context.read<AdminDashboardBloc>().add(LoadAdminDashboardEvent());
          //   },
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCategoryDialog(context),
        label: const Text("Add Category"),
        icon: const Icon(LucideIcons.plus),
        backgroundColor: const Color(0xFF3A7F5F),
      ),
      body: BlocConsumer<AdminDashboardBloc, AdminDashboardState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            MySnackBar.showSuccess(
              context: context,
              message: state.successMessage!,
            );
          }

          if (state.error != null) {
            MySnackBar.showError(context: context, message: state.error!);
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.stats == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<AdminDashboardBloc>().add(LoadAdminDashboardEvent());
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics:
                  const AlwaysScrollableScrollPhysics(), // Needed for RefreshIndicator
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsSection(state),
                  const SizedBox(height: 24),
                  _buildCategoriesSection(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsSection(AdminDashboardState state) {
    if (state.stats == null) return const SizedBox();

    final stats = state.stats!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Overview",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(
              "Total Sales",
              "Rs ${stats.totalSales}",
              LucideIcons.dollarSign,
              Colors.green,
            ),
            _buildStatCard(
              "Total Orders",
              "${stats.totalOrders}",
              LucideIcons.shoppingBag,
              Colors.blue,
            ),
            _buildStatCard(
              "Pending",
              "${stats.pendingOrders}",
              LucideIcons.clock,
              Colors.orange,
            ),
            _buildStatCard(
              "Processing",
              "${stats.processingOrders}",
              LucideIcons.loader,
              Colors.indigo,
            ),
            _buildStatCard(
              "Shipped",
              "${stats.shippedOrders}",
              LucideIcons.truck,
              Colors.purple,
            ),
            _buildStatCard(
              "Delivered",
              "${stats.deliveredOrders}",
              LucideIcons.checkCircle,
              Colors.teal,
            ),
            _buildStatCard(
              "Low Stock",
              "${stats.lowStockCount}",
              LucideIcons.alertTriangle,
              Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B3A29),
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(AdminDashboardState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Categories",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (state.categories.isEmpty)
          const Center(child: Text("No categories found")),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.categories.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final category = state.categories[index];
            return Dismissible(
              key: Key(category.id!),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: Colors.red[400],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.trash2, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Delete Category?"),
                    content: Text(
                      "Are you sure you want to delete '${category.name}'?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );
              },
              onDismissed: (_) {
                context.read<AdminDashboardBloc>().add(
                  DeleteCategoryEvent(category.id!),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDEEAD8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        LucideIcons.flower2,
                        color: Color(0xFF3A7F5F),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (category.description != null &&
                              category.description!.isNotEmpty)
                            Text(
                              category.description!,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add New Category"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                controller: nameController,
                labelText: "Category Name",
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: descController,
                labelText: "Description",
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<AdminDashboardBloc>().add(
                  CreateCategoryEvent(
                    name: nameController.text,
                    description: descController.text,
                  ),
                );
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3A7F5F),
              foregroundColor: Colors.white,
            ),
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}

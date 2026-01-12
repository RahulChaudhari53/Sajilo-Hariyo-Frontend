import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/core/common/custom_elevated_button.dart';
import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view/add_address_view.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/address_bloc/address_bloc.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/address_bloc/address_event.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/address_bloc/address_state.dart';
import 'package:sajilo_hariyo/features/profile/domain/entity/address_entity.dart';

class ShippingAddressView extends StatefulWidget {
  const ShippingAddressView({super.key});

  @override
  State<ShippingAddressView> createState() => _ShippingAddressViewState();
}

class _ShippingAddressViewState extends State<ShippingAddressView> {
  // Colors
  final Color primaryGreen = const Color(0xFF3A7F5F);
  final Color cardColor = const Color(0xFFF8F3ED);
  final Color darkText = const Color(0xFF1B3A29);

  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(LoadAddressesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: darkText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Shipping Address",
          style: GoogleFonts.poppins(
            color: darkText,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: BlocListener<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state.message != null && state.status == AddressStatus.success) {
            MySnackBar.showSuccess(context: context, message: state.message!);
          }
          if (state.status == AddressStatus.failure && state.message != null) {
            MySnackBar.showError(context: context, message: state.message!);
          }
        },
        child: Column(
          children: [
            // ADDRESS LIST
            Expanded(
              child: BlocBuilder<AddressBloc, AddressState>(
                builder: (context, state) {
                  if (state.status == AddressStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.addresses.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: state.addresses.length,
                    itemBuilder: (context, index) {
                      final item = state.addresses[index];
                      return _buildAddressCard(item);
                    },
                  );
                },
              ),
            ),

            // ADD BUTTON
            Padding(
              padding: const EdgeInsets.all(20),
              child: BlocBuilder<AddressBloc, AddressState>(
                builder: (context, state) {
                  final isLimitReached = state.addresses.length >= 2;
                  return CustomElevatedButton(
                    text: isLimitReached
                        ? "Address Limit Reached"
                        : "Add New Address",
                    onPressed: () {
                      if (isLimitReached) {
                        MySnackBar.showError(
                          context: context,
                          message: "You can only add up to 2 addresses",
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddAddressView(),
                        ),
                      );
                    },
                    backgroundColor: isLimitReached
                        ? Colors.grey
                        : primaryGreen,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(AddressEntity item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.transparent,
        ), // Placeholder for default check
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Label
              Row(
                children: [
                  Icon(
                    item.label.toLowerCase() == "home"
                        ? LucideIcons.home
                        : LucideIcons.briefcase,
                    size: 18,
                    color: primaryGreen,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.label,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: darkText,
                    ),
                  ),
                ],
              ),
              // Options Menu (Edit/Delete)
              PopupMenuButton(
                icon: Icon(
                  LucideIcons.moreVertical,
                  size: 20,
                  color: Colors.grey[400],
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text("Edit", style: GoogleFonts.poppins()),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      "Delete",
                      style: GoogleFonts.poppins(color: Colors.red),
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'delete') {
                    if (item.id != null) {
                      context.read<AddressBloc>().add(
                        DeleteAddressEvent(item.id!),
                      );
                    }
                  } else if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddAddressView(addressToEdit: item),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "${item.street}, ${item.city}",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: darkText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.detail,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            "Phone: ${item.phone}",
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.mapPinOff, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No Saved Addresses",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

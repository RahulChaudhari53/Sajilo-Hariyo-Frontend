import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/core/common/custom_elevated_button.dart';
import 'package:sajilo_hariyo/core/common/custom_text_form_field.dart';
import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
import 'package:sajilo_hariyo/features/profile/domain/entity/address_entity.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/address_bloc/address_bloc.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/address_bloc/address_event.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/address_bloc/address_state.dart';

class AddAddressView extends StatefulWidget {
  final AddressEntity? addressToEdit;

  const AddAddressView({super.key, this.addressToEdit});

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController cityController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String _selectedLabel = "Home";

  // Colors
  final Color primaryGreen = const Color(0xFF3A7F5F);
  final Color cardColor = const Color(0xFFF8F3ED);
  final Color darkText = const Color(0xFF1B3A29);

  @override
  void initState() {
    super.initState();
    if (widget.addressToEdit != null) {
      final data = widget.addressToEdit!;
      phoneController.text = data.phone;
      detailController.text = data.detail;
      streetController.text = data.street;
      cityController.text = data.city;
      _selectedLabel = data.label;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic Title
    final String pageTitle = widget.addressToEdit == null
        ? "Add New Address"
        : "Edit Address";
    final String buttonText = widget.addressToEdit == null
        ? "Save Address"
        : "Update Address";

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
          pageTitle,
          style: GoogleFonts.poppins(
            color: darkText,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: BlocListener<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state.status == AddressStatus.success && state.message != null) {
            MySnackBar.showSuccess(context: context, message: state.message!);
            Navigator.pop(context);
          }
          if (state.status == AddressStatus.failure && state.message != null) {
            MySnackBar.showError(context: context, message: state.message!);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Contact Details",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 16),

                CustomTextFormField(
                  controller: phoneController,
                  labelText: "Phone Number",
                  hintText: "98XXXXXXXX",
                  prefixIcon: LucideIcons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (val) => val!.isEmpty ? "Required" : null,
                ),

                const SizedBox(height: 24),
                Text(
                  "Address Details",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 16),

                CustomTextFormField(
                  controller: cityController,
                  labelText: "City / District",
                  hintText: "Kathmandu",
                  prefixIcon: LucideIcons.map,
                  validator: (val) => val!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 16),

                CustomTextFormField(
                  controller: streetController,
                  labelText: "Street / Area",
                  hintText: "Lazimpat Road",
                  prefixIcon: LucideIcons.mapPin,
                  validator: (val) => val!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 16),

                CustomTextFormField(
                  controller: detailController,
                  labelText: "House No / Landmark",
                  hintText: "Near Radisson Hotel, House 123",
                  prefixIcon: LucideIcons.home,
                  validator: (val) => val!.isEmpty ? "Required" : null,
                ),

                const SizedBox(height: 24),
                Text(
                  "Label as",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: ["Home", "Work", "Other"].map((label) {
                    final isSelected = _selectedLabel == label;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedLabel = label),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? primaryGreen : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: isSelected
                              ? null
                              : Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          label,
                          style: GoogleFonts.poppins(
                            color: isSelected ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 40),

                BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, state) {
                    if (state.status == AddressStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return CustomElevatedButton(
                      text: buttonText,
                      backgroundColor: primaryGreen,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final address = AddressEntity(
                            id: widget.addressToEdit?.id,
                            city: cityController.text.trim(),
                            street: streetController.text.trim(),
                            detail: detailController.text.trim(),
                            phone: phoneController.text.trim(),
                            label: _selectedLabel,
                          );

                          if (widget.addressToEdit == null) {
                            context.read<AddressBloc>().add(AddAddressEvent(address));
                          } else {
                            context.read<AddressBloc>().add(UpdateAddressEvent(address));
                          }
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


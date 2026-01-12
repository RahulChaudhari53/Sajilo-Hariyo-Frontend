import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/core/common/custom_elevated_button.dart';
import 'package:sajilo_hariyo/core/common/custom_text_form_field.dart';
import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/profile_bloc/profile_bloc.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/profile_bloc/profile_event.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/profile_bloc/profile_state.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors
    const Color primaryGreen = Color(0xFF3A7F5F);
    const Color cardColor = Color(0xFFF8F3ED);
    const Color darkText = Color(0xFF1B3A29);

    // Controllers
    final TextEditingController oldPassController = TextEditingController();
    final TextEditingController newPassController = TextEditingController();
    final TextEditingController confirmPassController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // Visibility Toggles (One for each field)
    final ValueNotifier<bool> obscureOld = ValueNotifier(true);
    final ValueNotifier<bool> obscureNew = ValueNotifier(true);
    final ValueNotifier<bool> obscureConfirm = ValueNotifier(true);

    return Scaffold(
      backgroundColor: cardColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: darkText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Change Password",
          style: GoogleFonts.poppins(
            color: darkText,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.success && state.message != null) {
            MySnackBar.showSuccess(
                context: context, message: state.message!);
            Navigator.pop(context);
          }
          if (state.status == ProfileStatus.failure && state.message != null) {
            MySnackBar.showError(context: context, message: state.message!);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // Instructions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.info, color: Colors.blue, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Your new password must be different from previous used passwords.",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // 1. OLD PASSWORD
                ValueListenableBuilder<bool>(
                  valueListenable: obscureOld,
                  builder: (context, isObscure, _) {
                    return CustomTextFormField(
                      controller: oldPassController,
                      labelText: "Old Password",
                      hintText: "••••••••",
                      prefixIcon: LucideIcons.lock,
                      obscureText: isObscure,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscure ? LucideIcons.eye : LucideIcons.eyeOff,
                          color: darkText,
                        ),
                        onPressed: () => obscureOld.value = !isObscure,
                      ),
                      validator: (val) => val!.isEmpty ? "Required" : null,
                    );
                  },
                ),
                const SizedBox(height: 20),

                // 2. NEW PASSWORD
                ValueListenableBuilder<bool>(
                  valueListenable: obscureNew,
                  builder: (context, isObscure, _) {
                    return CustomTextFormField(
                      controller: newPassController,
                      labelText: "New Password",
                      hintText: "••••••••",
                      prefixIcon: LucideIcons.key,
                      obscureText: isObscure,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscure ? LucideIcons.eye : LucideIcons.eyeOff,
                          color: darkText,
                        ),
                        onPressed: () => obscureNew.value = !isObscure,
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return "Required";
                        if (val.length < 8)
                          return "Must be at least 8 characters";
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),

                // 3. CONFIRM PASSWORD
                ValueListenableBuilder<bool>(
                  valueListenable: obscureConfirm,
                  builder: (context, isObscure, _) {
                    return CustomTextFormField(
                      controller: confirmPassController,
                      labelText: "Confirm Password",
                      hintText: "••••••••",
                      prefixIcon: LucideIcons.checkCircle,
                      obscureText: isObscure,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscure ? LucideIcons.eye : LucideIcons.eyeOff,
                          color: darkText,
                        ),
                        onPressed: () => obscureConfirm.value = !isObscure,
                      ),
                      validator: (val) {
                        if (val != newPassController.text)
                          return "Passwords do not match";
                        return null;
                      },
                    );
                  },
                ),

                const SizedBox(height: 40),

                // SUBMIT BUTTON
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    return CustomElevatedButton(
                      text: "Update Password",
                      isLoading: state.status == ProfileStatus.loading,
                      backgroundColor: primaryGreen,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<ProfileBloc>().add(
                                ChangePasswordEvent(
                                  oldPassword: oldPassController.text,
                                  newPassword: newPassController.text,
                                ),
                              );
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


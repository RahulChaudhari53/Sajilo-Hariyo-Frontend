import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/core/common/custom_elevated_button.dart';
import 'package:sajilo_hariyo/core/common/custom_text_form_field.dart';
import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/reset_password_viewmodel/reset_password_event.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/reset_password_viewmodel/reset_password_state.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/reset_password_viewmodel/reset_password_viewmodel.dart';

class ResetPasswordView extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordView({super.key, required this.email, required this.otp});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  final ValueNotifier<bool> _obscureNewPass = ValueNotifier(true);
  final ValueNotifier<bool> _obscureConfirmPass = ValueNotifier(true);

  // Real-time validation state
  bool _hasMinLength = false;
  bool _hasSymbol = false;
  bool _hasNumber = false;

  @override
  void initState() {
    super.initState();
    passController.addListener(_validatePassword);
  }

  void _validatePassword() {
    final text = passController.text;
    setState(() {
      _hasMinLength = text.length >= 8;
      _hasSymbol = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(text);
      _hasNumber = RegExp(r'[0-9]').hasMatch(text);
    });
  }

  @override
  void dispose() {
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF3A7F5F);
    const Color cardColor = Color(0xFFF8F3ED);
    const Color darkText = Color(0xFF1B3A29);
    const Color borderColor = Color(0xFFA09E9E);

    return Scaffold(
      backgroundColor: primaryGreen,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ResetPasswordViewModel, ResetPasswordState>(
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 10),
                const Icon(LucideIcons.key, size: 80, color: Colors.white70),
                const SizedBox(height: 30),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Reset Password",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: darkText,
                            ),
                          ),
                          const SizedBox(height: 30),

                          Theme(
                            data: Theme.of(context).copyWith(
                              inputDecorationTheme: InputDecorationTheme(
                                filled: true,
                                fillColor: Colors.white,
                                prefixIconColor: darkText,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: borderColor,
                                  ),
                                ),
                              ),
                            ),
                              child: Column(
                                children: [
                                  ValueListenableBuilder<bool>(
                                    valueListenable: _obscureNewPass,
                                    builder: (context, isObscure, _) {
                                      return CustomTextFormField(
                                        controller: passController,
                                        labelText: "New Password",
                                        hintText: "••••••••",
                                        obscureText: isObscure,
                                        prefixIcon: LucideIcons.lock,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            isObscure
                                                ? LucideIcons.eye
                                                : LucideIcons.eyeOff,
                                            color: darkText,
                                          ),
                                          onPressed: () => _obscureNewPass.value =
                                              !_obscureNewPass.value,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  ValueListenableBuilder<bool>(
                                    valueListenable: _obscureConfirmPass,
                                    builder: (context, isObscure, _) {
                                      return CustomTextFormField(
                                        controller: confirmPassController,
                                        labelText: "Confirm Password",
                                        hintText: "••••••••",
                                        obscureText: isObscure,
                                        prefixIcon: LucideIcons.lock,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            isObscure
                                                ? LucideIcons.eye
                                                : LucideIcons.eyeOff,
                                            color: darkText,
                                          ),
                                          onPressed: () =>
                                              _obscureConfirmPass.value =
                                                  !_obscureConfirmPass.value,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                          ),

                          const SizedBox(height: 20),

                          // REAL-TIME VALIDATION LIST
                          _ValidationRow(
                            text: "At least 8 characters long",
                            isValid: _hasMinLength,
                          ),
                          const SizedBox(height: 8),
                          _ValidationRow(
                            text: "At least one symbol (!@#\$)",
                            isValid: _hasSymbol,
                          ),
                          const SizedBox(height: 8),
                          _ValidationRow(
                            text: "At least one number",
                            isValid: _hasNumber,
                          ),

                          const SizedBox(height: 30),

                          CustomElevatedButton(
                            text: "Reset Password",
                            isLoading: state.isLoading,
                            backgroundColor: primaryGreen,
                            onPressed: () {
                              if (_hasMinLength && _hasSymbol && _hasNumber) {
                                if (passController.text ==
                                    confirmPassController.text) {
                                  context.read<ResetPasswordViewModel>().add(
                                    SubmitResetPasswordEvent(
                                      context: context,
                                      email: widget.email,
                                      otp: widget.otp,
                                      password: passController.text,
                                    ),
                                  );
                                } else {
                                  MySnackBar.showError(
                                    context: context,
                                    message: "Passwords do not match",
                                  );
                                }
                              } else {
                                MySnackBar.showError(
                                  context: context,
                                  message: "Password requirement not met",
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ValidationRow extends StatelessWidget {
  final String text;
  final bool isValid;

  const _ValidationRow({required this.text, required this.isValid});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isValid ? LucideIcons.checkCircle : LucideIcons.xCircle,
          color: isValid ? const Color(0xFF3A7F5F) : Colors.grey,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: isValid ? const Color(0xFF3A7F5F) : Colors.grey,
          ),
        ),
      ],
    );
  }
}

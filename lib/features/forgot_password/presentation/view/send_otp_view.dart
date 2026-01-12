import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/core/common/custom_elevated_button.dart';
import 'package:sajilo_hariyo/core/common/custom_text_form_field.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/send_otp_viewmodel/send_otp_event.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/send_otp_viewmodel/send_otp_state.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/send_otp_viewmodel/send_otp_viewmodel.dart';

class SendOtpView extends StatelessWidget {
  const SendOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // Design Colors
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
        child: BlocBuilder<SendOtpViewModel, SendOtpState>(
          builder: (context, state) {
            return Column(
              children: [
                // Top Icon
                const SizedBox(height: 10),
                const Icon(LucideIcons.lock, size: 80, color: Colors.white70),
                const SizedBox(height: 30),

                // Card
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
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Forgot Password?",
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: darkText,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Enter your email and we’ll send a OTP to your email address in order to reset password.",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Fields Theme Override
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
                              child: CustomTextFormField(
                                controller: emailController,
                                labelText: "Email Address",
                                hintText: "john@example.com",
                                prefixIcon: LucideIcons.mail,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'Email is required';
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 30),

                            CustomElevatedButton(
                              text: "Send OTP",
                              isLoading: state.isLoading,
                              backgroundColor: primaryGreen,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<SendOtpViewModel>().add(
                                    RequestOtpEvent(
                                      context: context,
                                      email: emailController.text.trim(),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pinput/pinput.dart';
import 'package:sajilo_hariyo/core/common/custom_elevated_button.dart';
import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/verify_otp_viewmodel/verify_otp_event.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/verify_otp_viewmodel/verify_otp_state.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/verify_otp_viewmodel/verify_otp_viewmodel.dart';

class VerifyOtpView extends StatelessWidget {
  final String email;
  const VerifyOtpView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();
    final ValueNotifier<int> secondsRemaining = ValueNotifier(20);
    final ValueNotifier<bool> canResend = ValueNotifier(false);
    Timer? timer;

    // Start Timer
    void startTimer() {
      secondsRemaining.value = 20;
      canResend.value = false;
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (secondsRemaining.value > 0) {
          secondsRemaining.value--;
        } else {
          canResend.value = true;
          t.cancel();
        }
      });
    }

    // Initialize Timer immediately
    startTimer();

    // Design Colors
    const Color primaryGreen = Color(0xFF3A7F5F);
    const Color cardColor = Color(0xFFF8F3ED);
    const Color darkText = Color(0xFF1B3A29);
    const Color borderColor = Color(0xFFA09E9E);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: GoogleFonts.poppins(
        fontSize: 22,
        color: darkText,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      backgroundColor: primaryGreen,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () {
            timer?.cancel();
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<VerifyOtpViewModel, VerifyOtpState>(
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 10),
                const Icon(
                  LucideIcons.shieldCheck,
                  size: 80,
                  color: Colors.white70,
                ),
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
                    child: Column(
                      children: [
                        Text(
                          "OTP Verification",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: darkText,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Please enter the code we sent to\n$email",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Pinput
                        Pinput(
                          length: 6,
                          controller: otpController,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: defaultPinTheme.copyDecorationWith(
                            border: Border.all(color: primaryGreen, width: 2),
                          ),
                        ),

                        const SizedBox(height: 30),

                        CustomElevatedButton(
                          text: "Verify OTP",
                          isLoading: state.isLoading,
                          backgroundColor: primaryGreen,
                          onPressed: () {
                            if (otpController.text.length == 6) {
                              context.read<VerifyOtpViewModel>().add(
                                SubmitVerifyOtpEvent(
                                  context: context,
                                  email: email,
                                  otp: otpController.text,
                                ),
                              );
                            } else {
                              MySnackBar.showError(
                                context: context,
                                message: "Enter valid 6-digit code",
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 20),

                        // Resend Logic using ValueListenableBuilder
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive code? ",
                              style: GoogleFonts.poppins(color: darkText),
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: canResend,
                              builder: (context, canResendValue, _) {
                                return canResendValue
                                    ? TextButton(
                                        onPressed: () {
                                          startTimer();
                                          MySnackBar.showInfo(
                                            context: context,
                                            message: "Resending OTP...",
                                          );
                                          context
                                              .read<VerifyOtpViewModel>()
                                              .add(
                                                ResendOtpEvent(
                                                  context: context,
                                                  email: email,
                                                ),
                                              );
                                        },
                                        child: Text(
                                          "Resend",
                                          style: GoogleFonts.poppins(
                                            color: primaryGreen,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : ValueListenableBuilder<int>(
                                        valueListenable: secondsRemaining,
                                        builder: (context, seconds, _) {
                                          return Text(
                                            "Resend in ${seconds}s",
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      );
                              },
                            ),
                          ],
                        ),
                      ],
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

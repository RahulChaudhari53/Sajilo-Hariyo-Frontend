import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/app/service_locator/service_locator.dart';
import 'package:sajilo_hariyo/core/common/custom_elevated_button.dart';
import 'package:sajilo_hariyo/core/common/custom_text_form_field.dart';
import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    //  Define Controllers & Keys
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    //  State Management
    final ValueNotifier<bool> obscurePassword = ValueNotifier(true);
    final ValueNotifier<bool> rememberMe = ValueNotifier(false);

    //  Colors
    const Color primaryGreen = Color(0xFF3A7F5F);
    const Color cardColor = Color(0xFFF8F3ED);
    const Color darkText = Color(0xFF1B3A29);
    const Color subText = Color(0xFF666666);
    const Color borderColor = Color(0xFFA09E9E);

    return BlocProvider(
      create: (_) => locator<LoginViewModel>(),
      child: Scaffold(
        backgroundColor: primaryGreen,
        body: SafeArea(
          // This creates a new 'context' that knows about the BlocProvider above it.
          child: Builder(
            builder: (context) {
              return BlocConsumer<LoginViewModel, LoginState>(
                listener: (context, state) {
                  if (state.isSuccess) {
                    MySnackBar.showSuccess(
                      context: context,
                      message: "Login Successful",
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      // --- TOP SECTION ---
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<LoginViewModel>().add(
                                      NavigateToRegisterViewEvent(
                                        context: context,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 100,
                              width: double.infinity,
                              child: Image.asset(
                                'assets/logo/app_logo_green.png',
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),

                      // --- BOTTOM CARD ---
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Welcome Back",
                                    style: GoogleFonts.poppins(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: darkText,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Enter your details below to access your account.",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: subText,
                                    ),
                                  ),
                                  const SizedBox(height: 30),

                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      inputDecorationTheme:
                                          InputDecorationTheme(
                                            filled: true,
                                            fillColor: Colors.white,
                                            prefixIconColor: darkText,
                                            suffixIconColor: darkText,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: borderColor,
                                              ),
                                            ),
                                          ),
                                    ),
                                    child: Column(
                                      children: [
                                        CustomTextFormField(
                                          controller: phoneController,
                                          labelText: "Phone Number",
                                          hintText: "98XXXXXXXX",
                                          prefixIcon: LucideIcons.phone,
                                          keyboardType: TextInputType.phone,
                                          validator: (value) {
                                            if (value == null || value.isEmpty)
                                              return 'Phone is required';
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        ValueListenableBuilder<bool>(
                                          valueListenable: obscurePassword,
                                          builder: (context, isObscure, _) {
                                            return CustomTextFormField(
                                              controller: passwordController,
                                              labelText: "Password",
                                              hintText: "••••••••",
                                              prefixIcon: LucideIcons.lock,
                                              obscureText: isObscure,
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  isObscure
                                                      ? LucideIcons.eye
                                                      : LucideIcons.eyeOff,
                                                  color: darkText,
                                                ),
                                                onPressed: () =>
                                                    obscurePassword.value =
                                                        !isObscure,
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty)
                                                  return 'Password is required';
                                                return null;
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          context.read<LoginViewModel>().add(
                                            NavigateToForgotPasswordViewEvent(
                                              context: context,
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Forgot Password?",
                                          style: GoogleFonts.poppins(
                                            color: darkText,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 24),

                                  CustomElevatedButton(
                                    text: "Login",
                                    backgroundColor: primaryGreen,
                                    isLoading: state.isLoading,
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        context.read<LoginViewModel>().add(
                                          LoginUserEvent(
                                            context: context,
                                            phone: phoneController.text.trim(),
                                            password: passwordController.text,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Divider(
                                          color: darkText,
                                          thickness: 0.5,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: Text(
                                          "or continue as a",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: subText,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: Divider(
                                          color: darkText,
                                          thickness: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        // Guest Logic later
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: darkText),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "Guest",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: darkText,
                                        ),
                                      ),
                                    ),
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
              );
            },
          ),
        ),
      ),
    );
  }
}

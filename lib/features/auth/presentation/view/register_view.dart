import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/app/service_locator/service_locator.dart';
import 'package:sajilo_hariyo/core/common/custom_elevated_button.dart';
import 'package:sajilo_hariyo/core/common/custom_text_form_field.dart';
import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // Password Toggle State
    final ValueNotifier<bool> isObscure = ValueNotifier<bool>(true);

    // Exact Colors from Figma/Request
    const Color primaryGreen = Color(0xFF3A7F5F);
    const Color cardColor = Color(0xFFF8F3ED);
    const Color darkText = Color(0xFF1B3A29);
    const Color subText = Color(0xFF666666);
    const Color borderColor = Color(0xFFA09E9E);

    return BlocProvider(
      create: (_) => locator<RegisterViewModel>(),
      child: Scaffold(
        backgroundColor: primaryGreen, // Top Background
        body: BlocConsumer<RegisterViewModel, RegisterState>(
          listener: (context, state) {
            if (state.isSuccess) {
              MySnackBar.showSuccess(
                context: context,
                message: "Account Created! Please Login.",
              );
              // Navigate back to Login
              Navigator.pop(context);
            }
            if (state.errorMessage != null) {
              MySnackBar.showError(
                context: context,
                message: state.errorMessage!,
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        // Top Right Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Already have an account?",
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Since Register is usually pushed ON TOP of Login, we just pop.
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Login",
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

                        // Logo
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: Image.asset('assets/logo/app_logo_green.png'),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // BOTTOM CARD (Form)
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
                              // Header
                              Text(
                                "Get Started for Free.",
                                style: GoogleFonts.poppins(
                                  fontSize:
                                      24, // Slightly smaller than Login to fit content
                                  fontWeight: FontWeight.bold,
                                  color: darkText,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Join our community of plant lovers and bring nature home.",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: subText,
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Override Theme for Borders
                              Theme(
                                data: Theme.of(context).copyWith(
                                  inputDecorationTheme: InputDecorationTheme(
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIconColor: darkText,
                                    suffixIconColor: darkText,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: borderColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: borderColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: darkText,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    // NAME
                                    CustomTextFormField(
                                      controller: nameController,
                                      labelText: "Full Name",
                                      hintText: "John Doe",
                                      prefixIcon: LucideIcons.user,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your name';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),

                                    // EMAIL
                                    CustomTextFormField(
                                      controller: emailController,
                                      labelText: "Email Address",
                                      hintText: "john@example.com",
                                      keyboardType: TextInputType.emailAddress,
                                      prefixIcon: LucideIcons.mail,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter email';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),

                                    // PHONE
                                    CustomTextFormField(
                                      controller: phoneController,
                                      labelText: "Phone Number",
                                      hintText: "98XXXXXXXX",
                                      keyboardType: TextInputType.phone,
                                      prefixIcon: LucideIcons.phone,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter phone number';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),

                                    // PASSWORD
                                    ValueListenableBuilder<bool>(
                                      valueListenable: isObscure,
                                      builder: (context, value, child) {
                                        return CustomTextFormField(
                                          controller: passwordController,
                                          labelText: "Password",
                                          hintText: "••••••••",
                                          obscureText: value,
                                          prefixIcon: LucideIcons.lock,
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              value
                                                  ? LucideIcons.eye
                                                  : LucideIcons.eyeOff,
                                              color: darkText,
                                            ),
                                            onPressed: () {
                                              isObscure.value =
                                                  !isObscure.value;
                                            },
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter password';
                                            }
                                            if (value.length < 6) {
                                              return 'Password too short';
                                            }
                                            return null;
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 30),

                              // SIGNUP BUTTON
                              CustomElevatedButton(
                                text: "Sign Up",
                                backgroundColor: primaryGreen,
                                textColor: Colors.white,
                                isLoading: state.isLoading,
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<RegisterViewModel>().add(
                                      RegisterUserEvent(
                                        name: nameController.text,
                                        email: emailController.text,
                                        phone: phoneController.text,
                                        password: passwordController.text,
                                      ),
                                    );
                                  }
                                },
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

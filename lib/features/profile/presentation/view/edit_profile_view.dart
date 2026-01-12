import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/app/constant/api_endpoints.dart';
import 'package:sajilo_hariyo/core/common/custom_elevated_button.dart';
import 'package:sajilo_hariyo/core/common/custom_text_form_field.dart';
import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
import 'package:sajilo_hariyo/features/auth/domain/entity/user_entity.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/profile_bloc/profile_bloc.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/profile_bloc/profile_event.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/profile_bloc/profile_state.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileBloc>().state.user;

    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF3A7F5F);
    const Color cardColor = Color(0xFFF8F3ED);
    const Color darkText = Color(0xFF1B3A29);

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
          "Edit Profile",
          style: GoogleFonts.poppins(
            color: darkText,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.success && state.message != null) {
            MySnackBar.showSuccess(
              context: context,
              message: state.message!,
            );
            Navigator.pop(context);
          }

          if (state.status == ProfileStatus.failure && state.message != null) {
            MySnackBar.showError(
              context: context,
              message: state.message!,
            );
          }
        },
        builder: (context, state) {
          final user = state.user;
          final existingImageUrl = user?.profileImage;

          ImageProvider avatarImage;

          if (_imageFile != null) {
            avatarImage = FileImage(_imageFile!);
          } else if (existingImageUrl != null &&
              existingImageUrl.isNotEmpty &&
              existingImageUrl != 'default.png') {
            avatarImage = NetworkImage(
              '${ApiEndpoints.serverAddress}/${existingImageUrl.replaceAll('\\', '/')}',
            );
          } else {
            avatarImage =
                const AssetImage('assets/images/onboarding1.png');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // PROFILE IMAGE
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryGreen,
                              width: 2,
                            ),
                            image: DecorationImage(
                              image: avatarImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primaryGreen,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: cardColor,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              LucideIcons.camera,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // NAME
                  CustomTextFormField(
                    controller: _nameController,
                    labelText: "Full Name",
                    hintText: "Enter your name",
                    prefixIcon: LucideIcons.user,
                    validator: (val) =>
                        val == null || val.isEmpty ? "Required" : null,
                  ),

                  const SizedBox(height: 16),

                  // EMAIL (NEW)
                  CustomTextFormField(
                    controller: _emailController,
                    labelText: "Email Address",
                    hintText: "Enter your email",
                    prefixIcon: LucideIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Required";
                      }
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(val)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // PHONE
                  CustomTextFormField(
                    controller: _phoneController,
                    labelText: "Phone Number",
                    hintText: "Enter your phone",
                    prefixIcon: LucideIcons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (val) =>
                        val == null || val.isEmpty ? "Required" : null,
                  ),

                  const SizedBox(height: 48),

                  state.status == ProfileStatus.loading
                      ? const CircularProgressIndicator()
                      : CustomElevatedButton(
                          text: "Update Profile",
                          backgroundColor: primaryGreen,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final updatedUser = UserEntity(
                                id: user?.id,
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                phone: _phoneController.text.trim(),
                                profileImage: user?.profileImage,
                              );

                              context.read<ProfileBloc>().add(
                                    UpdateProfileEvent(
                                      user: updatedUser,
                                      imageFile: _imageFile,
                                    ),
                                  );
                            }
                          },
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

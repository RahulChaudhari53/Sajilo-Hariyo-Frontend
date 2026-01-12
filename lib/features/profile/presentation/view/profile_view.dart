import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/app/constant/api_endpoints.dart';
import 'package:sajilo_hariyo/app/service_locator/service_locator.dart';
import 'package:sajilo_hariyo/app/shared_pref/token_shared_pref.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view/login_view.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view_model/user_cubit/user_cubit.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view/edit_profile_view.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view/help_support_view.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view/my_favorites_view.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view/settings_view.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view/shipping_address_view.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/profile_bloc/profile_bloc.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/profile_bloc/profile_event.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/profile_bloc/profile_state.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF3A7F5F);
    const Color cardColor = Color(0xFFF8F3ED);
    const Color darkText = Color(0xFF1B3A29);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFF8F3ED), 
        statusBarIconBrightness:
            Brightness.dark, 
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: cardColor,
        appBar: AppBar(
          backgroundColor: cardColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFFF8F3ED),
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          title: Text(
            "Profile and Settings",
            style: GoogleFonts.poppins(
              color: darkText,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                //  IMPROVED PROFILE HEADER
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state.status == ProfileStatus.loading) {
                      return const CircularProgressIndicator();
                    }

                    final user = state.user;
                    ImageProvider image;
                    if (user?.profileImage != null &&
                        user!.profileImage!.isNotEmpty) {
                      final imgPath = user.profileImage!;
                      if (imgPath.startsWith('http')) {
                        image = NetworkImage(imgPath);
                      } else {
                        image = NetworkImage(
                          '${ApiEndpoints.serverAddress}/${imgPath.replaceAll('\\', '/')}',
                        );
                      }
                    } else {
                      image = const AssetImage('assets/images/onboarding1.png');
                    }

                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryGreen.withOpacity(0.1), Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: primaryGreen.withOpacity(0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Profile Image with Glow Effect
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditProfileView(),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                // Outer glow circle
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        primaryGreen.withOpacity(0.2),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                                // Main profile image
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: primaryGreen,
                                      width: 3,
                                    ),
                                    image: DecorationImage(
                                      image: image,
                                      fit: BoxFit.cover,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryGreen.withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                ),
                                // Edit button
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: primaryGreen,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryGreen.withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      LucideIcons.edit2,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Name
                          Text(
                            user?.name ?? "User Name",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: darkText,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Email & Phone in Cards
                          Row(
                            children: [
                              // Email Card
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        LucideIcons.mail,
                                        color: primaryGreen,
                                        size: 20,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Email",
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        user?.email ?? "email@example.com",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: darkText,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Phone Card
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        LucideIcons.phone,
                                        color: primaryGreen,
                                        size: 20,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Phone",
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        user?.phone ?? "Phone Number",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: darkText,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                //  MENU OPTIONS
                _ProfileMenuTile(
                  icon: LucideIcons.heart,
                  title: "My Favorites",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyFavoritesView(),
                      ),
                    );
                  },
                ),

                _ProfileMenuTile(
                  icon: LucideIcons.settings,
                  title: "Settings",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsView(),
                      ),
                    );
                  },
                ),

                _ProfileMenuTile(
                  icon: LucideIcons.mapPin,
                  title: "Shipping Address",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShippingAddressView(),
                      ),
                    );
                  },
                ),

                _ProfileMenuTile(
                  icon: LucideIcons.helpCircle,
                  title: "Help & Support",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpSupportView(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // LOGOUT BUTTON
                GestureDetector(
                  onTap: () async {
                    await locator<TokenSharedPref>().clearToken();
                    if (context.mounted) {
                      await context.read<UserCubit>().clearUser();
                    }

                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginView()),
                        (route) => false,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Logout",
                        style: GoogleFonts.poppins(
                          color: Colors.red.shade400,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper Widget for Menu Tiles
class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F3ED),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF3A7F5F), size: 20),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1B3A29),
              ),
            ),
            const Spacer(),
            const Icon(LucideIcons.chevronRight, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/app/service_locator/service_locator.dart';
import 'package:sajilo_hariyo/app/theme/theme_data.dart';
import 'package:sajilo_hariyo/features/onboarding/presentation/view_model/onboarding_cubit.dart';
import 'package:sajilo_hariyo/features/onboarding/presentation/view_model/onboarding_state.dart';

// Helper Model
class OnboardingItem {
  final String title;
  final String description;
  final String imagePath;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();

    final List<OnboardingItem> data = [
      OnboardingItem(
        title: "Bring Nature Home",
        description:
            "Explore a wide variety of indoor and outdoor plants that purify your air and calm your mind.",
        imagePath: "assets/images/onboarding1.png",
      ),
      OnboardingItem(
        title: "Try Before You Buy",
        description:
            "Not sure if it fits? Use our AR feature to place plants virtually in your room before you order.",
        imagePath: "assets/images/onboarding2.png",
      ),
      OnboardingItem(
        title: "Delivered with Care",
        description:
            "We deliver safely to your doorstep with easy-to-follow care guides for every plant.",
        imagePath: "assets/images/onboarding3.png",
      ),
    ];

    return BlocProvider(
      create: (_) => locator<OnboardingCubit>(),
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        // We use Builder here to ensure the context below has access to the Provider we just created
        body: Builder(
          builder: (context) {
            return BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    // 1. Page View
                    PageView.builder(
                      controller: pageController,
                      itemCount: data.length,
                      onPageChanged: (index) {
                        context.read<OnboardingCubit>().onPageChanged(index);
                      },
                      itemBuilder: (context, index) {
                        return _OnboardingPageItem(item: data[index]);
                      },
                    ),

                    // 2. Bottom Controls
                    Positioned(
                      bottom: 40,
                      left: 30,
                      right: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Dots Indicator
                          Row(
                            children: List.generate(
                              data.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(right: 6),
                                height: 10,
                                width: state.index == index ? 24 : 10,
                                decoration: BoxDecoration(
                                  color: state.index == index
                                      ? const Color(0xFFF8F3ED)
                                      : const Color(
                                          0xFFF8F3ED,
                                        ).withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),

                          // Navigation Button
                          GestureDetector(
                            onTap: () {
                              if (state.index < data.length - 1) {
                                pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                // Calls the context-aware navigation method
                                context.read<OnboardingCubit>().navigateToLogin(
                                  context,
                                );
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 60,
                              width: state.index == data.length - 1 ? 160 : 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F3ED),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                // We wrap the content in a SingleChildScrollView to prevent overflow errors
                                // while the container is animating from Width 60 -> 160.
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics:
                                      const NeverScrollableScrollPhysics(), // Prevent user scrolling
                                  child: state.index == data.length - 1
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Get Started",
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.primaryColor,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(
                                              LucideIcons.chevronRight,
                                              color: AppTheme.primaryColor,
                                            ),
                                          ],
                                        )
                                      : Padding(
                                          // Added padding to ensure icon is centered nicely
                                          padding: const EdgeInsets.all(12.0),
                                          child: const Icon(
                                            LucideIcons.arrowRight,
                                            size: 28,
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// PRIVATE WIDGET: Page Item
// -----------------------------------------------------------------------------
class _OnboardingPageItem extends StatelessWidget {
  final OnboardingItem item;

  const _OnboardingPageItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Area: Image + Arch
        Expanded(
          flex: 5,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            // The Arch shape
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(150)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(150),
              ),
              child: Container(
                color: Colors.white.withOpacity(
                  0.1,
                ), // Placeholder BG if image fails
                width: double.infinity,
                child: item.imagePath.isEmpty
                    ? const Icon(
                        LucideIcons.image,
                        size: 64,
                        color: Colors.white,
                      )
                    : Image.asset(
                        item.imagePath,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback if image not found
                          return const Icon(
                            LucideIcons.image,
                            size: 64,
                            color: Colors.white,
                          );
                        },
                      ),
              ),
            ),
          ),
        ),

        // Bottom Area: White Card
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFFDFBF7), // Cream/White
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(30, 45, 30, 20),
            child: Column(
              children: [
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor, // Navy
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  item.description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

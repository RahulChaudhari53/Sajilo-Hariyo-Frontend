import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/app/constant/api_endpoints.dart';
import 'package:sajilo_hariyo/app/service_locator/service_locator.dart';
import 'package:sajilo_hariyo/features/home/presentation/view/product_detail_view.dart';
import 'package:sajilo_hariyo/features/home/presentation/view_model/product_bloc/product_bloc.dart';
import 'package:sajilo_hariyo/features/home/presentation/view_model/product_bloc/product_event.dart';
import 'package:sajilo_hariyo/features/home/presentation/view_model/product_bloc/product_state.dart';
import 'package:sajilo_hariyo/features/notification/presentation/view/notification_view.dart';
import 'package:sajilo_hariyo/features/search/presentation/view/search_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the Bloc to the view and trigger initial load
    return BlocProvider(
      create: (_) => locator<ProductBloc>()
        ..add(LoadProducts())
        ..add(LoadCategories()),
      child: const HomeViewContent(),
    );
  }
}

class HomeViewContent extends StatefulWidget {
  const HomeViewContent({super.key});

  @override
  State<HomeViewContent> createState() => _HomeViewContentState();
}

class _HomeViewContentState extends State<HomeViewContent> {
  final Color primaryGreen = const Color(0xFF3A7F5F);
  final Color cardColor = const Color(0xFFF8F3ED);
  final Color darkText = const Color(0xFF1B3A29);

  // Helper to build the full image URL from backend path
  // String _getImageUrl(String path) {
  //   if (path.isEmpty) return "";
  //   return "${ApiEndpoints.serverAddress}/$path";
  // }

  String _getImageUrl(String path) {
    if (path.isEmpty) return "";
    // Ensure there is exactly one slash between the address and the path
    final baseUrl = ApiEndpoints.serverAddress;
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return "$baseUrl/$cleanPath";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardColor,
      body: SafeArea(
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProductBloc>().add(LoadProducts());
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. HEADER
                    _buildHeader(context),

                    const SizedBox(height: 24),

                    // 2. SEARCH BAR (Clickable Widget)
                    _buildSearchWidget(context),

                    const SizedBox(height: 24),

                    // 3. CATEGORIES (Quick Filter)
                    _buildCategoryList(state),

                    const SizedBox(height: 24),

                    // 4. PRODUCT GRID
                    _buildProductSection(state),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sajilo Hariyo 🌿",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
            Text(
              "Find your plant",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),
          ],
        ),
        GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationView()),
    );
  },
  child: Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      shape: BoxShape.rectangle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 8,      // blur amount
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Icon(
      LucideIcons.bell,
      color: darkText,
      size: 24,
    ),
  ),
),

      ],
    );
  }

  Widget _buildSearchWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchView()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(LucideIcons.search, color: primaryGreen),
            const SizedBox(width: 12),
            Text(
              "Search plants...",
              style: GoogleFonts.poppins(color: Colors.grey[400]),
            ),
            const Spacer(),
            Icon(
              LucideIcons.slidersHorizontal,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(ProductState state) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.categories.length + 1, // +1 for "All"
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final category = isAll ? null : state.categories[index - 1];
          final categoryId = isAll ? "" : category!.id;
          final isSelected = state.selectedCategoryId == categoryId;

          return GestureDetector(
            onTap: () {
              if (isAll) {
                context.read<ProductBloc>().add(LoadProducts());
              } else {
                context.read<ProductBloc>().add(FilterByCategory(categoryId!));
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? primaryGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? null
                    : Border.all(color: Colors.grey[400]!),
              ),
              child: Text(
                isAll ? "All" : category!.name,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductSection(ProductState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(child: Text(state.errorMessage!));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Popular Plants",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
        ),
        // "See All" has been removed as per requirement
        const SizedBox(height: 16),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: state.products.length, // Showing all products
          itemBuilder: (context, index) {
            final product = state.products[index];
            // print("Image URL: ${_getImageUrl(product.image)}");
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailView(product: product),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        // child: Image.network(
                        //   _getImageUrl(product.image),
                        //   width: double.infinity,
                        //   fit: BoxFit.cover,
                        //   errorBuilder: (context, error, stackTrace) =>
                        //       const Center(child: Icon(LucideIcons.image)),
                        // ),
                        child: CachedNetworkImage(
                          imageUrl: _getImageUrl(product.image),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(
                              LucideIcons.imageOff,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: darkText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rs. ${product.price}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: primaryGreen,
                                ),
                              ),
                              // Container(
                              //   padding: const EdgeInsets.all(4),
                              //   decoration: BoxDecoration(
                              //     color: darkText,
                              //     shape: BoxShape.circle,
                              //   ),
                              //   child: const Icon(
                              //     LucideIcons.plus,
                              //     color: Color.fromARGB(255, 226, 8, 8),
                              //     size: 16,
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

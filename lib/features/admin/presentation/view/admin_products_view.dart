import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/app/constant/api_endpoints.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view/add_product_view.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view/admin_product_detail_view.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_product_bloc/admin_product_bloc.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_product_bloc/admin_product_event.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_product_bloc/admin_product_state.dart';
import 'package:sajilo_hariyo/features/home/domain/entity/product_entity.dart';
import 'package:sajilo_hariyo/features/search/presentation/view/search_view.dart';

class AdminProductsView extends StatefulWidget {
  const AdminProductsView({super.key});

  @override
  State<AdminProductsView> createState() => _AdminProductsViewState();
}

class _AdminProductsViewState extends State<AdminProductsView> {
  final Color primaryGreen = const Color(0xFF3A7F5F);
  final Color cardColor = const Color(0xFFF8F3ED);
  final Color darkText = const Color(0xFF1B3A29);

  @override
  void initState() {
    super.initState();
    // Load data when view initializes
    context.read<AdminProductBloc>().add(const LoadAdminProductsEvent());
    context.read<AdminProductBloc>().add(const LoadAdminCategoriesEvent());
  }

  String _getImageUrl(String path) {
    if (path.isEmpty) return "";
    if (path.startsWith('http')) return path;
    final baseUrl = ApiEndpoints.serverAddress;
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return "$baseUrl/${cleanPath.replaceAll('\\', '/')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardColor,
      appBar: AppBar(
        title: Text(
          "Manage Products",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: darkText),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: darkText),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchView()));
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.plus),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddProductView()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AdminProductBloc, AdminProductState>(
        builder: (context, state) {
          if (state.isLoading && state.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              context.read<AdminProductBloc>().add(const LoadAdminProductsEvent(isRefresh: true));
              context.read<AdminProductBloc>().add(const LoadAdminCategoriesEvent());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Categories ---
                  _buildCategoryList(state),
                  
                  const SizedBox(height: 16),

                  // --- Product Grid ---
                  if (state.products.isEmpty)
                     Padding(
                       padding: const EdgeInsets.only(top: 50),
                       child: Center(child: Text("No products found", style: GoogleFonts.poppins(color: Colors.grey))),
                     )
                  else
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return _buildProductCard(product);
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

  Widget _buildCategoryList(AdminProductState state) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.categories.length + 1, // +1 for "All"
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final category = isAll ? null : state.categories[index - 1];
          final categoryId = isAll ? "All" : category!.id;
          final isSelected = state.selectedCategory == (isAll ? "All" : categoryId);

          return GestureDetector(
            onTap: () {
              final cat = isAll ? "All" : categoryId;
              context.read<AdminProductBloc>().add(LoadAdminProductsEvent(category: cat));
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

  Widget _buildProductCard(ProductEntity product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AdminProductDetailView(product: product)),
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: CachedNetworkImage(
                  imageUrl: _getImageUrl(product.image),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(LucideIcons.imageOff, color: Colors.grey),
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
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: darkText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rs. ${product.price}",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: primaryGreen),
                      ),
                      // Edit Icon
                      InkWell(
                        onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AddProductView(product: product)), // Reuse AddProductView for edit
                          );
                        },
                        child: Icon(LucideIcons.edit2, size: 16, color: darkText),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

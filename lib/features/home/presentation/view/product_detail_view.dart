// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:sajilo_hariyo/features/cart/domain/entity/cart_item_entity.dart';
// import 'package:sajilo_hariyo/features/cart/presentation/view_model/cart_bloc/cart_bloc.dart';
// import 'package:sajilo_hariyo/features/cart/presentation/view_model/cart_bloc/cart_event.dart';
// import 'package:sajilo_hariyo/features/home/domain/entity/product_entity.dart';
// import 'package:sajilo_hariyo/features/profile/presentation/view_model/wishlist_bloc/wishlist_bloc.dart';
// import 'package:sajilo_hariyo/features/profile/presentation/view_model/wishlist_bloc/wishlist_event.dart';
// import 'package:sajilo_hariyo/features/profile/presentation/view_model/wishlist_bloc/wishlist_state.dart';
// import '../../../../app/constant/api_endpoints.dart';
// import '../../../../app/service_locator/service_locator.dart';
// import '../../../../core/common/custom_elevated_button.dart';
// import '../../../../core/common/my_snackbar.dart';
// import '../view_model/product_detail_bloc/product_detail_bloc.dart';
// import '../view_model/product_detail_bloc/product_detail_event.dart';
// import '../view_model/product_detail_bloc/product_detail_state.dart';
// import 'ar_product_view.dart';

// class ProductDetailView extends StatelessWidget {
//   final ProductEntity product;
//   const ProductDetailView({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) =>
//           locator<ProductDetailBloc>()
//             ..add(CheckInitialFavoriteStatus(product.id!)),
//       child: ProductDetailContent(product: product),
//     );
//   }
// }

// class ProductDetailContent extends StatefulWidget {
//   final ProductEntity product;
//   const ProductDetailContent({super.key, required this.product});

//   @override
//   State<ProductDetailContent> createState() => _ProductDetailContentState();
// }

// class _ProductDetailContentState extends State<ProductDetailContent> {
//   final Color primaryGreen = const Color(0xFF3A7F5F);
//   final Color cardColor = const Color(0xFFF8F3ED);
//   final Color darkText = const Color(0xFF1B3A29);
//   final Color accentOrange = const Color(0xFFE07A5F);
//   int _currentImageIndex = 0;

//   String _getImageUrl(String path) {
//     if (path.isEmpty) return "";
//     return "${ApiEndpoints.serverAddress}/${path.replaceAll('\\', '/')}";
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Generate gallery list: use 'images' if not empty, otherwise fallback to main 'image'
//     final List<String> gallery = widget.product.images.isNotEmpty
//         ? widget.product.images
//         : [widget.product.image];

//     return Scaffold(
//       backgroundColor: cardColor,
//       body: BlocListener<ProductDetailBloc, ProductDetailState>(
//         listener: (context, state) {
//           if (state.message != null) {
//             MySnackBar.showSuccess(context: context, message: state.message!);
//           }
//           if (state.errorMessage != null) {
//             MySnackBar.showError(
//               context: context,
//               message: state.errorMessage!,
//             );
//           }
//         },
//         child: Stack(
//           children: [
//             SingleChildScrollView(
//               padding: const EdgeInsets.only(bottom: 100),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // --- IMAGE CAROUSEL ---
//                   _buildGallery(gallery),
//                   const SizedBox(height: 24),

//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.product.name,
//                           style: GoogleFonts.poppins(
//                             fontSize: 26,
//                             fontWeight: FontWeight.bold,
//                             color: darkText,
//                           ),
//                         ),
//                         if (widget.product.botanicalName != null)
//                           Text(
//                             widget.product.botanicalName!,
//                             style: GoogleFonts.poppins(
//                               fontStyle: FontStyle.italic,
//                               color: Colors.grey[700],
//                               fontSize: 16,
//                             ),
//                           ),
//                         Text(
//                           "${widget.product.categoryName ?? "Plant"} ${widget.product.family != null ? "• ${widget.product.family}" : ""}",
//                           style: GoogleFonts.poppins(
//                             color: Colors.grey[600],
//                             fontSize: 14,
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         // Tags
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children: [
//                             if (widget.product.isPetFriendly == true)
//                               _buildTag("Pet Friendly", LucideIcons.cat),
//                             if (widget.product.isAirPurifying == true)
//                               _buildTag("Air Purifying", LucideIcons.wind),
//                             if (widget.product.isTrending == true)
//                               _buildTag("Trending", LucideIcons.flame, color: Colors.orange),
//                           ],
//                         ),
//                         const SizedBox(height: 24),

//                         // --- AR BUTTON ---
//                         if (widget.product.arModel != null &&
//                             widget.product.arModel!.isNotEmpty)
//                           _buildARButton(context),

//                         const SizedBox(height: 24),

//                         // --- CARE PROFILE ---
//                         Text(
//                           "Care Profile",
//                           style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: darkText,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: [
//                               _buildOverviewItem(LucideIcons.droplet, "Water", widget.product.water ?? "Normal"),
//                               const SizedBox(width: 12),
//                               _buildOverviewItem(LucideIcons.sun, "Light", widget.product.light ?? "Indirect"),
//                               const SizedBox(width: 12),
//                               _buildOverviewItem(LucideIcons.activity, "Difficulty", widget.product.difficulty ?? "Easy"),
//                               if (widget.product.temperature != null && widget.product.temperature!.isNotEmpty)
//                                 ...[const SizedBox(width: 12), _buildOverviewItem(LucideIcons.thermometer, "Temp", widget.product.temperature!)],
//                               if (widget.product.humidity != null && widget.product.humidity!.isNotEmpty)
//                                 ...[const SizedBox(width: 12), _buildOverviewItem(LucideIcons.cloud, "Humidity", widget.product.humidity!)],
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 24),

//                         // --- DETAILS ---
//                         if ((widget.product.height != null && widget.product.height!.isNotEmpty) ||
//                             (widget.product.potSize != null && widget.product.potSize!.isNotEmpty)) ...[
//                           Text(
//                             "Details",
//                             style: GoogleFonts.poppins(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: darkText,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Row(
//                             children: [
//                               if (widget.product.height != null)
//                                 Expanded(child: _buildDetailRow("Height", widget.product.height!)),
//                               if (widget.product.potSize != null)
//                                 Expanded(child: _buildDetailRow("Pot Size", widget.product.potSize!)),
//                             ],
//                           ),
//                           const SizedBox(height: 24),
//                         ],

//                         Text(
//                           "About Plant",
//                           style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: darkText,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           widget.product.description,
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: Colors.grey[600],
//                             height: 1.6,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // --- BOTTOM BAR ---
//             _buildBottomBar(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildGallery(List<String> images) {
//     return Stack(
//       alignment: Alignment.bottomCenter,
//       children: [
//         Container(
//           height: 420,
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
//           ),
//           child: PageView.builder(
//             itemCount: images.length,
//             onPageChanged: (index) =>
//                 setState(() => _currentImageIndex = index),
//             itemBuilder: (context, index) =>
//                 // Image.network(_getImageUrl(images[index]), fit: BoxFit.contain),
//                 CachedNetworkImage(
//                   imageUrl: _getImageUrl(images[index]),
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) => Container(
//                     color: Colors.white,
//                     child: const Center(
//                       child: CircularProgressIndicator(
//                         color: Color(0xFF3A7F5F),
//                       ),
//                     ),
//                   ),
//                   errorWidget: (context, url, error) => const Icon(
//                     LucideIcons.imageOff,
//                     size: 50,
//                     color: Colors.grey,
//                   ),
//                 ),
//           ),
//         ),
//         // Indicators & Buttons...
//         Positioned(bottom: 20, child: _buildDots(images.length)),
//         Positioned(
//           top: 50,
//           left: 20,
//           child: _buildIconButton(
//             LucideIcons.chevronLeft,
//             () => Navigator.pop(context),
//           ),
//         ),
//         Positioned(
//           top: 50,
//           right: 20,
//           child: BlocBuilder<WishlistBloc, WishlistState>(
//             builder: (context, state) {
//               final isFavorite = state.wishlist.any(
//                 (item) => item.id == widget.product.id,
//               );

//               return _buildIconButton(LucideIcons.heart, () {
//                 if (widget.product.id != null) {
//                   context.read<WishlistBloc>().add(
//                     ToggleWishlistEvent(widget.product.id!),
//                   );
//                 }
//               }, color: isFavorite ? Colors.red : Colors.grey);
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildARButton(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 55,
//       child: ElevatedButton.icon(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => ARProductView(
//                 modelUrl: _getImageUrl(widget.product.arModel!),
//                 productName: widget.product.name,
//               ),
//             ),
//           );
//         },
//         icon: const Icon(LucideIcons.boxSelect, color: Colors.white),
//         label: Text(
//           "View in 3D Space",
//           style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: accentOrange,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomBar() {
//     return Positioned(
//       bottom: 0,
//       left: 0,
//       right: 0,
//       child: Container(
//         padding: const EdgeInsets.all(24),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Row(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Price",
//                   style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
//                 ),
//                 Text(
//                   "Rs. ${widget.product.price}",
//                   style: GoogleFonts.poppins(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: darkText,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(width: 24),
//             Expanded(
//               child: CustomElevatedButton(
//                 text: "Add to Cart",
//                 onPressed: () {
//                   // Use Global CartBloc
//                   if (widget.product.id == null) return;

//                   final cartItem = CartItemEntity(
//                     productId: widget.product.id!,
//                     name: widget.product.name,
//                     price: widget.product.price,
//                     image: widget.product.image,
//                     quantity: 1,
//                   );

//                   print(cartItem);

//                   context.read<CartBloc>().add(AddToCart(cartItem));
//                   MySnackBar.showSuccess(
//                     context: context,
//                     message: "Added to Cart",
//                   );
//                 },
//                 backgroundColor: primaryGreen,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- UI Helpers ---
//   Widget _buildDots(int count) => Row(
//     children: List.generate(
//       count,
//       (i) => Container(
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         height: 8,
//         width: _currentImageIndex == i ? 24 : 8,
//         decoration: BoxDecoration(
//           color: _currentImageIndex == i ? primaryGreen : Colors.grey[300],
//           borderRadius: BorderRadius.circular(4),
//         ),
//       ),
//     ),
//   );

//   Widget _buildIconButton(
//   IconData icon,
//   VoidCallback tap, {
//   Color? color,
// }) =>
//     GestureDetector(
//       onTap: tap,
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.15),
//               blurRadius: 8, // blur strength
//               offset: const Offset(0, 4), // vertical shadow
//             ),
//           ],
//         ),
//         child: Icon(icon, size: 20, color: color),
//       ),
//     );

//   Widget _buildOverviewItem(IconData icon, String label, String val) =>
//       Container(
//         width: 100,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.grey.shade200),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: primaryGreen, size: 24),
//             const SizedBox(height: 8),
//             Text(
//               label,
//               style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500]),
//             ),
//             Text(
//               val,
//               textAlign: TextAlign.center,
//               style: GoogleFonts.poppins(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: darkText,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       );

//   Widget _buildTag(String text, IconData icon, {Color? color}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: (color ?? primaryGreen).withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: (color ?? primaryGreen).withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: color ?? primaryGreen),
//           const SizedBox(width: 6),
//           Text(
//             text,
//             style: GoogleFonts.poppins(
//               fontSize: 12,
//               color: color ?? primaryGreen,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
//         Text(value, style: GoogleFonts.poppins(color: darkText, fontWeight: FontWeight.bold)),
//       ],
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/features/cart/domain/entity/cart_item_entity.dart';
import 'package:sajilo_hariyo/features/cart/presentation/view_model/cart_bloc/cart_bloc.dart';
import 'package:sajilo_hariyo/features/cart/presentation/view_model/cart_bloc/cart_event.dart';
import 'package:sajilo_hariyo/features/home/domain/entity/product_entity.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/wishlist_bloc/wishlist_bloc.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/wishlist_bloc/wishlist_event.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/wishlist_bloc/wishlist_state.dart';
import '../../../../app/constant/api_endpoints.dart';
import '../../../../app/service_locator/service_locator.dart';
import '../../../../core/common/custom_elevated_button.dart';
import '../../../../core/common/my_snackbar.dart';
import '../view_model/product_detail_bloc/product_detail_bloc.dart';
import '../view_model/product_detail_bloc/product_detail_event.dart';
import '../view_model/product_detail_bloc/product_detail_state.dart';
import 'ar_product_view.dart';

class ProductDetailView extends StatelessWidget {
  final ProductEntity product;
  const ProductDetailView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          locator<ProductDetailBloc>()
            ..add(CheckInitialFavoriteStatus(product.id!)),
      child: ProductDetailContent(product: product),
    );
  }
}

class ProductDetailContent extends StatefulWidget {
  final ProductEntity product;
  const ProductDetailContent({super.key, required this.product});

  @override
  State<ProductDetailContent> createState() => _ProductDetailContentState();
}

class _ProductDetailContentState extends State<ProductDetailContent> {
  final Color primaryGreen = const Color(0xFF3A7F5F);
  final Color cardColor = const Color(0xFFF8F3ED);
  final Color darkText = const Color(0xFF1B3A29);
  final Color accentOrange = const Color(0xFFE07A5F);
  int _currentImageIndex = 0;

  String _getImageUrl(String path) {
    if (path.isEmpty) return "";
    return "${ApiEndpoints.serverAddress}/${path.replaceAll('\\', '/')}";
  }

  @override
  Widget build(BuildContext context) {
    final List<String> gallery = widget.product.images.isNotEmpty
        ? widget.product.images
        : [widget.product.image];

    return Scaffold(
      backgroundColor: cardColor,
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProductDetailBloc, ProductDetailState>(
            listener: (context, state) {
              if (state.message != null) {
                MySnackBar.showSuccess(context: context, message: state.message!);
              }
              if (state.errorMessage != null) {
                MySnackBar.showError(
                  context: context,
                  message: state.errorMessage!,
                );
              }
            },
          ),
          BlocListener<WishlistBloc, WishlistState>(
            listener: (context, state) {
              if (state.successMessage != null) {
                MySnackBar.showSuccess(context: context, message: state.successMessage!);
              }
              if (state.errorMessage != null) {
                MySnackBar.showError(context: context, message: state.errorMessage!);
              }
            },
          ),
        ],
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- IMAGE CAROUSEL ---
                  _buildGallery(gallery),
                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- PRODUCT NAME & INFO CARD ---
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryGreen.withOpacity(0.1),
                                Colors.white,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: primaryGreen.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: darkText,
                                  height: 1.2,
                                ),
                              ),
                              if (widget.product.botanicalName != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  widget.product.botanicalName!,
                                  style: GoogleFonts.poppins(
                                    fontStyle: FontStyle.italic,
                                    color: primaryGreen,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),

                              // Category & Family Row
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      LucideIcons.tag,
                                      size: 18,
                                      color: primaryGreen,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  widget.product.categoryName ??
                                                  "Plant",
                                              style: GoogleFonts.poppins(
                                                color: darkText,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            if (widget.product.family != null)
                                              TextSpan(
                                                text: ' • ',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            if (widget.product.family != null)
                                              TextSpan(
                                                text: widget.product.family,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Tags
                              if (widget.product.isPetFriendly == true ||
                                  widget.product.isAirPurifying == true ||
                                  widget.product.isTrending == true)
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    if (widget.product.isPetFriendly == true)
                                      _buildTag(
                                        "Pet Friendly",
                                        LucideIcons.cat,
                                      ),
                                    if (widget.product.isAirPurifying == true)
                                      _buildTag(
                                        "Air Purifying",
                                        LucideIcons.wind,
                                      ),
                                    if (widget.product.isTrending == true)
                                      _buildTag(
                                        "Trending",
                                        LucideIcons.flame,
                                        color: Colors.orange,
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // --- AR BUTTON ---
                        if (widget.product.arModel != null &&
                            widget.product.arModel!.isNotEmpty)
                          _buildARButton(context),

                        const SizedBox(height: 24),

                        // --- CARE PROFILE ---
                        Row(
                          children: [
                            Icon(
                              LucideIcons.heart,
                              size: 20,
                              color: primaryGreen,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Care Profile",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: darkText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCareItem(
                                      LucideIcons.droplet,
                                      "Water",
                                      widget.product.water ?? "Normal",
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 50,
                                    color: Colors.grey.shade200,
                                  ),
                                  Expanded(
                                    child: _buildCareItem(
                                      LucideIcons.sun,
                                      "Light",
                                      widget.product.light ?? "Indirect",
                                    ),
                                  ),
                                ],
                              ),
                              if (widget.product.difficulty != null ||
                                  widget.product.temperature != null ||
                                  widget.product.humidity != null) ...[
                                Divider(
                                  color: Colors.grey.shade200,
                                  height: 24,
                                ),
                                Row(
                                  children: [
                                    if (widget.product.difficulty != null)
                                      Expanded(
                                        child: _buildCareItem(
                                          LucideIcons.activity,
                                          "Difficulty",
                                          widget.product.difficulty!,
                                        ),
                                      ),
                                    if (widget.product.difficulty != null &&
                                        (widget.product.temperature != null ||
                                            widget.product.humidity != null))
                                      Container(
                                        width: 1,
                                        height: 50,
                                        color: Colors.grey.shade200,
                                      ),
                                    if (widget.product.temperature != null)
                                      Expanded(
                                        child: _buildCareItem(
                                          LucideIcons.thermometer,
                                          "Temp",
                                          widget.product.temperature!,
                                        ),
                                      ),
                                    if (widget.product.temperature != null &&
                                        widget.product.humidity != null)
                                      Container(
                                        width: 1,
                                        height: 50,
                                        color: Colors.grey.shade200,
                                      ),
                                    if (widget.product.humidity != null)
                                      Expanded(
                                        child: _buildCareItem(
                                          LucideIcons.cloud,
                                          "Humidity",
                                          widget.product.humidity!,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // --- DETAILS ---
                        if ((widget.product.height != null &&
                                widget.product.height!.isNotEmpty) ||
                            (widget.product.potSize != null &&
                                widget.product.potSize!.isNotEmpty)) ...[
                          Row(
                            children: [
                              Icon(
                                LucideIcons.ruler,
                                size: 20,
                                color: primaryGreen,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Details",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: darkText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                if (widget.product.height != null &&
                                    widget.product.height!.isNotEmpty)
                                  Expanded(
                                    child: _buildDetailItem(
                                      LucideIcons.arrowUpDown,
                                      "Height",
                                      widget.product.height!,
                                    ),
                                  ),
                                if (widget.product.height != null &&
                                    widget.product.height!.isNotEmpty &&
                                    widget.product.potSize != null &&
                                    widget.product.potSize!.isNotEmpty)
                                  Container(
                                    width: 1,
                                    height: 50,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    color: Colors.grey.shade200,
                                  ),
                                if (widget.product.potSize != null &&
                                    widget.product.potSize!.isNotEmpty)
                                  Expanded(
                                    child: _buildDetailItem(
                                      LucideIcons.flower2,
                                      "Pot Size",
                                      widget.product.potSize!,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // --- ABOUT PLANT ---
                        Row(
                          children: [
                            Icon(
                              LucideIcons.info,
                              size: 20,
                              color: primaryGreen,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "About Plant",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: darkText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text(
                            widget.product.description,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.7,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- BOTTOM BAR ---
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildCareItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Icon(icon, color: primaryGreen, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: darkText,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: primaryGreen, size: 22),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.grey[500],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: darkText,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildGallery(List<String> images) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 420,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
          ),
          child: PageView.builder(
            itemCount: images.length,
            onPageChanged: (index) =>
                setState(() => _currentImageIndex = index),
            itemBuilder: (context, index) => CachedNetworkImage(
              imageUrl: _getImageUrl(images[index]),
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF3A7F5F)),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(
                LucideIcons.imageOff,
                size: 50,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        Positioned(bottom: 20, child: _buildDots(images.length)),
        Positioned(
          top: 50,
          left: 20,
          child: _buildIconButton(
            LucideIcons.chevronLeft,
            () => Navigator.pop(context),
          ),
        ),
        Positioned(
          top: 50,
          right: 20,
          child: BlocBuilder<WishlistBloc, WishlistState>(
            builder: (context, state) {
              final isFavorite = state.wishlist.any(
                (item) => item.id == widget.product.id,
              );

              return _buildIconButton(LucideIcons.heart, () {
                if (widget.product.id != null) {
                  context.read<WishlistBloc>().add(
                    ToggleWishlistEvent(widget.product.id!),
                  );
                }
              }, color: isFavorite ? Colors.red : Colors.grey);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildARButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ARProductView(
                modelUrl: _getImageUrl(widget.product.arModel!),
                productName: widget.product.name,
              ),
            ),
          );
        },
        icon: const Icon(LucideIcons.boxSelect, color: Colors.white),
        label: Text(
          "View in 3D Space",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: accentOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Price",
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  "Rs. ${widget.product.price}",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: CustomElevatedButton(
                text: "Add to Cart",
                onPressed: () {
                  if (widget.product.id == null) return;

                  final cartItem = CartItemEntity(
                    productId: widget.product.id!,
                    name: widget.product.name,
                    price: widget.product.price,
                    image: widget.product.image,
                    quantity: 1,
                  );

                  print(cartItem);

                  context.read<CartBloc>().add(AddToCart(cartItem));
                  MySnackBar.showSuccess(
                    context: context,
                    message: "Added to Cart",
                  );
                },
                backgroundColor: primaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDots(int count) => Row(
    children: List.generate(
      count,
      (i) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 8,
        width: _currentImageIndex == i ? 24 : 8,
        decoration: BoxDecoration(
          color: _currentImageIndex == i ? primaryGreen : Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
  );

  Widget _buildIconButton(IconData icon, VoidCallback tap, {Color? color}) =>
      GestureDetector(
        onTap: tap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, size: 20, color: color),
        ),
      );

  Widget _buildTag(String text, IconData icon, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? primaryGreen).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (color ?? primaryGreen).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color ?? primaryGreen),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: color ?? primaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

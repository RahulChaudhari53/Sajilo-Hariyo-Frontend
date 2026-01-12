// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:sajilo_hariyo/app/constant/api_endpoints.dart';
// import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
// import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_product_bloc/admin_product_bloc.dart';
// import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_product_bloc/admin_product_event.dart';
// import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_product_bloc/admin_product_state.dart';
// import 'package:sajilo_hariyo/features/home/domain/entity/product_entity.dart';
// import 'package:sajilo_hariyo/features/admin/presentation/view/add_product_view.dart';
// import 'package:sajilo_hariyo/features/search/presentation/view/search_view.dart';

// class AdminProductView extends StatefulWidget {
//   const AdminProductView({super.key});

//   @override
//   State<AdminProductView> createState() => _AdminProductViewState();
// }

// class _AdminProductViewState extends State<AdminProductView> {
//   // No TabController needed

//   @override
//   void initState() {
//     super.initState();
//     context.read<AdminProductBloc>().add(const LoadAdminCategoriesEvent());
//     context.read<AdminProductBloc>().add(const LoadAdminProductsEvent(category: 'All'));
//   }

//   @override
//   void dispose() {
//     // No controllers to dispose
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AdminProductBloc, AdminProductState>(
//       listener: (context, state) {
//         if (state.successMessage != null) {
//           MySnackBar.showSuccess(context: context, message: state.successMessage!);
//         }
//         if (state.error != null) {
//           MySnackBar.showError(context: context, message: state.error!);
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           backgroundColor: const Color(0xFFF8F3ED),
//           appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             title: Text(
//               "Products",
//               style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//             ),
//             actions: [
//               IconButton(
//                 icon: const Icon(LucideIcons.search),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const SearchView()),
//                   );
//                 },
//               ),
//               const SizedBox(width: 16),
//             ],
//           ),
//           floatingActionButton: FloatingActionButton.extended(
//             onPressed: () {
//                Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProductView()));
//             },
//             label: const Text("Add Product"),
//             icon: const Icon(LucideIcons.plus),
//             backgroundColor: const Color(0xFF3A7F5F),
//           ),
//           body: Column(
//             children: [
//               // Categories Section
//               _buildCategoryList(context, state),
              
//               const SizedBox(height: 10),

//               // Products List
//               Expanded(
//                 child: state.isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : RefreshIndicator(
//                         onRefresh: () async {
//                            context.read<AdminProductBloc>().add(LoadAdminProductsEvent(category: state.selectedCategory));
//                         },
//                         child: state.products.isEmpty
//                             ? ListView(children: const [Center(child: Padding(padding: EdgeInsets.all(50), child: Text("No products found")))])
//                             : ListView.separated(
//                                 padding: const EdgeInsets.all(16),
//                                 itemCount: state.products.length,
//                                 separatorBuilder: (_, __) => const SizedBox(height: 16),
//                                 itemBuilder: (context, index) {
//                                   return _buildProductCard(context, state.products[index]);
//                                 },
//                               ),
//                       ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildCategoryList(BuildContext context, AdminProductState state) {
//     return SizedBox(
//       height: 50,
//       child: ListView.builder(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         scrollDirection: Axis.horizontal,
//         itemCount: state.categories.length + 1, // +1 for "All"
//         itemBuilder: (context, index) {
//           final isAll = index == 0;
//           final category = isAll ? null : state.categories[index - 1];
//           final categoryId = isAll ? 'All' : category!.id!;
//           final isSelected = state.selectedCategory == categoryId;
//           final name = isAll ? "All" : category!.name;

//           return GestureDetector(
//             onTap: () {
//               context.read<AdminProductBloc>().add(LoadAdminProductsEvent(category: categoryId));
//             },
//             child: Container(
//               margin: const EdgeInsets.only(right: 12, top: 5, bottom: 5),
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 color: isSelected ? const Color(0xFF3A7F5F) : Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 border: isSelected
//                     ? null
//                     : Border.all(color: Colors.grey[300]!),
//                 boxShadow: isSelected ? [
//                    BoxShadow(
//                     color: const Color(0xFF3A7F5F).withOpacity(0.3),
//                     offset: const Offset(0, 4),
//                     blurRadius: 10,
//                    )
//                 ] : null,
//               ),
//               child: Text(
//                 name,
//                 style: GoogleFonts.poppins(
//                   color: isSelected ? Colors.white : Colors.grey[600],
//                   fontWeight: FontWeight.w600,
//                   fontSize: 13,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildProductCard(BuildContext context, ProductEntity product) {
//     return Dismissible(
//       key: Key(product.id!),
//       direction: DismissDirection.endToStart,
//       background: Container(
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.only(right: 20),
//         decoration: BoxDecoration(
//           color: Colors.red[400],
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: const Icon(LucideIcons.trash2, color: Colors.white),
//       ),
//       confirmDismiss: (direction) async {
//          return await showDialog(
//                   context: context,
//                   builder: (ctx) => AlertDialog(
//                     title: const Text("Delete Product?"),
//                     content: Text("Are you sure you want to delete '${product.name}'?"),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.of(ctx).pop(false),
//                         child: const Text("Cancel"),
//                       ),
//                       TextButton(
//                         onPressed: () => Navigator.of(ctx).pop(true),
//                         style: TextButton.styleFrom(foregroundColor: Colors.red),
//                         child: const Text("Delete"),
//                       ),
//                     ],
//                   ),
//                 );
//       },
//       onDismissed: (_) {
//          context.read<AdminProductBloc>().add(DeleteProductEvent(product.id!));
//       },
//       child: GestureDetector(
//         onTap: () {
//              Navigator.push(context, MaterialPageRoute(builder: (_) => AddProductView(product: product)));
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(16),
//                   bottomLeft: Radius.circular(16),
//                 ),
//                 child: Image.network(
//                   "${ApiEndpoints.baseUrl}products/image/${product.image}",
//                   width: 100,
//                   height: 100,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => Container(
//                     width: 100,
//                     height: 100,
//                     color: Colors.grey[200],
//                     child: const Icon(Icons.broken_image, color: Colors.grey),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         product.name,
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         "Rs ${product.price}",
//                         style: GoogleFonts.poppins(
//                           color: const Color(0xFF3A7F5F),
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         "Stock: ${product.stock}",
//                         style: GoogleFonts.poppins(
//                           fontSize: 12,
//                           color: product.stock < 5 ? Colors.red : Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(LucideIcons.penTool, color: Colors.grey),
//                 onPressed: () {
//                    Navigator.push(context, MaterialPageRoute(builder: (_) => AddProductView(product: product)));
//                 },
//               ),
//               const SizedBox(width: 8),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/app/service_locator/service_locator.dart';
import 'package:sajilo_hariyo/core/common/custom_text_form_field.dart';
import 'package:sajilo_hariyo/core/common/product_card.dart';
import 'package:sajilo_hariyo/features/search/presentation/view_model/search_bloc/search_bloc.dart';
import 'package:sajilo_hariyo/features/search/presentation/view_model/search_bloc/search_event.dart';
import 'package:sajilo_hariyo/features/search/presentation/view_model/search_bloc/search_state.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final Color primaryGreen = const Color(0xFF3A7F5F);
  final Color darkText = const Color(0xFF1B3A29);
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query, BuildContext context) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final currentState = context.read<SearchBloc>().state;
      context.read<SearchBloc>().add(SearchProductsEvent(
            query: query,
            categoryId: currentState.categoryId,
            minPrice: currentState.minPrice,
            maxPrice: currentState.maxPrice,
            sort: currentState.sort,
          ));
    });
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: context.read<SearchBloc>(),
          child: const FilterBottomSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<SearchBloc>()
        ..add(LoadSearchCategoriesEvent())
        ..add(const SearchProductsEvent(query: '')), // Initial empty search
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F3ED),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8F3ED),
          elevation: 0,
          leading: IconButton(
            icon: Icon(LucideIcons.chevronLeft, color: darkText),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Search",
            style: GoogleFonts.poppins(
              color: darkText,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // 1. Search Bar
              Row(
                children: [
                  Expanded(
                    child: Builder(builder: (context) {
                      return CustomTextFormField(
                        controller: _searchController,
                        hintText: "Search plant name...",
                        prefixIcon: LucideIcons.search,
                        onChanged: (val) => _onSearchChanged(val!, context),
                      );
                    }),
                  ),
                  const SizedBox(width: 16),
                  Builder(builder: (context) {
                    return GestureDetector(
                      onTap: () => _showFilterModal(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: primaryGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(LucideIcons.slidersHorizontal,
                            color: Colors.white),
                      ),
                    );
                  }),
                ],
              ),
                const SizedBox(height: 20),

                // 2. Results
                Expanded(
                  child: BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state.error != null) {
                        return Center(child: Text("Error: ${state.error}"));
                      }
                      if (state.products.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.leaf,
                                  size: 64, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text(
                                "No plants found",
                                style: GoogleFonts.poppins(
                                    color: Colors.grey[500], fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }

                      return GridView.builder(
                        itemCount: state.products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemBuilder: (context, index) {
                          return ProductCard(product: state.products[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedCategory;
  RangeValues _priceRange = const RangeValues(0, 5000); // Default range updated
  String? _sortOption;

  @override
  void initState() {
    super.initState();
    final state = context.read<SearchBloc>().state;
    _selectedCategory = state.categoryId;
    if (state.minPrice != null && state.maxPrice != null) {
      _priceRange = RangeValues(state.minPrice!, state.maxPrice!);
    } else {
        _priceRange = const RangeValues(0, 10000);
    }
    _sortOption = state.sort;
  }

  void _applyFilters() {
    final searchBloc = context.read<SearchBloc>();
    searchBloc.add(SearchProductsEvent(
      query: searchBloc.state.query,
      categoryId: _selectedCategory,
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
      sort: _sortOption,
    ));
    Navigator.pop(context);
  }

  void _resetFilters() {
    context.read<SearchBloc>().add(ResetSearchEvent());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final primaryGreen = const Color(0xFF3A7F5F);
    
    return Container(
      padding: const EdgeInsets.all(24),
      height: MediaQuery.of(context).size.height * 0.7,
      child: SingleChildScrollView( // Wrap in SingleChildScrollView to fix overflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Filters",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text("Reset", style: TextStyle(color: Colors.red[400])),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),

            // Categories
            Text("Category",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                return Wrap(
                  spacing: 8,
                  children: state.categories.map((cat) {
                    final isSelected = _selectedCategory == cat.id;
                    return ChoiceChip(
                      label: Text(cat.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? cat.id : null;
                        });
                      },
                      selectedColor: primaryGreen,
                      labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black),
                      backgroundColor: Colors.grey[200],
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),

            // Price Range
            Text("Price Range (Rs. ${_priceRange.start.toInt()} - Rs. ${_priceRange.end.toInt()})",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: 10000, // Reduced max to 10000
              divisions: 20,
              activeColor: primaryGreen,
              labels: RangeLabels(
                "Rs. ${_priceRange.start.toInt()}",
                "Rs. ${_priceRange.end.toInt()}",
              ),
              onChanged: (values) {
                setState(() {
                  _priceRange = values;
                });
              },
            ),
            const SizedBox(height: 24),

            // Sort
            Text("Sort By",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                _buildSortChip("Price: Low to High", "price"),
                _buildSortChip("Price: High to Low", "-price"),
                _buildSortChip("Newest", "-createdAt"),
              ],
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Apply Filters",
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortOption == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _sortOption = selected ? value : null;
        });
      },
      selectedColor: const Color(0xFF3A7F5F),
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      backgroundColor: Colors.grey[200],
    );
  }
}

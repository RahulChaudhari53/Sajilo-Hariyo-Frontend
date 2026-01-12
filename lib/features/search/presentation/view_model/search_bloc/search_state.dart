import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/features/home/data/repository/remote_repository/category_entity.dart';
import 'package:sajilo_hariyo/features/home/domain/entity/product_entity.dart';

class SearchState extends Equatable {
  final bool isLoading;
  final List<ProductEntity> products;
  final List<CategoryEntity> categories;
  final String? error;

  // Active Filters (to persist state in UI)
  final String? query;
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final String? sort;

  const SearchState({
    required this.isLoading,
    required this.products,
    required this.categories,
    this.error,
    this.query,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.sort,
  });

  factory SearchState.initial() {
    return const SearchState(
      isLoading: false,
      products: [],
      categories: [],
      error: null,
      query: '',
      categoryId: null,
      minPrice: null,
      maxPrice: null,
      sort: null,
    );
  }

  SearchState copyWith({
    bool? isLoading,
    List<ProductEntity>? products,
    List<CategoryEntity>? categories,
    String? error,
    String? query,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? sort,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      error:
          error, // If passed null/omitted it keeps old error? No, usually clear error on state change.
      // Actually copyWith usually retains unless overridden. But we often want to clear error.
      // Let's stick to standard copyWith behavior.
      query: query ?? this.query,
      categoryId: categoryId ?? this.categoryId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    products,
    categories,
    error,
    query,
    categoryId,
    minPrice,
    maxPrice,
    sort,
  ];
}

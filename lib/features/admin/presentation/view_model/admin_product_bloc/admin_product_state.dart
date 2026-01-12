import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/features/home/data/repository/remote_repository/category_entity.dart';
import 'package:sajilo_hariyo/features/home/domain/entity/product_entity.dart';

class AdminProductState extends Equatable {
  final List<ProductEntity> products;
  final List<CategoryEntity> categories;
  final bool isLoading;
  final bool isActionLoading; // For create/update/delete spinner
  final String? error;
  final String? successMessage;
  final String selectedCategory;

  const AdminProductState({
    this.products = const [],
    this.categories = const [],
    this.isLoading = false,
    this.isActionLoading = false,
    this.error,
    this.successMessage,
    this.selectedCategory = 'All',
  });

  factory AdminProductState.initial() {
    return const AdminProductState(
      products: [],
      categories: [],
      isLoading: false,
      isActionLoading: false,
      selectedCategory: 'All',
    );
  }

  AdminProductState copyWith({
    List<ProductEntity>? products,
    List<CategoryEntity>? categories,
    bool? isLoading,
    bool? isActionLoading,
    String? error,
    String? successMessage,
    String? selectedCategory,
  }) {
    return AdminProductState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      error: error, // Don't copy error/success by default to clear them usually
      successMessage: successMessage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
        products,
        categories,
        isLoading,
        isActionLoading,
        error,
        successMessage,
        selectedCategory,
      ];
}

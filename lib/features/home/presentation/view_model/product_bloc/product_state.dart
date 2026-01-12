import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/features/home/data/repository/remote_repository/category_entity.dart';
import '../../../domain/entity/product_entity.dart';

class ProductState extends Equatable {
  final bool isLoading;
  final List<ProductEntity> products;
  final List<CategoryEntity> categories;
  final String? errorMessage;
  final String? selectedCategoryId;

  const ProductState({
    required this.isLoading,
    required this.products,
    required this.categories,
    this.errorMessage,
    this.selectedCategoryId,
  });

  factory ProductState.initial() => const ProductState(
    isLoading: false,
    products: [],
    categories: [],
    errorMessage: null,
    selectedCategoryId: null,
  );

  ProductState copyWith({
    bool? isLoading,
    List<ProductEntity>? products,
    List<CategoryEntity>? categories,
    String? errorMessage,
    String? selectedCategoryId,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    products,
    categories,
    errorMessage,
    selectedCategoryId,
  ];
}

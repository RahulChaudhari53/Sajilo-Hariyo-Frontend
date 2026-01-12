import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/get_products_usecase.dart';
import '../../../domain/usecase/get_categories_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase _getProductsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  ProductBloc({
    required GetProductsUseCase getProductsUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
  }) : _getProductsUseCase = getProductsUseCase,
       _getCategoriesUseCase = getCategoriesUseCase,
       super(ProductState.initial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadCategories>(_onLoadCategories);
    on<FilterByCategory>(_onFilterByCategory);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, selectedCategoryId: ''));
    final result = await _getProductsUseCase(const GetProductsParams());
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (products) => emit(
        state.copyWith(
          isLoading: false,
          products: products,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<ProductState> emit,
  ) async {
    final result = await _getCategoriesUseCase();
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (categories) => emit(state.copyWith(categories: categories)),
    );
  }

  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, selectedCategoryId: event.categoryId));
    final result = await _getProductsUseCase(
      GetProductsParams(category: event.categoryId),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (products) => emit(state.copyWith(isLoading: false, products: products)),
    );
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _getProductsUseCase(
      GetProductsParams(search: event.query),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (products) => emit(state.copyWith(isLoading: false, products: products)),
    );
  }
}

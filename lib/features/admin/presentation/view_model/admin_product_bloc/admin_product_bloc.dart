import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/features/home/domain/usecase/create_product_usecase.dart';
import 'package:sajilo_hariyo/features/home/domain/usecase/delete_product_usecase.dart';
import 'package:sajilo_hariyo/features/home/domain/usecase/update_product_usecase.dart';
import 'package:sajilo_hariyo/features/home/domain/usecase/get_products_usecase.dart';
import 'package:sajilo_hariyo/features/home/domain/usecase/get_categories_usecase.dart';
import 'admin_product_event.dart';
import 'admin_product_state.dart';

class AdminProductBloc extends Bloc<AdminProductEvent, AdminProductState> {
  final GetProductsUseCase _getProductsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final CreateProductUseCase _createProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;

  AdminProductBloc({
    required GetProductsUseCase getProductsUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required CreateProductUseCase createProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required DeleteProductUseCase deleteProductUseCase,
  })  : _getProductsUseCase = getProductsUseCase,
        _getCategoriesUseCase = getCategoriesUseCase,
        _createProductUseCase = createProductUseCase,
        _updateProductUseCase = updateProductUseCase,
        _deleteProductUseCase = deleteProductUseCase,
        super(AdminProductState.initial()) {
    on<LoadAdminCategoriesEvent>(_onLoadCategories);
    on<LoadAdminProductsEvent>(_onLoadProducts);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadCategories(
    LoadAdminCategoriesEvent event,
    Emitter<AdminProductState> emit,
  ) async {
    final result = await _getCategoriesUseCase.call();
    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (categories) => emit(state.copyWith(categories: categories)),
    );
  }

  Future<void> _onLoadProducts(
    LoadAdminProductsEvent event,
    Emitter<AdminProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, selectedCategory: event.category));

    final result = await _getProductsUseCase.call(
      GetProductsParams(
        category: event.category == 'All' ? null : event.category,
        search: event.search,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (products) => emit(state.copyWith(isLoading: false, products: products)),
    );
  }

  Future<void> _onCreateProduct(
    CreateProductEvent event,
    Emitter<AdminProductState> emit,
  ) async {
    emit(state.copyWith(isActionLoading: true));
    final result = await _createProductUseCase.call(CreateProductParams(
      product: event.product,
      image: event.image,
      arModel: event.arModel,
      gallery: event.gallery,
    ));

    result.fold(
      (failure) => emit(state.copyWith(isActionLoading: false, error: failure.message)),
      (_) {
        emit(state.copyWith(
          isActionLoading: false,
          successMessage: "Product Created Successfully",
        ));
        add(LoadAdminProductsEvent(category: state.selectedCategory)); // Refresh list
      },
    );
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<AdminProductState> emit,
  ) async {
    emit(state.copyWith(isActionLoading: true));
    final result = await _updateProductUseCase.call(UpdateProductParams(
      product: event.product,
      image: event.image,
      arModel: event.arModel,
      gallery: event.gallery,
    ));

    result.fold(
      (failure) => emit(state.copyWith(isActionLoading: false, error: failure.message)),
      (_) {
        emit(state.copyWith(
          isActionLoading: false,
          successMessage: "Product Updated Successfully",
        ));
        add(LoadAdminProductsEvent(category: state.selectedCategory)); // Refresh list
      },
    );
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<AdminProductState> emit,
  ) async {
    // Optimistic update or show loading? Let's show loading integration
    // Ideally we might want separate loading state for deletion to not block entire UI
    final result = await _deleteProductUseCase.call(event.productId);

    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (_) {
        emit(state.copyWith(successMessage: "Product Deleted Successfully"));
        add(LoadAdminProductsEvent(category: state.selectedCategory));
      },
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/features/cart/domain/entity/cart_item_entity.dart';
import 'package:sajilo_hariyo/features/cart/domain/usecase/add_to_cart_usecase.dart';
import 'package:sajilo_hariyo/features/profile/domain/usecase/get_wishlist_usecase.dart';
import 'package:sajilo_hariyo/features/profile/domain/usecase/toggle_wishlist_usecase.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ToggleWishlistUseCase _toggleWishlistUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final GetWishlistUseCase _getWishlistUseCase;

  ProductDetailBloc({
    required ToggleWishlistUseCase toggleWishlistUseCase,
    required AddToCartUseCase addToCartUseCase,
    required GetWishlistUseCase getWishlistUseCase,
  }) : _toggleWishlistUseCase = toggleWishlistUseCase,
       _addToCartUseCase = addToCartUseCase,
       _getWishlistUseCase = getWishlistUseCase,
       super(ProductDetailState.initial()) {
    on<CheckInitialFavoriteStatus>(_onCheckFavoriteStatus);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<AddToCartEvent>(_onAddToCart);
  }

  Future<void> _onCheckFavoriteStatus(
    CheckInitialFavoriteStatus event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(state.copyWith(isChecking: true));

    final result = await _getWishlistUseCase();

    result.fold(
      (failure) {
        // If API fails, stop checking but default to false
        emit(state.copyWith(isChecking: false, isFavorite: false));
      },
      (favorites) {
        // Robust Comparison: check if current ID is in the populated list
        final bool matchFound = favorites.any(
          (element) => element.id == event.productId,
        );

        emit(state.copyWith(isChecking: false, isFavorite: matchFound));
      },
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _toggleWishlistUseCase(event.productId);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (isAdded) => emit(state.copyWith(isLoading: false, isFavorite: isAdded)),
    );
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    final cartItem = CartItemEntity(
      productId: event.product.id!,
      name: event.product.name,
      price: event.product.price,
      image: event.product.image,
      quantity: 1, // Logic always adds exactly 1 as per requirement
    );

    final result = await _addToCartUseCase(cartItem);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) =>
          emit(state.copyWith(message: "${event.product.name} added to cart!")),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/features/cart/domain/repository/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository _cartRepository;

  CartBloc(this._cartRepository) : super(CartState.initial()) {
    on<LoadCartItems>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCartItems event, Emitter<CartState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _cartRepository.getCartItems();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (items) {
        double sub = items.fold(
          0,
          (sum, item) => sum + (item.price * item.quantity),
        );
        emit(
          state.copyWith(
            isLoading: false,
            items: items,
            subtotal: sub,
            total: items.isEmpty
                ? 0
                : sub + 100, // 100 is the flat delivery fee
          ),
        );
      },
    );
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    await _cartRepository.addToCart(event.item);
    add(LoadCartItems());
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    await _cartRepository.removeFromCart(event.productId);
    add(LoadCartItems());
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<CartState> emit,
  ) async {
    await _cartRepository.updateQuantity(event.productId, event.quantity);
    add(LoadCartItems());
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    await _cartRepository.clearCart();
    emit(CartState.initial());
  }
}

import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/features/cart/domain/entity/cart_item_entity.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class LoadCartItems extends CartEvent {}

class AddToCart extends CartEvent {
  final CartItemEntity item;
  const AddToCart(this.item);
}

class RemoveFromCart extends CartEvent {
  final String productId;
  const RemoveFromCart(this.productId);
}

class UpdateQuantity extends CartEvent {
  final String productId;
  final int quantity;
  const UpdateQuantity(this.productId, this.quantity);
}

class ClearCart extends CartEvent {}

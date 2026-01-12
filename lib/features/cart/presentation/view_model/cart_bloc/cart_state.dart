import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/features/cart/domain/entity/cart_item_entity.dart';

class CartState extends Equatable {
  final bool isLoading;
  final List<CartItemEntity> items;
  final double subtotal;
  final double total;
  final String? errorMessage;

  const CartState({
    required this.isLoading,
    required this.items,
    required this.subtotal,
    required this.total,
    this.errorMessage,
  });

  factory CartState.initial() => const CartState(
    isLoading: false,
    items: [],
    subtotal: 0.0,
    total: 0.0,
    errorMessage: null,
  );

  CartState copyWith({
    bool? isLoading,
    List<CartItemEntity>? items,
    double? subtotal,
    double? total,
    String? errorMessage,
  }) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      total: total ?? this.total,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, items, subtotal, total, errorMessage];
}

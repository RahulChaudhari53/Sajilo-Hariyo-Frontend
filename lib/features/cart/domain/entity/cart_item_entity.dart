import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String productId;
  final String name;
  final double price;
  final String image;
  final int quantity;

  const CartItemEntity({
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}

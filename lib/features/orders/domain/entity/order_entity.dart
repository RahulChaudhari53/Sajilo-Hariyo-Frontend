import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/features/cart/domain/entity/cart_item_entity.dart';

class OrderEntity extends Equatable {
  final String? id;
  final List<CartItemEntity> items;
  final double totalAmount;
  final String shippingAddress;
  final String city;
  final String phone;
  final String status; // Pending, Processing, Shipped, etc.
  final DateTime createdAt;
  final String paymentMethod;
  final String? deliveryCode; // The secret for the QR code
  final String? userName;

  const OrderEntity({
    this.id,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.city,
    required this.phone,
    required this.status,
    required this.createdAt,
    required this.paymentMethod,
    this.deliveryCode,
    this.userName,
  });

  @override
  List<Object?> get props => [id, status, totalAmount];
}

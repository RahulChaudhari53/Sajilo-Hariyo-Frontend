import 'package:json_annotation/json_annotation.dart';
import 'package:sajilo_hariyo/features/orders/domain/entity/order_entity.dart';
import 'order_item_api_model.dart';

part 'order_api_model.g.dart';

@JsonSerializable()
class OrderApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final List<OrderItemApiModel> orderItems;
  final Map<String, dynamic> shippingInfo;
  final Map<String, dynamic> paymentInfo;
  final double totalAmount;
  final String orderStatus;
  final String? deliveryCode;
  final List<Map<String, dynamic>>? orderHistory;
  final String? createdAt;

  OrderApiModel({
    this.id,
    required this.orderItems,
    required this.shippingInfo,
    required this.paymentInfo,
    required this.totalAmount,
    required this.orderStatus,
    this.deliveryCode,
    this.orderHistory,
    this.createdAt,
  });

  factory OrderApiModel.fromJson(Map<String, dynamic> json) =>
      _$OrderApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderApiModelToJson(this);

  // Mapper: API Model -> Domain Entity
  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      items: orderItems.map((item) => item.toEntity()).toList(),
      totalAmount: totalAmount.toDouble(),
      shippingAddress: shippingInfo['address'] ?? '',
      city: shippingInfo['city'] ?? '',
      phone: shippingInfo['phone'] ?? '',
      status: orderStatus,
      createdAt: createdAt != null
          ? DateTime.parse(createdAt!)
          : DateTime.now(),
      paymentMethod: paymentInfo['method'] ?? 'COD',
      deliveryCode: deliveryCode,
      userName: shippingInfo['name'],
    );
  }
}

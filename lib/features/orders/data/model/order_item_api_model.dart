import 'package:json_annotation/json_annotation.dart';
import 'package:sajilo_hariyo/features/cart/domain/entity/cart_item_entity.dart';

part 'order_item_api_model.g.dart';

@JsonSerializable()
class OrderItemApiModel {
  final String name;
  final int qty;
  final String image;
  final double price;
  @JsonKey(name: 'product')
  final String productId;

  OrderItemApiModel({
    required this.name,
    required this.qty,
    required this.image,
    required this.price,
    required this.productId,
  });

  factory OrderItemApiModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemApiModelToJson(this);

  // Convert to CartItemEntity (which we use for item display)
  CartItemEntity toEntity() => CartItemEntity(
    productId: productId,
    name: name,
    price: price.toDouble(),
    image: image,
    quantity: qty,
  );
}

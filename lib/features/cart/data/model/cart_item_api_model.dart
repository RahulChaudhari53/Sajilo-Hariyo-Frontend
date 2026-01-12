import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/cart_item_entity.dart';

part 'cart_item_api_model.g.dart';

@JsonSerializable()
class CartItemApiModel extends Equatable {
  final String productId;
  final String name;
  final double price;
  final String image;
  final int quantity;

  const CartItemApiModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });

  factory CartItemApiModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemApiModelToJson(this);

  // Mapper: Entity -> API Model
  factory CartItemApiModel.fromEntity(CartItemEntity entity) {
    return CartItemApiModel(
      productId: entity.productId,
      name: entity.name,
      price: entity.price,
      image: entity.image,
      quantity: entity.quantity,
    );
  }

  // Mapper: API Model -> Entity
  CartItemEntity toEntity() {
    return CartItemEntity(
      productId: productId,
      name: name,
      price: price,
      image: image,
      quantity: quantity,
    );
  }

  @override
  List<Object?> get props => [productId, name, price, image, quantity];
}

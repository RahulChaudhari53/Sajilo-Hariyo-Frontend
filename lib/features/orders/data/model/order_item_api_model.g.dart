// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemApiModel _$OrderItemApiModelFromJson(Map<String, dynamic> json) =>
    OrderItemApiModel(
      name: json['name'] as String,
      qty: (json['qty'] as num).toInt(),
      image: json['image'] as String,
      price: (json['price'] as num).toDouble(),
      productId: json['product'] as String,
    );

Map<String, dynamic> _$OrderItemApiModelToJson(OrderItemApiModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'qty': instance.qty,
      'image': instance.image,
      'price': instance.price,
      'product': instance.productId,
    };

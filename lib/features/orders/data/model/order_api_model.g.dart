// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderApiModel _$OrderApiModelFromJson(Map<String, dynamic> json) =>
    OrderApiModel(
      id: json['_id'] as String?,
      orderItems: (json['orderItems'] as List<dynamic>)
          .map((e) => OrderItemApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      shippingInfo: json['shippingInfo'] as Map<String, dynamic>,
      paymentInfo: json['paymentInfo'] as Map<String, dynamic>,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      orderStatus: json['orderStatus'] as String,
      deliveryCode: json['deliveryCode'] as String?,
      orderHistory: (json['orderHistory'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$OrderApiModelToJson(OrderApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'orderItems': instance.orderItems,
      'shippingInfo': instance.shippingInfo,
      'paymentInfo': instance.paymentInfo,
      'totalAmount': instance.totalAmount,
      'orderStatus': instance.orderStatus,
      'deliveryCode': instance.deliveryCode,
      'orderHistory': instance.orderHistory,
      'createdAt': instance.createdAt,
    };

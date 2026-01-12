// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_stats_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminStatsApiModel _$AdminStatsApiModelFromJson(Map<String, dynamic> json) =>
    AdminStatsApiModel(
      totalSales: (json['totalSales'] as num).toInt(),
      totalOrders: (json['totalOrders'] as num).toInt(),
      pendingOrders: (json['pendingOrders'] as num).toInt(),
      processingOrders: (json['processingOrders'] as num).toInt(),
      shippedOrders: (json['shippedOrders'] as num).toInt(),
      deliveredOrders: (json['deliveredOrders'] as num).toInt(),
      lowStockCount: (json['lowStockCount'] as num).toInt(),
    );

Map<String, dynamic> _$AdminStatsApiModelToJson(AdminStatsApiModel instance) =>
    <String, dynamic>{
      'totalSales': instance.totalSales,
      'totalOrders': instance.totalOrders,
      'pendingOrders': instance.pendingOrders,
      'processingOrders': instance.processingOrders,
      'shippedOrders': instance.shippedOrders,
      'deliveredOrders': instance.deliveredOrders,
      'lowStockCount': instance.lowStockCount,
    };

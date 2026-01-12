import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/admin_stats_entity.dart';

part 'admin_stats_api_model.g.dart';

@JsonSerializable()
class AdminStatsApiModel extends Equatable {
  final int totalSales;
  final int totalOrders;
  final int pendingOrders;
  final int processingOrders;
  final int shippedOrders;
  final int deliveredOrders;
  final int lowStockCount;

  const AdminStatsApiModel({
    required this.totalSales,
    required this.totalOrders,
    required this.pendingOrders,
    required this.processingOrders,
    required this.shippedOrders,
    required this.deliveredOrders,
    required this.lowStockCount,
  });

  factory AdminStatsApiModel.fromJson(Map<String, dynamic> json) =>
      _$AdminStatsApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdminStatsApiModelToJson(this);

  AdminStatsEntity toEntity() => AdminStatsEntity(
        totalSales: totalSales,
        totalOrders: totalOrders,
        pendingOrders: pendingOrders,
        processingOrders: processingOrders,
        shippedOrders: shippedOrders,
        deliveredOrders: deliveredOrders,
        lowStockCount: lowStockCount,
      );

  @override
  List<Object?> get props => [
        totalSales,
        totalOrders,
        pendingOrders,
        processingOrders,
        shippedOrders,
        deliveredOrders,
        lowStockCount,
      ];
}

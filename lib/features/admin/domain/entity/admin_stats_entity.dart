import 'package:equatable/equatable.dart';

class AdminStatsEntity extends Equatable {
  final int totalSales;
  final int totalOrders;
  final int pendingOrders;
  final int processingOrders;
  final int shippedOrders;
  final int deliveredOrders;
  final int lowStockCount;

  const AdminStatsEntity({
    required this.totalSales,
    required this.totalOrders,
    required this.pendingOrders,
    required this.processingOrders,
    required this.shippedOrders,
    required this.deliveredOrders,
    required this.lowStockCount,
  });

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

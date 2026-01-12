import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/admin/domain/entity/admin_stats_entity.dart';
import 'package:sajilo_hariyo/features/orders/domain/entity/order_entity.dart';

abstract class IAdminRepository {
  Future<Either<Failure, AdminStatsEntity>> getAdminStats();
  Future<Either<Failure, void>> createCategory(String name, String description);
  Future<Either<Failure, void>> deleteCategory(String id);
  Future<Either<Failure, List<OrderEntity>>> getAdminOrders(String? status);
  Future<Either<Failure, void>> updateOrderStatus(String orderId, String status);
  Future<Either<Failure, void>> verifyDelivery(String orderId, String qrCode);
}

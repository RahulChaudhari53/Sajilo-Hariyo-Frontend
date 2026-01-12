import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/admin/data/data_source/remote_data_source/admin_remote_data_source.dart';
import 'package:sajilo_hariyo/features/admin/domain/entity/admin_stats_entity.dart';
import 'package:sajilo_hariyo/features/admin/domain/repository/admin_repository.dart';
import 'package:sajilo_hariyo/features/orders/domain/entity/order_entity.dart';

class AdminRemoteRepository implements IAdminRepository {
  final IAdminDataSource _adminDataSource;

  AdminRemoteRepository(this._adminDataSource);

  @override
  Future<Either<Failure, AdminStatsEntity>> getAdminStats() async {
    try {
      final statsModel = await _adminDataSource.getAdminStats();
      return Right(statsModel.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> createCategory(
    String name,
    String description,
  ) async {
    try {
      await _adminDataSource.createCategory(name, description);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    try {
      await _adminDataSource.deleteCategory(id);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getAdminOrders(String? status) async {
    try {
      final orders = await _adminDataSource.getAdminOrders(status);
      return Right(orders);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus(String orderId, String status) async {
    try {
      await _adminDataSource.updateOrderStatus(orderId, status);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> verifyDelivery(String orderId, String qrCode) async {
    try {
      await _adminDataSource.verifyDelivery(orderId, qrCode);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}


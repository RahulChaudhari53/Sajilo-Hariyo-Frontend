import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/orders/data/data_source/order_data_source.dart';
import 'package:sajilo_hariyo/features/orders/domain/entity/order_entity.dart';
import 'package:sajilo_hariyo/features/orders/domain/repository/order_repository.dart';

class OrderRemoteRepository implements IOrderRepository {
  final IOrderDataSource _orderRemoteDataSource;

  OrderRemoteRepository(this._orderRemoteDataSource);

  @override
  Future<Either<Failure, void>> placeOrder(OrderEntity order) async {
    try {
      await _orderRemoteDataSource.placeOrder(order);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getMyOrders(String filter) async {
    try {
      final orderApiModels = await _orderRemoteDataSource.getMyOrders(filter);
      // Map API Models to Domain Entities
      final orderEntities = orderApiModels
          .map((model) => model.toEntity())
          .toList();
      return Right(orderEntities);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String id) async {
    try {
      final orderApiModel = await _orderRemoteDataSource.getOrderById(id);
      return Right(orderApiModel.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> cancelOrder(String id) async {
    try {
      await _orderRemoteDataSource.cancelOrder(id);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, String>> getDeliveryQR(String id) async {
    try {
      final deliveryCode = await _orderRemoteDataSource.getDeliveryQR(id);
      return Right(deliveryCode);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // Admin Method (To support the Admin Orders View)
  Future<Either<Failure, List<OrderEntity>>> getAllOrders({
    String? status,
  }) async {
    try {
      final orderApiModels = await _orderRemoteDataSource.getAllOrders(
        status: status,
      );
      final orderEntities = orderApiModels
          .map((model) => model.toEntity())
          .toList();
      return Right(orderEntities);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}

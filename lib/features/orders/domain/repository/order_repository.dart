import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entity/order_entity.dart';

abstract interface class IOrderRepository {
  Future<Either<Failure, void>> placeOrder(OrderEntity order);
  Future<Either<Failure, List<OrderEntity>>> getMyOrders(
    String filter,
  ); // active/history
  Future<Either<Failure, OrderEntity>> getOrderById(String id);
  Future<Either<Failure, void>> cancelOrder(String id);
  Future<Either<Failure, String>> getDeliveryQR(
    String id,
  ); // Returns the deliveryCode
}

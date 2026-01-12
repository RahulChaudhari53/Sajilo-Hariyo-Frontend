import 'package:dartz/dartz.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/order_entity.dart';
import '../repository/order_repository.dart';

class PlaceOrderUseCase implements UsecaseWithParams<void, OrderEntity> {
  final IOrderRepository repository;
  PlaceOrderUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(OrderEntity order) {
    return repository.placeOrder(order);
  }
}

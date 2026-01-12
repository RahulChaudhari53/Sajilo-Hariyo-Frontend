import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/orders/domain/repository/order_repository.dart';

class CancelOrderUseCase implements UsecaseWithParams<void, String> {
  final IOrderRepository repository;

  CancelOrderUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(String orderId) {
    return repository.cancelOrder(orderId);
  }
}

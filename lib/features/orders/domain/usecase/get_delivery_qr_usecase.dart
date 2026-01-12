import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/orders/domain/repository/order_repository.dart';

class GetDeliveryQRUseCase implements UsecaseWithParams<String, String> {
  final IOrderRepository repository;

  GetDeliveryQRUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> call(String orderId) {
    return repository.getDeliveryQR(orderId);
  }
}

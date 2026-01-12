import 'package:dartz/dartz.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/order_entity.dart';
import '../repository/order_repository.dart';

class GetMyOrdersUseCase
    implements UsecaseWithParams<List<OrderEntity>, String> {
  final IOrderRepository repository;
  GetMyOrdersUseCase({required this.repository});

  @override
  Future<Either<Failure, List<OrderEntity>>> call(String filter) {
    return repository.getMyOrders(filter);
  }
}

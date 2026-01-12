import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/admin/domain/repository/admin_repository.dart';
import 'package:sajilo_hariyo/features/orders/domain/entity/order_entity.dart';

class GetAdminOrdersUseCase implements UsecaseWithParams<List<OrderEntity>, String?> {
  final IAdminRepository _adminRepository;

  GetAdminOrdersUseCase(this._adminRepository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(String? status) async {
    return await _adminRepository.getAdminOrders(status);
  }
}

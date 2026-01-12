import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/admin/domain/repository/admin_repository.dart';

class UpdateOrderStatusParams extends Equatable {
  final String orderId;
  final String status;

  const UpdateOrderStatusParams({required this.orderId, required this.status});

  @override
  List<Object?> get props => [orderId, status];
}

class UpdateOrderStatusUseCase implements UsecaseWithParams<void, UpdateOrderStatusParams> {
  final IAdminRepository _adminRepository;

  UpdateOrderStatusUseCase(this._adminRepository);

  @override
  Future<Either<Failure, void>> call(UpdateOrderStatusParams params) async {
    return await _adminRepository.updateOrderStatus(params.orderId, params.status);
  }
}

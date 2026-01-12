import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/admin_repository.dart';

class VerifyDeliveryParams extends Equatable {
  final String orderId;
  final String qrCode;

  const VerifyDeliveryParams({required this.orderId, required this.qrCode});

  @override
  List<Object> get props => [orderId, qrCode];
}

class VerifyDeliveryUseCase
    implements UsecaseWithParams<void, VerifyDeliveryParams> {
  final IAdminRepository repository;
  VerifyDeliveryUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(VerifyDeliveryParams params) {
    return repository.verifyDelivery(params.orderId, params.qrCode);
  }
}

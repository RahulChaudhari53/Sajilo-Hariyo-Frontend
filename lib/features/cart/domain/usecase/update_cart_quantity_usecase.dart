import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/cart_repository.dart';

class UpdateCartQuantityParams extends Equatable {
  final String productId;
  final int quantity;

  const UpdateCartQuantityParams({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}

class UpdateCartQuantityUseCase
    implements UsecaseWithParams<void, UpdateCartQuantityParams> {
  final ICartRepository repository;
  UpdateCartQuantityUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdateCartQuantityParams params) {
    return repository.updateQuantity(params.productId, params.quantity);
  }
}

import 'package:dartz/dartz.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/cart_repository.dart';

class RemoveFromCartUseCase implements UsecaseWithParams<void, String> {
  final ICartRepository repository;
  RemoveFromCartUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(String productId) {
    return repository.removeFromCart(productId);
  }
}

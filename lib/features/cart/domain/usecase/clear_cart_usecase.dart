import 'package:dartz/dartz.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/cart_repository.dart';

class ClearCartUseCase implements UsecaseWithoutParams<void> {
  final ICartRepository repository;
  ClearCartUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call() {
    return repository.clearCart();
  }
}

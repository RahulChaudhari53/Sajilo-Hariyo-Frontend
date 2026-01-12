import 'package:dartz/dartz.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/cart_item_entity.dart';
import '../repository/cart_repository.dart';

class GetCartUseCase implements UsecaseWithoutParams<List<CartItemEntity>> {
  final ICartRepository repository;
  GetCartUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CartItemEntity>>> call() {
    return repository.getCartItems();
  }
}

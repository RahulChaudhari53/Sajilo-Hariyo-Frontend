import 'package:dartz/dartz.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/cart_item_entity.dart';
import '../repository/cart_repository.dart';

class AddToCartUseCase implements UsecaseWithParams<void, CartItemEntity> {
  final ICartRepository repository;
  AddToCartUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(CartItemEntity item) {
    return repository.addToCart(item);
  }
}

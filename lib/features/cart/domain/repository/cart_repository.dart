import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entity/cart_item_entity.dart';

abstract interface class ICartRepository {
  Future<Either<Failure, List<CartItemEntity>>> getCartItems();
  Future<Either<Failure, void>> addToCart(CartItemEntity item);
  Future<Either<Failure, void>> removeFromCart(String productId);
  Future<Either<Failure, void>> updateQuantity(String productId, int quantity);
  Future<Either<Failure, void>> clearCart();
}

import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/cart/data/data_source/local_data_source/cart_local_data_source.dart';
import 'package:sajilo_hariyo/features/cart/domain/entity/cart_item_entity.dart';
import 'package:sajilo_hariyo/features/cart/domain/repository/cart_repository.dart';

class CartLocalRepository implements ICartRepository {
  final CartLocalDataSource _cartLocalDataSource;

  CartLocalRepository(this._cartLocalDataSource);

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCartItems() async {
    try {
      final items = await _cartLocalDataSource.getCartItems();
      return Right(items);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(CartItemEntity item) async {
    try {
      await _cartLocalDataSource.addToCart(item);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(String productId) async {
    try {
      await _cartLocalDataSource.removeFromCart(productId);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateQuantity(String productId, int quantity) async {
    try {
      await _cartLocalDataSource.updateQuantity(productId, quantity);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await _cartLocalDataSource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
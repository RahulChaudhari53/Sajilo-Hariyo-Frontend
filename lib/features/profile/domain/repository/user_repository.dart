import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../entity/address_entity.dart';
import '../../../home/domain/entity/product_entity.dart';

abstract interface class IUserRepository {
  // --- Profile Management ---
  Future<Either<Failure, UserEntity>> getProfile();
  Future<Either<Failure, UserEntity>> updateProfile(
    UserEntity user, {
    File? image,
  });
  Future<Either<Failure, void>> changePassword(
    String oldPassword,
    String newPassword,
  );

  // --- Address Management ---
  Future<Either<Failure, List<AddressEntity>>> addAddress(
    AddressEntity address,
  );
  Future<Either<Failure, List<AddressEntity>>> updateAddress(
    AddressEntity address,
  );
  Future<Either<Failure, List<AddressEntity>>> deleteAddress(String addressId);

  // --- Wishlist (Favorites) Management ---
  Future<Either<Failure, List<ProductEntity>>> getWishlist();
  Future<Either<Failure, bool>> toggleWishlist(String productId);
}

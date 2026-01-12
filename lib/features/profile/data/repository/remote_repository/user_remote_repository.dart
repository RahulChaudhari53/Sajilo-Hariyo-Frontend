import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/auth/domain/entity/user_entity.dart';
import 'package:sajilo_hariyo/features/home/domain/entity/product_entity.dart';
import 'package:sajilo_hariyo/features/profile/data/data_source/user_data_source.dart';
import 'package:sajilo_hariyo/features/profile/domain/entity/address_entity.dart';
import 'package:sajilo_hariyo/features/profile/domain/repository/user_repository.dart';

class UserRemoteRepository implements IUserRepository {
  final IUserDataSource _userRemoteDataSource;

  UserRemoteRepository(this._userRemoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final userApiModel = await _userRemoteDataSource.getProfile();
      return Right(userApiModel.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(
    UserEntity user, {
    File? image,
  }) async {
    try {
      final userApiModel = await _userRemoteDataSource.updateProfile(
        user,
        image: image,
      );
      return Right(userApiModel.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      await _userRemoteDataSource.changePassword(oldPassword, newPassword);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, List<AddressEntity>>> addAddress(
    AddressEntity address,
  ) async {
    try {
      final addressModels = await _userRemoteDataSource.addAddress(address);
      final addressEntities = addressModels.map((m) => m.toEntity()).toList();
      return Right(addressEntities);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, List<AddressEntity>>> updateAddress(
    AddressEntity address,
  ) async {
    try {
      final addressModels = await _userRemoteDataSource.updateAddress(address);
      final addressEntities = addressModels.map((m) => m.toEntity()).toList();
      return Right(addressEntities);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, List<AddressEntity>>> deleteAddress(
    String addressId,
  ) async {
    try {
      final addressModels = await _userRemoteDataSource.deleteAddress(
        addressId,
      );
      final addressEntities = addressModels.map((m) => m.toEntity()).toList();
      return Right(addressEntities);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getWishlist() async {
    try {
      final productModels = await _userRemoteDataSource.getWishlist();
      final productEntities = productModels.map((m) => m.toEntity()).toList();
      return Right(productEntities);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleWishlist(String productId) async {
    try {
      final result = await _userRemoteDataSource.toggleWishlist(productId);
      return Right(result);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}

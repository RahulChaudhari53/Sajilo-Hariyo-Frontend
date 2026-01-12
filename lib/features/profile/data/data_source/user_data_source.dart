import 'dart:io';
import 'package:sajilo_hariyo/features/home/data/model/product_api_model.dart';
import 'package:sajilo_hariyo/features/profile/domain/entity/address_entity.dart';
import '../../../auth/data/model/user_api_model.dart';
import '../model/address_api_model.dart';
import '../../../auth/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  // Profile
  Future<UserApiModel> getProfile();
  Future<UserApiModel> updateProfile(UserEntity user, {File? image});
  Future<void> changePassword(String oldPassword, String newPassword);

  // Addresses
  Future<List<AddressApiModel>> addAddress(AddressEntity address);
  Future<List<AddressApiModel>> updateAddress(AddressEntity address);
  Future<List<AddressApiModel>> deleteAddress(String addressId);

  // Wishlist
  Future<List<ProductApiModel>> getWishlist();
  Future<bool> toggleWishlist(String productId);
}

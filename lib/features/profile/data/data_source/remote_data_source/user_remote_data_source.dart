import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:sajilo_hariyo/app/constant/api_endpoints.dart';
import 'package:sajilo_hariyo/features/auth/data/model/user_api_model.dart';
import 'package:sajilo_hariyo/features/auth/domain/entity/user_entity.dart';
import 'package:sajilo_hariyo/features/home/data/model/product_api_model.dart';
import 'package:sajilo_hariyo/features/profile/data/data_source/user_data_source.dart';
import 'package:sajilo_hariyo/features/profile/data/model/address_api_model.dart';
import 'package:sajilo_hariyo/features/profile/domain/entity/address_entity.dart';

class UserRemoteDataSource implements IUserDataSource {
  final Dio _dio;
  UserRemoteDataSource(this._dio);

  @override
  Future<UserApiModel> getProfile() async {
    try {
      var response = await _dio.get(ApiEndpoints.getProfile);
      if (response.statusCode == 200) {
        return UserApiModel.fromJson(response.data['data']['user']);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<UserApiModel> updateProfile(UserEntity user, {File? image}) async {
    try {
      FormData formData = FormData.fromMap({
        "name": user.name,
        "email": user.email,
        "phone": user.phone,
      });

      if (image != null) {
        formData.files.add(
          MapEntry(
            "profileImage", // Field name matches your backend upload middleware
            await MultipartFile.fromFile(
              image.path,
              contentType: MediaType("image", "jpeg"),
            ),
          ),
        );
      }

      var response = await _dio.patch(
        ApiEndpoints.updateProfile,
        data: formData,
      );
      if (response.statusCode == 200) {
        return UserApiModel.fromJson(response.data['data']['user']);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      var response = await _dio.patch(
        ApiEndpoints.updatePassword,
        data: {"currentPassword": oldPassword, "newPassword": newPassword},
      );
      if (response.statusCode != 200) {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<List<AddressApiModel>> addAddress(AddressEntity address) async {
    try {
      var response = await _dio.post(
        ApiEndpoints.addAddress,
        data: AddressApiModel.fromEntity(address).toJson(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> addressList = response.data['data']['addresses'];
        return addressList
            .map((json) => AddressApiModel.fromJson(json))
            .toList();
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<List<AddressApiModel>> updateAddress(AddressEntity address) async {
    try {
      var response = await _dio.patch(
        ApiEndpoints.updateAddress(address.id!),
        data: AddressApiModel.fromEntity(address).toJson(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> addressList = response.data['data']['addresses'];
        return addressList
            .map((json) => AddressApiModel.fromJson(json))
            .toList();
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<List<AddressApiModel>> deleteAddress(String addressId) async {
    try {
      var response = await _dio.delete(ApiEndpoints.deleteAddress(addressId));
      if (response.statusCode == 200) {
        final List<dynamic> addressList = response.data['data']['addresses'];
        return addressList
            .map((json) => AddressApiModel.fromJson(json))
            .toList();
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<List<ProductApiModel>> getWishlist() async {
    try {
      var response = await _dio.get(ApiEndpoints.getWishlist);
      if (response.statusCode == 200) {
        final List<dynamic> wishlistJson = response.data['data']['wishlist'];
        return wishlistJson
            .map((json) => ProductApiModel.fromJson(json))
            .toList();
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<bool> toggleWishlist(String productId) async {
    try {
      var response = await _dio.post(ApiEndpoints.toggleWishlist(productId));
      if (response.statusCode == 200) {
        return response.data['isAdded'] as bool;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}

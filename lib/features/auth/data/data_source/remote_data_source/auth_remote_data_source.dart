import 'package:dio/dio.dart';
import 'package:sajilo_hariyo/app/constant/api_endpoints.dart';
import 'package:sajilo_hariyo/features/auth/data/data_source/auth_data_source.dart';
import 'package:sajilo_hariyo/features/auth/data/model/user_api_model.dart';
import 'package:sajilo_hariyo/features/auth/domain/entity/user_entity.dart';

class AuthRemoteDataSource implements IAuthDataSource {
  // injecting dio directly because it is already configured by ApiService
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      var userApiModel = UserApiModel.fromEntity(user);

      var response = await _dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );

      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> loginUser(String phone, String password) async {
    try {
      var response = await _dio.post(
        ApiEndpoints.login,
        data: {"phone": phone, "password": password},
      );

      if (response.statusCode == 200) {
        // Extract token and user from response with null safety
        final responseData = response.data as Map<String, dynamic>;
        
        final token = responseData['token'] as String?;
        final data = responseData['data'] as Map<String, dynamic>?;
        final userData = data?['user'] as Map<String, dynamic>?;
        
        if (token == null || userData == null) {
          throw Exception('Invalid response: token or user data is null');
        }
        
        return {
          'token': token,
          'user': userData,
        };
      } else {
        throw Exception(response.statusMessage ?? 'Login failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> sendOtp(String email) async {
    try {
      var response = await _dio.post(
        ApiEndpoints.forgotPassword,
        data: {"email": email},
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> verifyOtp(String email, String otp) async {
    try {
      var response = await _dio.post(
        ApiEndpoints.verifyOtp,
        data: {"email": email, "otp": otp},
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> resetPassword(String email, String otp, String password) async {
    try {
      var response = await _dio.post(
        ApiEndpoints.resetPassword,
        data: {"email": email, "otp": otp, "password": password},
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/app/shared_pref/token_shared_pref.dart';
import 'package:sajilo_hariyo/app/shared_pref/user_shared_pref.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/auth/data/data_source/auth_data_source.dart';
import 'package:sajilo_hariyo/features/auth/data/model/user_api_model.dart';
import 'package:sajilo_hariyo/features/auth/domain/entity/user_entity.dart';
import 'package:sajilo_hariyo/features/auth/domain/repository/auth_repository.dart';

class AuthRemoteRepository implements IAuthRepository {
  final IAuthDataSource _authRemoteDataSource;
  final TokenSharedPref _tokenSharedPref;
  final UserSharedPref _userSharedPref;

  AuthRemoteRepository(
    this._authRemoteDataSource,
    this._tokenSharedPref,
    this._userSharedPref,
  );

  @override
  Future<Either<Failure, UserEntity>> loginUser(
    String phone,
    String password,
  ) async {
    try {
      final result = await _authRemoteDataSource.loginUser(phone, password);

      // final token = result['token'] as String;
      final token = result['token']?.toString() ?? "";
      final userData = result['user'] as Map<String, dynamic>;

      // Parse user from API response
      final userApiModel = UserApiModel.fromJson(userData);
      final userEntity = userApiModel.toEntity();

      // Save token and user
      await _tokenSharedPref.saveToken(token);
      await _userSharedPref.saveUser(userEntity);

      return Right(userEntity);
    } catch (e) {
      print(e.toString());
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _authRemoteDataSource.registerUser(user);
      return const Right(null);
    } catch (e) {
      print(e.toString());
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> sendOtp(String email) async {
    try {
      await _authRemoteDataSource.sendOtp(email);
      return const Right(null);
    } catch (e) {
      print(e.toString());
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp(String email, String otp) async {
    try {
      await _authRemoteDataSource.verifyOtp(email, otp);
      return const Right(null);
    } catch (e) {
      print(e.toString());
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    String email,
    String otp,
    String password,
  ) async {
    try {
      await _authRemoteDataSource.resetPassword(email, otp, password);
      return const Right(null);
    } catch (e) {
      print(e.toString());
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}

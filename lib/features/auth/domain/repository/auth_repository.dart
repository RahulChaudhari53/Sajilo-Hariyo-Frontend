import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/auth/domain/entity/user_entity.dart';

abstract class IAuthRepository {
  Future<Either<Failure, void>> registerUser(UserEntity user);

  Future<Either<Failure, UserEntity>> loginUser(String phone, String password);

  Future<Either<Failure, void>> sendOtp(String email);

  Future<Either<Failure, void>> verifyOtp(String email, String otp);

  Future<Either<Failure, void>> resetPassword(
    String email,
    String otp,
    String password,
  );
}

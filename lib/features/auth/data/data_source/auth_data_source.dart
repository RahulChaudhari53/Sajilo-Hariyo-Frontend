import 'package:sajilo_hariyo/features/auth/domain/entity/user_entity.dart';

abstract class IAuthDataSource {
  Future<void> registerUser(UserEntity user);

  Future<Map<String, dynamic>> loginUser(String phone, String password);

  Future<void> sendOtp(String email);

  Future<void> verifyOtp(String email, String otp);

  Future<void> resetPassword(String email, String otp, String password);
}

import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/core/enums/user_role.dart';
import 'package:sajilo_hariyo/features/auth/domain/entity/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPref {
  final SharedPreferences _sharedPreferences;
  UserSharedPref(this._sharedPreferences);

  Future<Either<Failure, void>> saveUser(UserEntity user) async {
    try {
      await _sharedPreferences.setString('user_id', user.id ?? '');
      await _sharedPreferences.setString('user_name', user.name);
      await _sharedPreferences.setString('user_email', user.email);
      await _sharedPreferences.setString('user_phone', user.phone);
      await _sharedPreferences.setString('user_role', user.role ?? 'customer');
      await _sharedPreferences.setString('user_profile_image', user.profileImage ?? '');
      return const Right(null);
    } catch (error) {
      return Left(SharedPreferenceFailure(message: error.toString()));
    }
  }

  Future<Either<Failure, UserEntity>> getUser() async {
    try {
      final id = _sharedPreferences.getString('user_id');
      final name = _sharedPreferences.getString('user_name') ?? '';
      final email = _sharedPreferences.getString('user_email') ?? '';
      final phone = _sharedPreferences.getString('user_phone') ?? '';
      final role = _sharedPreferences.getString('user_role') ?? 'customer';
      final profileImage = _sharedPreferences.getString('user_profile_image');

      if (name.isEmpty && email.isEmpty) {
        return Left(SharedPreferenceFailure(message: 'No user data found'));
      }

      final user = UserEntity(
        id: id,
        name: name,
        email: email,
        phone: phone,
        password: '', 
        role: role,
        profileImage: profileImage,
      );

      return Right(user);
    } catch (error) {
      return Left(SharedPreferenceFailure(message: error.toString()));
    }
  }

  Future<Either<Failure, void>> clearUser() async {
    try {
      await _sharedPreferences.remove('user_id');
      await _sharedPreferences.remove('user_name');
      await _sharedPreferences.remove('user_email');
      await _sharedPreferences.remove('user_phone');
      await _sharedPreferences.remove('user_role');
      await _sharedPreferences.remove('user_profile_image');
      return const Right(null);
    } catch (error) {
      return Left(SharedPreferenceFailure(message: error.toString()));
    }
  }

  UserRole? getStoredRole() {
    final roleString = _sharedPreferences.getString('user_role');
    return roleString != null ? UserRole.fromString(roleString) : null;
  }
}

import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenSharedPref {
  final SharedPreferences _sharedPreferences;
  TokenSharedPref(this._sharedPreferences);

  String? _token;

  Future<Either<Failure, String>> getToken() async {
    try {
      _token = _sharedPreferences.getString('jwt_token');
      return Right(_token ?? '');
    } catch (error) {
      return Left(SharedPreferenceFailure(message: error.toString()));
    }
  }

  Future<Either<Failure, void>> saveToken(String token) async {
    try {
      _token = token;
      await _sharedPreferences.setString('jwt_token', token);
      return Right(null);
    } catch (error) {
      return Left(SharedPreferenceFailure(message: error.toString()));
    }
  }

  Future<Either<Failure, void>> clearToken() async {
    try {
      _token = null;
      await _sharedPreferences.remove('jwt_token');
      return Right(null);
    } catch (error) {
      return Left(SharedPreferenceFailure(message: error.toString()));
    }
  }

  bool isFirstTime() {
    return _sharedPreferences.getBool('isFirstTime') ?? true;
  }

  Future<void> saveFirstTime() async {
    await _sharedPreferences.setBool('isFirstTime', false);
  }
}

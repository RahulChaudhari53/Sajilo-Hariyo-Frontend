import 'package:dio/dio.dart';
import 'package:sajilo_hariyo/app/shared_pref/token_shared_pref.dart';

class AuthInterceptor extends Interceptor {
  final TokenSharedPref _tokenSharedPref;

  AuthInterceptor(this._tokenSharedPref);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final result = await _tokenSharedPref.getToken();

    result.fold(
      (failure) {
        handler.next(options);
      },
      (token) {
        if (token.isNotEmpty) {
          options.headers['Authorization'] = "Bearer $token";
        }
        handler.next(options);
      },
    );
  }
}

import 'package:dio/dio.dart';

class DioErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // add global error handling logic here later
    // if 401 logout the user automatically

    if (err.response?.statusCode == 401) {
      // todo : clear shared pref and navigate to login
      print("Global Error: Token Expired or Invalid");
    }

    super.onError(err, handler);
  }
}

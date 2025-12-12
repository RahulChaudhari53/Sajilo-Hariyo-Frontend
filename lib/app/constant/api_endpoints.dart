class ApiEndpoints {
  ApiEndpoints._();

  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  static const String serverAddress = "http://10.0.2.2:5050";

  static const String baseUrl = "$serverAddress/api";

  // =============== Auth Endpoints ===============
  static const String login = "$baseUrl/users/login";
  static const String register = "$baseUrl/users/register";
  static const String forgotPassword = "$baseUrl/users/forgotPassword";
  static const String verifyOtp = "$baseUrl/users/verifyOtp";
  static const String resetPassword = "$baseUrl/users/resetPassword";

  // ===============  ===============
}

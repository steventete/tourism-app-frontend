class ApiRoutes {
  // Base url
  static const String baseUrl = 'https://app-turismo.onrender.com/api';

  // Auth
  static const String login = '$baseUrl/auth/login';
  static const String refreshToken = '$baseUrl/auth/refresh';
  static const String register = '$baseUrl/auth/register';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';

  // OAuth
  static const String googleMobile = '$baseUrl/auth/google/mobile';
}

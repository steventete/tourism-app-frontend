class ApiRoutes {
  static const String baseUrl = 'https://face-needs-highlighted-zoo.trycloudflare.com/api';

  static const String login = '$baseUrl/auth/login';
  static const String refreshToken = '$baseUrl/auth/refresh';
  static const String register = '$baseUrl/auth/register';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';

  static const String googleMobile = '$baseUrl/auth/google/mobile';

  static const String getAllPlaces = '$baseUrl/places';
  static const String searchPlaces = '$baseUrl/places/search';
}
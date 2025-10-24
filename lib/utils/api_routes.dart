class ApiRoutes {
  static const String baseUrl = 'https://highlight-wal-entrepreneur-sen.trycloudflare.com/api';
  // Auth routes
  static const String login = '$baseUrl/auth/login';
  static const String refreshToken = '$baseUrl/auth/refresh';
  static const String register = '$baseUrl/auth/register';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String googleMobile = '$baseUrl/auth/google/mobile';
  // Places routes
  static const String getAllPlaces = '$baseUrl/places';
  static const String searchPlaces = '$baseUrl/places/search';
  static const String askAI = '$baseUrl/places/ask';
  // User routes
  static const String getUserProfile = '$baseUrl/users/me';
  static const String updateUserProfilePhoto = '$baseUrl/users/picture/';
}

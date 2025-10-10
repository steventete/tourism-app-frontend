import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {

  static const _storage = FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _expiryKey = 'access_token_expiry';

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    int expiresIn = 7200, 
  }) async {
    final expiryDate =
        DateTime.now().add(Duration(seconds: expiresIn)).toIso8601String();

    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(key: _expiryKey, value: expiryDate);
  }

  /// Obtiene el access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Obtiene el refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Verifica si el access token expiró
  static Future<bool> isAccessTokenExpired() async {
    final expiry = await _storage.read(key: _expiryKey);
    if (expiry == null) return true;
    final expiryDate = DateTime.tryParse(expiry);
    if (expiryDate == null) return true;
    return DateTime.now().isAfter(expiryDate);
  }

  static Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _expiryKey);
  }
}

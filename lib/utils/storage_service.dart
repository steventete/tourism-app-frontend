import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _expiryKey = 'access_token_expiry';
  static const _userIdentifierKey = 'user_identifier';

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
  }) async {
    final expiryDate = DateTime.now().add(Duration(seconds: expiresIn));
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(key: _expiryKey, value: expiryDate.toIso8601String());
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

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

  static Future<void> saveUserIdentifier(String identifier) async {
    await _storage.write(key: _userIdentifierKey, value: identifier);
  }

  static Future<String?> getUserIdentifier() async {
    return await _storage.read(key: _userIdentifierKey);
  }
}

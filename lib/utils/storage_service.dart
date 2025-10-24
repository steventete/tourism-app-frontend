import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tourism_app/models/user_profile.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();

  // Claves de almacenamiento
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyTokenExpiration = 'token_expiration';
  static const String _keyUserIdentifier = 'user_identifier';
  static const String _keyUserProfile = 'user_profile';

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
  }) async {
    final expirationTime = DateTime.now()
        .add(Duration(seconds: expiresIn))
        .toIso8601String();

    await Future.wait([
      _storage.write(key: _keyAccessToken, value: accessToken),
      _storage.write(key: _keyRefreshToken, value: refreshToken),
      _storage.write(key: _keyTokenExpiration, value: expirationTime),
    ]);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  static Future<bool> isAccessTokenExpired() async {
    final expiration = await _storage.read(key: _keyTokenExpiration);
    if (expiration == null) return true;

    try {
      final expirationDate = DateTime.parse(expiration);
      return DateTime.now().isAfter(expirationDate);
    } catch (e) {
      return true;
    }
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  static Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _keyAccessToken),
      _storage.delete(key: _keyRefreshToken),
      _storage.delete(key: _keyTokenExpiration),
      _storage.delete(key: _keyUserIdentifier),
      _storage.delete(key: _keyUserProfile),
    ]);
  }

  static Future<void> saveUserIdentifier(String identifier) async {
    await _storage.write(key: _keyUserIdentifier, value: identifier);
  }

  static Future<String?> getUserIdentifier() async {
    return await _storage.read(key: _keyUserIdentifier);
  }

  static Future<void> saveUserProfile(UserProfile profile) async {
    try {
      final jsonString = jsonEncode(profile.toJson());
      await _storage.write(key: _keyUserProfile, value: jsonString);
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserProfile?> getUserProfile() async {
    try {
      final jsonString = await _storage.read(key: _keyUserProfile);
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString);
      return UserProfile.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearUserProfile() async {
    await _storage.delete(key: _keyUserProfile);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    final profile = await getUserProfile();
    return token != null && profile != null;
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}

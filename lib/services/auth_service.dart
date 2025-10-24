import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tourism_app/utils/api_routes.dart';
import 'package:tourism_app/utils/storage_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
    String identifier,
    String password,
  ) async {
    final url = Uri.parse(ApiRoutes.login);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"identifier": identifier, "password": password}),
      );

      Map<String, dynamic> data = {};
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = {"message": response.body};
      }

      if (response.statusCode == 200) {
        final accessToken = data["accessToken"];
        final refreshToken = data["refreshToken"];

        if (accessToken != null && refreshToken != null) {
          await StorageService.saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresIn: 7200,
          );

          final identifier = data["user"]?["identifier"] ?? data["identifier"];
          if (identifier != null) {
            await StorageService.saveUserIdentifier(identifier);
          }
        }

        return {
          "success": true,
          "message": data["message"] ?? "Inicio de sesión exitoso",
        };
      } else {
        return {
          "success": false,
          "message": data["message"] ?? "Error al iniciar sesión",
        };
      }
    } catch (e) {
      print("Error en AuthService.login: $e");
      return {"success": false, "message": "Error de conexión con el servidor"};
    }
  }

  static Future<String?> refreshToken() async {
    try {
      final refreshToken = await StorageService.getRefreshToken();
      if (refreshToken == null) return null;

      final response = await http.post(
        Uri.parse(ApiRoutes.refreshToken),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];

        if (newAccessToken != null && newRefreshToken != null) {
          await StorageService.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
            expiresIn: 7200,
          );
          return newAccessToken;
        }
      }
    } catch (e) {
      print("Error en refreshToken: $e");
    }

    return null;
  }

  static Future<void> logout() async {
    await StorageService.clearTokens();
  }

  static Future<String?> getAccessToken() async {
    return await StorageService.getAccessToken();
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tourism_app/utils/api_routes.dart';
import 'package:tourism_app/utils/storage_service.dart';
import 'auth_service.dart';

class UserService {
  static Future<Map<String, dynamic>?> getProfile(String identifier) async {
    try {
      String? accessToken = await StorageService.getAccessToken();

      if (accessToken == null || await StorageService.isAccessTokenExpired()) {
        // Si el token expiró, intenta renovarlo
        accessToken = await AuthService.refreshToken();
        if (accessToken == null) {
          return null; // No se pudo renovar
        }
      }

      final response = await http.get(
        Uri.parse("${ApiRoutes.baseUrl}/users/$identifier"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'x-lang': 'es',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        return data;
      } else {
        print("Error al obtener perfil: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Excepción en getProfile: $e");
      return null;
    }
  }

  static Future<bool> updateProfile(String identifier,String username, String displayname ) async {
    try {
      String? accessToken = await StorageService.getAccessToken();
      if (accessToken == null) return false;

      final response = await http.put(
        Uri.parse("${ApiRoutes.baseUrl}/users/$identifier"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'x-lang': 'es',
        },body: json.encode({
        "username": username,
        "displayname": displayname,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error al actualizar perfil: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Excepción en updateProfile: $e");
      return false;
    }
  }
  
    /// 🔹 Actualiza la foto de perfil del usuario
  static Future<bool> updateProfilePicture(String identifier, String filePath) async {
    try {
      String? accessToken = await StorageService.getAccessToken();
      if (accessToken == null) return false;

      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse("${ApiRoutes.baseUrl}/users/$identifier/picture"),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'x-lang': 'es',
      });

      // Adjuntar imagen al cuerpo del request
      request.files.add(await http.MultipartFile.fromPath('picture', filePath));

      var response = await request.send();

      if (response.statusCode == 200) {
        print("✅ Imagen actualizada correctamente.");
        return true;
      } else {
        print("❌ Error al actualizar imagen: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Excepción en updateProfilePicture: $e");
      return false;
    }
  }

}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tourism_app/models/user_profile.dart';
import 'package:tourism_app/utils/api_routes.dart';
import 'package:tourism_app/utils/storage_service.dart';

class AuthService {
  // ==================== LOGIN ====================
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

          // Obtener y guardar el perfil del usuario
          await fetchAndSaveUserProfile();
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

  // ==================== FETCH USER PROFILE ====================
  static Future<UserProfile?> fetchAndSaveUserProfile() async {
    try {
      final accessToken = await StorageService.getAccessToken();
      if (accessToken == null) {
        print("No hay token de acceso disponible");
        return null;
      }

      final response = await http.get(
        Uri.parse(ApiRoutes.getUserProfile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final profile = UserProfile.fromJson(data);
        
        // Guardar el perfil en el almacenamiento seguro
        await StorageService.saveUserProfile(profile);
        
        return profile;
      } else if (response.statusCode == 401) {
        // Token expirado, intentar refrescar
        final newToken = await refreshToken();
        if (newToken != null) {
          // Reintentar con el nuevo token
          return await fetchAndSaveUserProfile();
        }
      }

      print("Error al obtener perfil: ${response.statusCode}");
      return null;
    } catch (e) {
      print("Error en fetchAndSaveUserProfile: $e");
      return null;
    }
  }

  // ==================== GET CACHED USER PROFILE ====================
  static Future<UserProfile?> getUserProfile() async {
    return await StorageService.getUserProfile();
  }

  // ==================== REFRESH USER PROFILE ====================
  static Future<UserProfile?> refreshUserProfile() async {
    return await fetchAndSaveUserProfile();
  }

  // ==================== REFRESH TOKEN ====================
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

  // ==================== LOGOUT ====================
  static Future<void> logout() async {
    await StorageService.clearTokens();
  }

  // ==================== GET ACCESS TOKEN ====================
  static Future<String?> getAccessToken() async {
    return await StorageService.getAccessToken();
  }

  // ==================== CHECK AUTH STATUS ====================
  static Future<bool> isAuthenticated() async {
    return await StorageService.isLoggedIn();
  }

  // ==================== UPDATE PROFILE PICTURE ====================
  static Future<bool> updateProfilePicture(String filePath) async {
    try {
      final accessToken = await StorageService.getAccessToken();
      final profile = await StorageService.getUserProfile();
      
      if (accessToken == null || profile == null) {
        print("No hay token o perfil disponible");
        return false;
      }

      final request = http.MultipartRequest(
        'PATCH',
        Uri.parse('${ApiRoutes.updateUserProfilePhoto}${profile.id}'),
      );

      request.headers['Authorization'] = 'Bearer $accessToken';
      request.files.add(await http.MultipartFile.fromPath('picture', filePath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Actualizar el perfil después de cambiar la foto
        await fetchAndSaveUserProfile();
        return true;
      } else if (response.statusCode == 401) {
        // Token expirado, intentar refrescar
        final newToken = await refreshToken();
        if (newToken != null) {
          return await updateProfilePicture(filePath);
        }
      }

      print("Error al actualizar foto: ${response.statusCode} - ${response.body}");
      return false;
    } catch (e) {
      print("Error en updateProfilePicture: $e");
      return false;
    }
  }
}
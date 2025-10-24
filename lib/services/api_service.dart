import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tourism_app/utils/api_routes.dart';
import 'package:tourism_app/services/auth_service.dart';

class ApiService {
  static Future<String?> _getToken() async {
    return await AuthService.getAccessToken();
  }

  static Future<List<dynamic>> getAllPlaces() async {
    final token = await _getToken();
    final uri = Uri.parse(ApiRoutes.getAllPlaces);

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "x-lang": "es",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data is List) ? data : [];
    } else if (response.statusCode == 401) {
      throw Exception("Token inválido o expirado");
    } else {
      throw Exception("Error al obtener lugares: ${response.body}");
    }
  }

  static Future<List<Map<String, dynamic>>> searchPlaces({
    String? category,
    String? budget,
    String? groupSize,
    String? time,
  }) async {
    final token = await _getToken();

    final queryParams = {
      "category": category ?? "restaurants",
      "query": "recomendacion",
      "limit": "5",
    };

    final uri = Uri.parse(
      ApiRoutes.searchPlaces,
    ).replace(queryParameters: queryParams);

    print("🛰️ URL final: $uri");

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "x-lang": "es",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    print("📥 Código: ${response.statusCode}");
    print("📦 Cuerpo: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final docs = data["documents"] != null && data["documents"].isNotEmpty
          ? data["documents"][0]
          : [];
      final metas = data["metadatas"] != null && data["metadatas"].isNotEmpty
          ? data["metadatas"][0]
          : [];

      List<Map<String, dynamic>> results = [];
      for (int i = 0; i < docs.length; i++) {
        final meta = metas.isNotEmpty && i < metas.length ? metas[i] : {};
        results.add({
          "name": meta["name"] ?? "Lugar sin nombre",
          "description": meta["description"] ?? "Sin descripción disponible",
          "imageUrl": meta["imageUrl"] ?? "",
          "category": category ?? "Desconocido",
        });
      }

      return results;
    } else if (response.statusCode == 401) {
      throw Exception("Token inválido o expirado");
    } else {
      throw Exception("Error al buscar lugares: ${response.body}");
    }
  }
}

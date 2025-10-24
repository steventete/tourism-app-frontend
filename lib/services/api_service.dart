import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tourism_app/utils/api_routes.dart';
import 'package:tourism_app/services/auth_service.dart';
import 'package:tourism_app/models/ai_response.dart';

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

      final places = (data["places"] != null && data["places"] is List)
          ? List<Map<String, dynamic>>.from(data["places"])
          : [];

      List<Map<String, dynamic>> results = [];

      for (final p in places) {
        final place = {
          "name": p["name"] ?? "Lugar sin nombre",
          "description": p["address"] ?? "Sin descripción disponible",
          "imageUrl": (p["photos"] is List && p["photos"].isNotEmpty)
              ? p["photos"][0]
              : "https://picsum.photos/seed/picsum/200/300",
          "category": p["category"] ?? "Desconocido",
          "city": p["address"]?.toString().contains("Cartagena") == true
              ? "Cartagena"
              : "Desconocida",
          "latitude": double.tryParse(p["latitude"]?.toString() ?? "0") ?? 0.0,
          "longitude":
              double.tryParse(p["longitude"]?.toString() ?? "0") ?? 0.0,
          "rating": double.tryParse(p["rating"]?.toString() ?? "0") ?? 0.0,
        };

        print("📍 [ApiService] Lugar: $place");
        results.add(place);
      }

      return results;
    } else if (response.statusCode == 401) {
      throw Exception("Token inválido o expirado");
    } else {
      throw Exception("Error al buscar lugares: ${response.body}");
    }
  }

  static Future<AiResponse> askAI(String question) async {
    final token = await _getToken();

    final uri = Uri.parse(ApiRoutes.askAI).replace(
      queryParameters: {"question": question, "model": "llama3.2:latest"},
    );

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "x-lang": "es",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode({"question": question}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AiResponse.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception("Token inválido o expirado");
    } else {
      throw Exception("Error al consultar IA: ${response.body}");
    }
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final uri = Uri.parse(ApiRoutes.forgotPassword);

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json", "x-lang": "es"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al solicitar restablecimiento: ${response.body}");
    }
  }
}

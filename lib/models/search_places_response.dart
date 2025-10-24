import 'dart:convert';

SearchPlacesResponse searchPlacesResponseFromJson(String str) =>
    SearchPlacesResponse.fromJson(json.decode(str));

class SearchPlacesResponse {
  final List<Place> places;

  SearchPlacesResponse({
    required this.places,
  });

  factory SearchPlacesResponse.fromJson(Map<String, dynamic> json) {
    final placesJson = json["places"] as List<dynamic>? ?? [];
    return SearchPlacesResponse(
      places: placesJson.map((e) => Place.fromJson(e)).toList(),
    );
  }
}

class Place {
  final String id;
  final String name;
  final String category;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final int priceLevel;
  final List<String> photos;

  Place({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.priceLevel,
    required this.photos,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json["id"] ?? "",
      name: json["name"] ?? "Lugar sin nombre",
      category: json["category"] ?? "Desconocido",
      address: json["address"] ?? "Sin dirección",
      latitude: double.tryParse(json["latitude"]?.toString() ?? "0") ?? 0.0,
      longitude: double.tryParse(json["longitude"]?.toString() ?? "0") ?? 0.0,
      rating: double.tryParse(json["rating"]?.toString() ?? "0") ?? 0.0,
      priceLevel: json["priceLevel"] ?? 0,
      photos: (json["photos"] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

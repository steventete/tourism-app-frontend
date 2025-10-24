class Place {
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final String city;
  final double latitude;
  final double longitude;

  Place({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json["name"] ?? "Lugar sin nombre",
      description: json["description"] ?? "Sin descripción disponible",
      imageUrl: (json["imageUrl"]?.toString().isNotEmpty == true)
          ? json["imageUrl"]
          : "https://via.placeholder.com/400x300?text=Sin+Imagen",
      category: json["category"] ?? "Desconocido",
      city: json["city"] ?? "Desconocida",
      latitude: double.tryParse(json["latitude"]?.toString() ?? "0") ?? 0.0,
      longitude: double.tryParse(json["longitude"]?.toString() ?? "0") ?? 0.0,
    );
  }
}

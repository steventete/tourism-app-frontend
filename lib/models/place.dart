class Place {
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final String city;

  Place({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.city,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'] ?? 'Sin nombre',
      description: json['description'] ?? 'Sin descripción',
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/300',
      category: json['category'] ?? 'Sin categoría',
      city: json['city'] ?? 'Desconocida',
    );
  }
}
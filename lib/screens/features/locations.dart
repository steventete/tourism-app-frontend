import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'location_detail.dart';

class Location {
  final String name;
  final String description;
  final List<String> images;
  final double lat;
  final double lng;
  final double rating;
  final String category;
  final String address;
  final String? phone;

  Location({
    required this.name,
    required this.description,
    required this.images,
    required this.lat,
    required this.lng,
    required this.rating,
    required this.category,
    required this.address,
    this.phone,
  });
}


final List<Location> locations = [
  Location(
    name: "Ciudad Amurallada",
    description:
        "El corazón histórico de Cartagena, con calles empedradas y arquitectura colonial.",
    images: [
      "https://mlqfmr3rpryd.i.optimole.com/cb:JBSP.a525/w:auto/h:auto/q:100/ig:avif/https://cartagena-tours.co/wp-content/uploads/2023/12/Torre-del-Reloj-en-Cartagena-de-Indias-Colombia.jpg",
      "https://cdn-ilcfjhh.nitrocdn.com/AMsOVcaxJEBiDUJmLghgteLoXmGyZJhB/assets/images/optimized/rev-c7d5926/cartagena-tours.co/wp-content/uploads/2023/12/Travelocity-Cartagena-Destacada.Galeria.jpg",
    ],
    lat: 10.4220,
    lng: -75.5400,
    rating: 4.8,
    category: "Histórico",
    address: "Centro Histórico, Cartagena de Indias",
    phone: "3001234567",
  ),
  Location(
    name: "Playa Blanca",
    description: "Arena blanca y aguas cristalinas en la isla de Barú, ideal para relajarse.",
    images: [
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/3f/9e/5f/img-20181031-wa0013-largejpg.jpg?w=1200&h=-1&s=1",
    ],
    lat: 10.2340,
    lng: -75.5790,
    rating: 4.7,
    category: "Playa",
    address: "Isla de Barú, Cartagena de Indias",
    phone: "3109876543",
  ),
  Location(
    name: "Castillo de San Felipe de Barajas",
    description:
        "Imponente fortaleza militar que protegía la ciudad de ataques piratas y coloniales.",
    images: [
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0a/8d/4a/60/castillo-de-san-felipe.jpg?w=900&h=500&s=1",
    ],
    lat: 10.4230,
    lng: -75.5500,
    rating: 4.9,
    category: "Histórico",
    address: "Cerro San Lázaro, Cartagena de Indias",
    phone: "6056665555",
  ),
];


class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  String? _city;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever ||
            permission == LocationPermission.denied) {
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition();

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      setState(() {
        _city = placemarks.first.locality ?? "Ubicación desconocida";
      });
    } catch (e) {
      setState(() => _city = "Ubicación no disponible");
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0ba6da);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Explora cerca de ti 🌍",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_rounded, color: primaryColor, size: 22),
                const SizedBox(width: 4),
                Text(
                  _city ?? "Detectando ubicación...",
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final loc = locations[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LocationDetailPage(location: loc),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                        child: Image.network(
                          loc.images.first,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                              const SizedBox(width: 3),
                              Text(
                                loc.rating.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            loc.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          loc.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Inter',
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

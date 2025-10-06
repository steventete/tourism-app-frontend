import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'locations.dart';

class LocationDetailPage extends StatefulWidget {
  final Location location;
  const LocationDetailPage({super.key, required this.location});

  @override
  State<LocationDetailPage> createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final location = widget.location;
    final LatLng position = LatLng(location.lat, location.lng);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Stack(
                  children: [
                    Hero(
                      tag: location.name,
                      child: SizedBox(
                        height: 320,
                        width: double.infinity,
                        child: PageView.builder(
                          itemCount: location.images.length,
                          onPageChanged: (index) =>
                              setState(() => _currentPage = index),
                          itemBuilder: (context, index) {
                            return Image.network(
                              location.images[index],
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                 
                    Container(
                      height: 320,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black54, Colors.transparent],
                        ),
                      ),
                    ),
                 
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black45,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ),
                   
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            List.generate(location.images.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            height: 8,
                            width: _currentPage == index ? 20 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.white38,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

               
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Colors.amber, size: 22),
                          const SizedBox(width: 4),
                          Text(
                            "${location.rating}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 10),
                          _buildBadge(Icons.category_rounded, location.category),
                        ],
                      ),
                      const SizedBox(height: 20),

                      
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        elevation: 3,
                        shadowColor: Colors.black26,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            location.description,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      
                      const Text(
                        "Información",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      _buildInfoItem(Icons.schedule, "Horario", "8:00 AM - 9:00 PM"),
                      _buildInfoItem(Icons.place, "Dirección", location.address),
                      _buildInfoItem(Icons.phone, "Contacto", "+57 312 555 8899"),
                      const SizedBox(height: 25),

                     
                      const Text(
                        "Ubicación",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: SizedBox(
                          height: 300,
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: position,
                              initialZoom: 15,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                userAgentPackageName: 'com.example.tourism_app',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: position,
                                    width: 45,
                                    height: 45,
                                    child: const Icon(
                                      Icons.location_pin,
                                      color: Color(0xFF0ba6da),
                                      size: 45,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Botón flotante “Cómo llegar”
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () async {
                final uri = Uri.parse(
                    "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}");
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.directions_rounded),
              label: const Text(
                "Cómo llegar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0ba6da),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0ba6da)),
          const SizedBox(width: 12),
          Text(
            "$title: ",
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0ba6da).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF0ba6da)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF0ba6da)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF0ba6da),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/place.dart';

class RecomendationsPage extends StatefulWidget {
  const RecomendationsPage({super.key});

  @override
  State<RecomendationsPage> createState() => _RecomendationsPageState();
}

class _RecomendationsPageState extends State<RecomendationsPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCategory;
  String? selectedBudget;
  String? selectedGroupSize;
  String? selectedTime;
  bool isLoading = false;
  List<Place> recommendations = [];

  final Color primaryColor = const Color(0xFF0ba6da);
  final Color backgroundColor = const Color(0xFFF8FAFB);

  final List<String> categories = [
    "Restaurantes",
    "Bares",
    "Discotecas",
    "Entretenimiento",
    "Turismo",
    "Compras",
    "Servicios",
    "Hoteles",
  ];

  final List<String> budgets = [
    "Menos de \$50.000",
    "Entre \$50.000 y \$150.000",
    "Más de \$150.000",
  ];

  final List<String> groupSizes = [
    "1 persona",
    "2 personas",
    "3-5 personas",
    "Más de 5 personas",
  ];

  final List<String> times = [
    "Mañana",
    "Tarde",
    "Noche",
    "Todo el día",
  ];

  String _mapCategory(String? cat) {
    if (cat == null) return "restaurants";
    switch (cat.toLowerCase()) {
      case "bares":
        return "bars";
      case "restaurantes":
        return "restaurants";
      case "discotecas":
        return "nightclubs";
      case "entretenimiento":
        return "entertainment";
      case "turismo":
        return "tourism";
      case "compras":
        return "shopping";
      case "servicios":
        return "services";
      case "hoteles":
        return "hotels";
      default:
        return "restaurants";
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      recommendations.clear();
    });

    try {
      final data = await ApiService.searchPlaces(
        category: _mapCategory(selectedCategory), // 👈 aquí se hace el mapeo correcto
        budget: selectedBudget,
        groupSize: selectedGroupSize,
        time: selectedTime,
      );

      final places = data.map<Place>((json) => Place.fromJson(json)).toList();

      setState(() {
        recommendations = places;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al obtener recomendaciones: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Smart Recommender",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildForm(),
            const SizedBox(height: 30),
            if (isLoading)
              const CircularProgressIndicator()
            else if (recommendations.isNotEmpty)
              _buildRecommendationsList()
            else
              const Text(
                "Selecciona tus preferencias y obtén recomendaciones personalizadas ✨",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tu experiencia personalizada ✨",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Selecciona tus preferencias para obtener recomendaciones únicas de nuestro asistente turístico.",
              style: TextStyle(color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 25),

            _buildDropdown(
              label: "Tipo de lugar",
              icon: Icons.place_outlined,
              value: selectedCategory,
              items: categories,
              onChanged: (v) => setState(() => selectedCategory = v),
            ),
            const SizedBox(height: 18),

            _buildDropdown(
              label: "Presupuesto",
              icon: Icons.attach_money_rounded,
              value: selectedBudget,
              items: budgets,
              onChanged: (v) => setState(() => selectedBudget = v),
            ),
            const SizedBox(height: 18),

            _buildDropdown(
              label: "Número de personas",
              icon: Icons.group_outlined,
              value: selectedGroupSize,
              items: groupSizes,
              onChanged: (v) => setState(() => selectedGroupSize = v),
            ),
            const SizedBox(height: 18),

            _buildDropdown(
              label: "Horario preferido",
              icon: Icons.schedule_outlined,
              value: selectedTime,
              items: times,
              onChanged: (v) => setState(() => selectedTime = v),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Obtener Recomendación",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: recommendations.map((place) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (place.imageUrl != null && place.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    place.imageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.image_not_supported_outlined),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      place.description,
                      style: const TextStyle(
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "📍 ${place.category ?? 'Sin categoría'}",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
    String? value,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryColor),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      value: value,
      items:
          items.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? "Campo requerido" : null,
    );
  }
}

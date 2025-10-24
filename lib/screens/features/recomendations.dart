import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/place.dart';
import '../../utils/theme_controller.dart';

class RecomendationsPage extends StatefulWidget {
  final ThemeController themeController;

  const RecomendationsPage({
    super.key,
    required this.themeController,
  });

  @override
  State<RecomendationsPage> createState() => _RecomendationsPageState();
}

class _RecomendationsPageState extends State<RecomendationsPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  List<Place> recommendations = [];

  String? selectedCategory;
  String? selectedBudget;
  String? selectedGroupSize;
  String? selectedTime;

  static const Color primaryColor = Color(0xFF0ba6da);

  final categories = const [
    "Restaurantes",
    "Bares",
    "Discotecas",
    "Entretenimiento",
    "Turismo",
    "Compras",
    "Servicios",
    "Hoteles",
  ];

  final budgets = const [
    "Menos de \$50.000",
    "Entre \$50.000 y \$150.000",
    "Más de \$150.000",
  ];

  final groupSizes = const [
    "1 persona",
    "2 personas",
    "3-5 personas",
    "Más de 5 personas",
  ];

  final times = const [
    "Mañana",
    "Tarde",
    "Noche",
    "Todo el día",
  ];

  final categoryMap = const {
    "restaurantes": "restaurants",
    "bares": "bars",
    "discotecas": "nightclubs",
    "entretenimiento": "entertainment",
    "turismo": "tourism",
    "compras": "shopping",
    "servicios": "services",
    "hoteles": "hotels",
  };

  String _mapCategory(String? cat) =>
      categoryMap[cat?.toLowerCase() ?? "restaurantes"] ?? "restaurants";

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final data = await ApiService.searchPlaces(
        category: _mapCategory(selectedCategory),
        budget: selectedBudget,
        groupSize: selectedGroupSize,
        time: selectedTime,
      );

      final places = data.map<Place>(Place.fromJson).toList();

      setState(() => recommendations = places);
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
    final bool isDark = widget.themeController.isDarkMode;
    final Color backgroundColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFB);
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subtitleColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cardColor,
        title: Text(
          "Smart Recommender",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildForm(isDark, cardColor, textColor, subtitleColor),
            const SizedBox(height: 30),
            if (isLoading)
              const CircularProgressIndicator()
            else if (recommendations.isNotEmpty)
              _buildRecommendationsList(isDark, cardColor, subtitleColor, textColor)
            else
              Text(
                "Selecciona tus preferencias y obtén recomendaciones personalizadas.",
                textAlign: TextAlign.center,
                style: TextStyle(color: subtitleColor),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(bool isDark, Color cardColor, Color textColor, Color subtitleColor) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : const Color(0x11000000),
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
            Text(
              "Tu experiencia personalizada",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Selecciona tus preferencias para obtener recomendaciones únicas de nuestro asistente turístico.",
              style: TextStyle(color: subtitleColor, height: 1.5),
            ),
            const SizedBox(height: 25),

            _buildDropdown(
              label: "Tipo de lugar",
              icon: Icons.place_outlined,
              items: categories,
              value: selectedCategory,
              onChanged: (v) => selectedCategory = v,
              isDark: isDark,
            ),
            const SizedBox(height: 18),

            _buildDropdown(
              label: "Presupuesto",
              icon: Icons.attach_money_rounded,
              items: budgets,
              value: selectedBudget,
              onChanged: (v) => selectedBudget = v,
              isDark: isDark,
            ),
            const SizedBox(height: 18),

            _buildDropdown(
              label: "Número de personas",
              icon: Icons.group_outlined,
              items: groupSizes,
              value: selectedGroupSize,
              onChanged: (v) => selectedGroupSize = v,
              isDark: isDark,
            ),
            const SizedBox(height: 18),

            _buildDropdown(
              label: "Horario preferido",
              icon: Icons.schedule_outlined,
              items: times,
              value: selectedTime,
              onChanged: (v) => selectedTime = v,
              isDark: isDark,
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
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsList(
      bool isDark, Color cardColor, Color subtitleColor, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: recommendations.map((place) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : const Color(0x11000000),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: place.imageUrl.isNotEmpty
                  ? Image.network(place.imageUrl,
                      width: 80, height: 80, fit: BoxFit.cover)
                  : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported_outlined),
                    ),
            ),
            title: Text(
              place.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  place.description,
                  style: TextStyle(color: subtitleColor, height: 1.4),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.place, color: primaryColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      place.category ?? "Sin categoría",
                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
    required bool isDark,
    String? value,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryColor),
        filled: true,
        fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
        labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      value: value,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (v) => setState(() => onChanged(v)),
      validator: (v) => v == null ? "Campo requerido" : null,
    );
  }
}

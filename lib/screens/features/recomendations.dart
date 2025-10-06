import 'package:flutter/material.dart';
import 'dart:math';

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
  final TextEditingController notesController = TextEditingController();

  String? recommendation;

  
  final Color primaryColor = const Color(0xFF0ba6da);

  final List<String> categories = [
    "Restaurantes",
    "Bares",
    "Discotecas",
    "Playas",
    "Sitios Históricos",
    "Islas",
    "Tours",
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        recommendation = _generateRecommendation();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Generando recomendación...')),
      );
    }
  }

  String _generateRecommendation() {
    final random = Random();

    final lugares = {
      "Restaurantes": [
        "🍤 *La Cevichería* — ideal para probar mariscos frescos en el corazón de Cartagena.",
        "🍽️ *El Muelle* — en Coveñas, con vista al mar y ambiente tranquilo.",
      ],
      "Bares": [
        "🍸 *Alquímico* — uno de los bares más famosos de Cartagena, con cocteles únicos.",
        "🍹 *El Mirador Gastro Bar* — vistas espectaculares al atardecer.",
      ],
      "Discotecas": [
        "🎶 *La Movida* — perfecta para bailar y disfrutar de buena música latina.",
        "💃 *Fragma Club* — ambiente moderno en la zona amurallada.",
      ],
      "Playas": [
        "🏖️ *Playa Blanca* — aguas cristalinas y ambiente relajado.",
        "🌊 *Primera Ensenada* — la joya de Coveñas, ideal para pasar el día.",
      ],
      "Sitios Históricos": [
        "🏰 *Castillo San Felipe de Barajas* — historia y vistas increíbles.",
        "🧱 *Ciudad Amurallada* — perfecta para recorrer a pie y tomar fotos.",
      ],
      "Islas": [
        "🏝️ *Islas del Rosario* — aguas turquesas y snorkel impresionante.",
        "🌅 *Isla Múcura* — una de las más hermosas del Caribe.",
      ],
      "Tours": [
        "🌋 *Tour por el Volcán del Totumo* — experiencia natural única.",
        "🚤 *Tour en lancha por las islas desde Coveñas.*",
      ],
    };

    final posibles = lugares[selectedCategory] ?? ["Explora libremente 😄"];
    return posibles[random.nextInt(posibles.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text(
          "Recomendaciones",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Cuéntanos algunos detalles...",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                    textAlign: TextAlign.center,
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
                    label: "Presupuesto aproximado",
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
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: notesController,
                    decoration: InputDecoration(
                      labelText: "Notas adicionales (opcional)",
                      hintText: "Ej: quiero un lugar tranquilo frente al mar",
                      prefixIcon: Icon(Icons.comment_outlined, color: primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 30),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: _submitForm,
                    icon: const Icon(Icons.search_rounded),
                    label: const Text(
                      "Obtener Recomendación",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  if (recommendation != null) ...[
                    const Divider(),
                    const SizedBox(height: 20),
                    const Text(
                      "✨ Te recomendamos:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        recommendation!,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      value: value,
      items: items.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? "Campo requerido" : null,
    );
  }
}

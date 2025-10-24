import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _selectedKey = 'cartagena';

  final Map<String, Map<String, dynamic>> _locations = {
    'cartagena': {
      'label': 'Cartagena de Indias',
      'subtitle': 'Historia y encanto colonial',
      'description':
          'Cartagena de Indias es una joya del Caribe colombiano, declarada Patrimonio de la Humanidad por la UNESCO. Fundada en 1533, su historia está marcada por la colonización española, los ataques piratas y el comercio marítimo. Hoy combina su pasado colonial con la vitalidad de una ciudad moderna.',
      'hero': 'https://mlqfmr3rpryd.i.optimole.com/cb:JBSP.a525/w:auto/h:auto/q:100/ig:avif/https://cartagena-tours.co/wp-content/uploads/2023/12/Torre-del-Reloj-en-Cartagena-de-Indias-Colombia.jpg',
      'images': [
        'https://images.adsttc.com/media/images/594c/2129/b22e/3898/a700/05f3/newsletter/4414990219_160731d7bf_b.jpg?1498161444',
        'https://mustique.co/wp-content/uploads/2025/09/san-felipe-from-air-scaled.jpg',
        'https://cloudfront-us-east-1.images.arcpublishing.com/elespectador/SYNVWAOGDBFRZN4WWR7W4QAHWU.jpg',
      ],
      'foods': [
        'Arepa de huevo',
        'Pescado frito con patacones',
        'Arroz con coco',
        'Posta cartagenera',
        'Limonada de coco',
      ],
    },
    'covenas': {
      'label': 'Coveñas, Sucre (Colombia)',
      'subtitle': 'Playas y tranquilidad costera',
      'description':
          'Coveñas es un destino costero en el departamento de Sucre famoso por sus playas de arena blanca, aguas cálidas y ambiente relajado. Ideal para quienes buscan sol, mar y actividades náuticas en un entorno más tranquilo que las grandes ciudades turísticas.',
      'hero': 'https://content.r9cdn.net/rimg/dimg/7b/90/91d28f06-city-52322-1694f3c3799.jpg?width=1366&height=768&xhint=1416&yhint=1122&crop=true',
      'images': [
        'https://mediaim.expedia.com/destination/9/8ba157280004047c38ab29ec0339946a.jpg',
        'https://condominiovistamar.com/wp-content/uploads/2025/07/tintipan-covenas.webp',
        'https://agenciadeviajesviva365.com/wp-content/uploads/2024/10/Diapositiva1-9.jpeg',
      ],
      'foods': [
        'Ceviche de camarón',
        'Pescado a la parrilla',
        'Arroz con coco',
      ],
    }
  };

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0ba6da);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
              )
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedKey,
              items: _locations.entries
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value['label'], style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _selectedKey = v ?? _selectedKey),
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0ba6da)),
              dropdownColor: theme.cardColor,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Title / subtitle
          const SizedBox(height: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Column(
              key: ValueKey(_selectedKey),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _locations[_selectedKey]!['subtitle'],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _locations[_selectedKey]!['description'],
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    height: 1.5,
                    color: subtitleColor,
                  ),
                ),
                const SizedBox(height: 20),

                // Hero image with fixed aspect ratio and fallbacks
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _networkImage(
                      _locations[_selectedKey]!['hero'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Small gallery + description card
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          _locations[_selectedKey]!['images'][0],
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _locations[_selectedKey]!['label'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _selectedKey == 'cartagena'
                                ? 'El corazón histórico de la ciudad, con murallas, balcones coloridos y calles empedradas.'
                                : 'Playas tranquilas, actividades náuticas y ambiente relajado.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              height: 1.4,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Text(
                  'Lugares y recomendaciones',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: _networkImage(
                                _locations[_selectedKey]!['images'][1],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              height: 100,
                              width: double.infinity,
                              child: _networkImage(
                                _locations[_selectedKey]!['images'][2],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 260,
                            width: double.infinity,
                            child: _networkImage(
                              // show a different image here to avoid duplication
                              _locations[_selectedKey]!['images'][1],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _selectedKey == 'cartagena'
                      ? 'Entre sus principales atractivos se encuentran el Castillo de San Felipe, el barrio Getsemaní, el Convento de la Popa y las Islas del Rosario.'
                      : 'Actividades recomendadas: caminatas por la costa, paseos en lancha, snorkel y disfrutar la gastronomía local.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    height: 1.5,
                    color: subtitleColor,
                  ),
                ),
                const SizedBox(height: 30),

                // Food section
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sabores típicos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Platos y bebidas representativos que puedes probar:',
                        style: TextStyle(fontFamily: 'Inter', color: textColor),
                      ),
                      const SizedBox(height: 10),
                      ...(_locations[_selectedKey]!['foods'] as List<String>)
                          .map((f) => _buildFoodItem(f))
                          .toList(),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          _selectedKey == 'cartagena'
                              ? 'https://k-listo.com/wp-content/uploads/2020/10/AREPA_HUEVO.jpg'
                              : _locations[_selectedKey]!['images'][0],
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                Text(
                  'Cultura y vida nocturna',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _selectedKey == 'cartagena'
                      ? 'La ciudad vibra con música caribeña, champeta y salsa. En la noche, las plazas y bares del centro cobran vida con ritmos, risas y la brisa del mar.'
                      : 'Coveñas ofrece noches relajadas junto al mar, con restaurantes y bares tranquilos donde disfrutar la puesta de sol.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    height: 1.5,
                    color: subtitleColor,
                  ),
                ),
                const SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: _networkImage(
                      _locations[_selectedKey]!['images'][0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: Color(0xFF0ba6da)),
          const SizedBox(width: 8),
          Text(name, style: const TextStyle(fontFamily: 'Inter', fontSize: 15)),
        ],
      ),
    );
  }

  /// Helper that loads a network image with a small loading indicator and
  /// a graceful error placeholder to avoid layout glitches for remote images.
  Widget _networkImage(String url, {BoxFit fit = BoxFit.cover}) {
    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: Colors.grey.shade200,
          child: const Center(
            child: SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stack) {
        return Container(
          color: Colors.grey.shade200,
          child: const Center(
            child: Icon(Icons.broken_image, color: Colors.grey, size: 36),
          ),
        );
      },
    );
  }
}

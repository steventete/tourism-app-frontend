import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
        title: const Text(
          "Conoce Cartagena de Indias",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            color: Color(0xFF0ba6da),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "Historia y encanto colonial",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Cartagena de Indias es una joya del Caribe colombiano, declarada Patrimonio de la Humanidad por la UNESCO. Fundada en 1533, su historia está marcada por la colonización española, los ataques piratas y el comercio marítimo. Hoy, combina su pasado colonial con la vitalidad de una ciudad moderna.",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              height: 1.5,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 20),

          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              "https://mlqfmr3rpryd.i.optimole.com/cb:JBSP.a525/w:auto/h:auto/q:100/ig:avif/https://cartagena-tours.co/wp-content/uploads/2023/12/Torre-del-Reloj-en-Cartagena-de-Indias-Colombia.jpg",
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    "https://images.adsttc.com/media/images/594c/2129/b22e/3898/a700/05f3/newsletter/4414990219_160731d7bf_b.jpg?1498161444",
                    height: 180,
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
                      "Ciudad Amurallada",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "El corazón histórico de la ciudad, con murallas, balcones coloridos y calles empedradas que narran siglos de historia.",
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
          const SizedBox(height: 30),

          Text(
            "Lugares imperdibles",
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
                      child: Image.network(
                        "https://mustique.co/wp-content/uploads/2025/09/san-felipe-from-air-scaled.jpg",
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://agendacolombia.com/wp-content/uploads/2023/05/restaurantes-getsemani.jpg",
                        height: 100,
                        fit: BoxFit.cover,
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
                  child: Image.network(
                    "https://cloudfront-us-east-1.images.arcpublishing.com/elespectador/SYNVWAOGDBFRZN4WWR7W4QAHWU.jpg",
                    height: 260,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Entre sus principales atractivos se encuentran el Castillo de San Felipe, el barrio Getsemaní, el Convento de la Popa y las Islas del Rosario.",
            style: TextStyle(
              fontFamily: 'Inter',
              height: 1.5,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 30),

          // Sección vertical con fondo de color
          Container(
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sabores típicos",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "La gastronomía cartagenera combina mar, tradición y sabor criollo. No puedes dejar de probar:",
                  style: TextStyle(fontFamily: 'Inter', color: textColor),
                ),
                const SizedBox(height: 10),
                _buildFoodItem("Arepa de huevo"),
                _buildFoodItem("Pescado frito con patacones"),
                _buildFoodItem("Arroz con coco"),
                _buildFoodItem("Posta cartagenera"),
                _buildFoodItem("Limonada de coco"),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    "https://k-listo.com/wp-content/uploads/2020/10/AREPA_HUEVO.jpg",
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
            "Cultura y vida nocturna",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "La ciudad vibra con música caribeña, champeta y salsa. En la noche, las plazas y bares del centro cobran vida con ritmos, risas y la brisa del mar.",
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
              child: Image.network(
                "https://elcomercio.pe/resizer/FP1-pUCmEFh1yjk8b7EFd6XtsUc=/2048x1365/smart/filters:format(jpeg):quality(75)/arc-anglerfish-arc2-prod-elcomercio.s3.amazonaws.com/public/TWGLGQUYVRDULCMNYRPWLXTTKY.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 40),
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
}

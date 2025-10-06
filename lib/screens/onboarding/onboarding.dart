import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      "title": "Descubre Destinos",
      "description":
          "Explora los mejores lugares turísticos de Colombia con información actualizada y recomendaciones únicas.",
      "image": "assets/images/onboarding1.webp",
      "color": const Color(0xFF0ba6da)
    },
    {
      "title": "Recibe Recomendaciones",
      "description":
          "Nuestra IA analiza tus gustos y te sugiere experiencias personalizadas.",
      "image": "assets/images/onboarding2.png",
      "color": const Color(0xFF1ac3b3)
    },
    {
      "title": "Tu Asistente Virtual",
      "description":
          "Chatea con nuestra IA para planear tu viaje ideal. Inicia sesión o regístrate para comenzar.",
      "image": "assets/images/onboarding3.png",
      "color": const Color(0xFFf6b93b)
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Container(
                color: page["color"], 
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(page["image"]!, fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        page["title"]!,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        page["description"]!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      if (index == _pages.length - 1) ...[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: const Text(
                            "Iniciar Sesión",
                            style: TextStyle(color: Color(0xFF0ba6da)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterScreen()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            side: const BorderSide(color: Colors.white),
                          ),
                          child: const Text(
                            "Registrarse",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
       
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
          
          if (_currentIndex < _pages.length - 1)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Icon(Icons.arrow_forward_ios,
                    color: Color(0xFF0ba6da)),
              ),
            ),
        ],
      ),
    );
  }
}

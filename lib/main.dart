import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourism_app/screens/onboarding/onboarding.dart';
import 'package:tourism_app/screens/features/locations.dart';
import 'package:tourism_app/screens/features/recomendations.dart';
import 'package:tourism_app/screens/features/chatbot.dart';
import 'package:tourism_app/screens/features/settings.dart';
import 'package:tourism_app/widgets/bottom_nav.dart';
import 'package:tourism_app/utils/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tourism App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0ba6da)),
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      // 👇 Punto inicial que decide si va a login o al main
      home: const SplashRouter(),

      // 👇 Aquí defines tus rutas nombradas
      routes: {
        '/login': (context) => const OnboardingScreen(), // pantalla de login/onboarding
        '/main': (context) => const MainScreen(),
        '/settings': (context) => const SettingsPage(),
        '/chatbot': (context) => const ChatBotPage(title: "Asistente Virtual"),
        '/locations': (context) => const LocationsPage(),
        '/recomendations': (context) => const RecomendationsPage(),
      },
    );
  }
}

class SplashRouter extends StatefulWidget {
  const SplashRouter({super.key});

  @override
  State<SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<SplashRouter> {
  bool _checking = true;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final accessToken = await StorageService.getAccessToken();
    setState(() {
      _loggedIn = accessToken != null;
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF0ba6da)),
        ),
      );
    }

    return _loggedIn ? const MainScreen() : const OnboardingScreen();
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page = 2;
  final PageController _pageController = PageController(initialPage: 2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _page = index),
        children: const [
          LocationsPage(),
          RecomendationsPage(),
          ChatBotPage(title: "Asistente Virtual"),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _page,
        onTap: (index) {
          setState(() => _page = index);
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourism_app/screens/onboarding/onboarding.dart';
import 'package:tourism_app/screens/features/home.dart';
import 'package:tourism_app/screens/features/recomendations.dart';
import 'package:tourism_app/screens/features/chatbot.dart';
import 'package:tourism_app/screens/features/settings.dart';
import 'package:tourism_app/widgets/bottom_nav.dart';
import 'package:tourism_app/utils/storage_service.dart';
import 'package:tourism_app/utils/theme_controller.dart';
import 'package:tourism_app/screens/features/settings/edit_profile.dart';
import 'package:tourism_app/screens/features/settings/privacy_security.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EntryPoint());
}

class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyApp();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeController _themeController = ThemeController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeController,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tourism App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0ba6da),
            ),
            fontFamily: GoogleFonts.inter().fontFamily,
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0ba6da),
              brightness: Brightness.dark,
            ),
          ),
          themeMode: _themeController.themeMode,
          home: SplashRouter(themeController: _themeController),

          routes: {
            '/login': (context) => const OnboardingScreen(),
            '/main': (context) => MainScreen(themeController: _themeController),
            '/settings': (context) =>
                SettingsPage(themeController: _themeController),
            '/chatbot': (context) =>
                ChatBotPage(title: "Asistente Virtual", themeController: _themeController),
            '/locations': (context) => const Home(),
            '/recomendations': (context) => RecomendationsPage(themeController: _themeController),
            '/editProfile': (context) => const EditProfilePage(),
            '/privacySecurity': (context) => const PrivacySecurityPage(),
          },
        );
      },
    );
  }
}

class SplashRouter extends StatefulWidget {
  final ThemeController themeController;
  const SplashRouter({super.key, required this.themeController});

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

    return _loggedIn
        ? MainScreen(themeController: widget.themeController)
        : const OnboardingScreen();
  }
}

class MainScreen extends StatefulWidget {
  final ThemeController themeController;
  const MainScreen({super.key, required this.themeController});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page = 2;
  final PageController _pageController = PageController(initialPage: 2);
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const Home(),
      RecomendationsPage(themeController: widget.themeController),
      ChatBotPage(title: "Asistente Virtual", themeController: widget.themeController),
      SettingsPage(themeController: widget.themeController),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _page = index),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _page,
        onTap: (index) {
          setState(() => _page = index);
          _pageController.jumpToPage(index);
        },
        themeController: widget.themeController,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/onboarding/onboarding.dart';
import 'screens/features/locations.dart';
import 'screens/features/recomendations.dart';
import 'screens/features/chatbot.dart';
import 'screens/features/profile.dart';
import 'screens/features/settings.dart';
import 'widgets/bottom_nav.dart';

void main() {
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
      home: const OnboardingScreen(),
    );
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
        children: [
          LocationsPage(),
          RecomendationsPage(),
          ChatBotPage(title: "Asistente Virtual"),
          ProfilePage(),
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

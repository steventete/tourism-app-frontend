import 'package:flutter/material.dart';
import '../../../widgets/bottom_nav.dart';
import 'locations.dart';
import 'recomendations.dart';
import 'chatbot.dart';
import 'settings.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2; 
  final PageController _pageController = PageController(initialPage: 2);

  final List<Widget> _pages = const [
    LocationsPage(),
    RecomendationsPage(),
    ChatBotPage(title: "Asistente Virtual"),
    SettingsPage(),
  ];

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

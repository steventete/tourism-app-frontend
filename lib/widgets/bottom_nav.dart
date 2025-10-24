import 'package:flutter/material.dart';
import 'package:tourism_app/utils/theme_controller.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final ThemeController themeController;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = themeController.isDarkMode;

    final Color backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final Color selectedColor = const Color(0xFF0ba6da);
    final Color unselectedColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        selectedItemColor: selectedColor,
        unselectedItemColor: unselectedColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 0
                  ? Icons.public_rounded
                  : Icons.public_outlined,
            ),
            label: 'Destinos',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 1
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
            ),
            label: 'Recomendados',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 2
                  ? Icons.smart_toy_rounded
                  : Icons.smart_toy_outlined,
            ),
            label: 'Asistente',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 3
                  ? Icons.settings_rounded
                  : Icons.settings_outlined,
            ),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}

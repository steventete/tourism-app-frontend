import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/storage_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Seguro que quieres cerrar sesión?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Salir"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await StorageService.clearTokens();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    }
  }

  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundImage: NetworkImage(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/250px-Default_pfp.svg.png',
                    ),
                    backgroundColor: Colors.grey,
                  ),
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Breiner Steven",
                style: TextStyle(
                  fontSize: 22,
                  color: Color(0xFF222222),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "breiner@tete.com",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 28),

              // Botones rápidos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _quickButton(context, Icons.lock_outline, "Seguridad"),
                  _quickButton(context, Icons.notifications_none, "Alertas"),
                  _quickButton(context, Icons.help_outline, "Ayuda"),
                ],
              ),

              const SizedBox(height: 35),

              // Ajustes generales
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x11000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _switchTile(
                      FontAwesomeIcons.bell,
                      "Notificaciones",
                      notificationsEnabled,
                      (val) => setState(() => notificationsEnabled = val),
                    ),
                    _divider(),
                    _switchTile(
                      FontAwesomeIcons.moon,
                      "Modo oscuro",
                      darkModeEnabled,
                      (val) => setState(() => darkModeEnabled = val),
                    ),
                    _divider(),
                    _optionTile(FontAwesomeIcons.userPen, "Editar perfil"),
                    _divider(),
                    _optionTile(
                      FontAwesomeIcons.shieldHalved,
                      "Privacidad y seguridad",
                    ),
                    _divider(),
                    _optionTile(
                      FontAwesomeIcons.circleQuestion,
                      "Centro de ayuda",
                    ),
                    _divider(),
                    _optionTile(
                      FontAwesomeIcons.arrowRightFromBracket,
                      "Cerrar sesión",
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "App desarrollada para Cartagena y Coveñas",
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
              const SizedBox(height: 10),
              Text(
                "v1.0.0",
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickButton(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {},
      child: Container(
        width: 95,
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchTile(
    IconData icon,
    String text,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      secondary: Icon(icon, color: const Color(0xFF444444), size: 20),
      title: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF222222),
          fontSize: 15.5,
          fontWeight: FontWeight.w500,
        ),
      ),
      value: value,
      activeColor: Theme.of(context).colorScheme.primary,
      onChanged: onChanged,
    );
  }

  Widget _optionTile(IconData icon, String text, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color(0xFF444444), size: 20),
      title: Text(
        text,
        style: TextStyle(
          color: color ?? const Color(0xFF222222),
          fontSize: 15.5,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFFBBBBBB)),
      onTap: () {
        if (text == "Cerrar sesión") {
          _logout();
        } else {
          // Aquí puedes manejar otras opciones
        }
      },
    );
  }

  Widget _divider() => const Divider(height: 1, color: Color(0xFFEAEAEA));
}

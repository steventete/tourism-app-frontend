import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
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
                      icon: const Icon(Icons.edit, color: Colors.white, size: 18),
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
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 28),

          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _quickButton(context, Icons.settings_outlined, "Ajustes"),
                  _quickButton(context, Icons.lock_outline, "Seguridad"),
                  _quickButton(context, Icons.help_outline, "Ayuda"),
                ],
              ),

              const SizedBox(height: 35),

             
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
                    _optionTile(FontAwesomeIcons.userPen, "Editar perfil"),
                    _divider(),
                    _optionTile(FontAwesomeIcons.bell, "Notificaciones"),
                    _divider(),
                    _optionTile(FontAwesomeIcons.shieldHalved, "Privacidad y seguridad"),
                    _divider(),
                    _optionTile(FontAwesomeIcons.circleQuestion, "Centro de ayuda"),
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
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "v1.0.0",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
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
      onTap: () {},
    );
  }

  Widget _divider() => const Divider(height: 1, color: Color(0xFFEAEAEA));
}

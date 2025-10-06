import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  double textScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Configuración",
          style: TextStyle(fontWeight: FontWeight.w600,color: Color(0xFF0ba6da),),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "General",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 12),
          _buildSwitchTile(
            icon: FontAwesomeIcons.bell,
            title: "Notificaciones",
            subtitle: "Recibe alertas y avisos importantes",
            value: notificationsEnabled,
            onChanged: (val) => setState(() => notificationsEnabled = val),
          ),
          _buildDivider(),
          _buildSwitchTile(
            icon: FontAwesomeIcons.moon,
            title: "Modo oscuro",
            subtitle: "Activa el tema oscuro del sistema",
            value: darkModeEnabled,
            onChanged: (val) => setState(() => darkModeEnabled = val),
          ),
          _buildDivider(),
          _buildSliderTile(
            icon: FontAwesomeIcons.textHeight,
            title: "Tamaño de texto",
            subtitle: "Ajusta el tamaño del texto en la app",
            value: textScale,
            onChanged: (val) => setState(() => textScale = val),
          ),

          const SizedBox(height: 30),
          const Text(
            "Cuenta",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 12),
          _buildListTile(
            icon: FontAwesomeIcons.userPen,
            title: "Editar perfil",
            onTap: () {},
          ),
          _buildDivider(),
          _buildListTile(
            icon: FontAwesomeIcons.lock,
            title: "Cambiar contraseña",
            onTap: () {},
          ),
          _buildDivider(),
          _buildListTile(
            icon: FontAwesomeIcons.shieldHalved,
            title: "Privacidad",
            onTap: () {},
          ),

          const SizedBox(height: 30),
          const Text(
            "Soporte",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 12),
          _buildListTile(
            icon: FontAwesomeIcons.circleQuestion,
            title: "Centro de ayuda",
            onTap: () {},
          ),
          _buildDivider(),
          _buildListTile(
            icon: FontAwesomeIcons.commentDots,
            title: "Enviar comentarios",
            onTap: () {},
          ),
          _buildDivider(),
          _buildListTile(
            icon: FontAwesomeIcons.arrowRightFromBracket,
            title: "Cerrar sesión",
            iconColor: Colors.redAccent,
            textColor: Colors.redAccent,
            onTap: () {},
          ),
        ],
      ),
    );
  }

 

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF444444)),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
      ),
      trailing: Switch(
        value: value,
        activeColor: Theme.of(context).colorScheme.primary,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSliderTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required double value,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(icon, color: const Color(0xFF444444)),
          title: Text(title, style: const TextStyle(fontSize: 15)),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ),
        Slider(
          value: value,
          min: 0.8,
          max: 1.5,
          divisions: 7,
          label: "${(value * 100).toInt()}%",
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? const Color(0xFF444444)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: textColor ?? const Color(0xFF222222),
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF999999)),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 0.5, color: Color(0xFFE0E0E0));
  }
}

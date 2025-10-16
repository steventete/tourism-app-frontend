import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/storage_service.dart';
import '../../services/user_service.dart';
import '../../utils/api_routes.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  /// 🔹 Cargar información del usuario desde el almacenamiento y la API
  Future<void> _loadUserProfile() async {
    try {
      final identifier = await StorageService.getUserIdentifier();
      print("🧠 IDENTIFIER CARGADO: $identifier");
      print("📡 Haciendo request a: ${ApiRoutes.baseUrl}/users/$identifier");

      // Si no hay identificador → mostrar usuario genérico
      if (identifier == null) {
        print("⚠️ No se encontró identificador, mostrando usuario genérico...");
        _setDefaultUser();
        return;
      }

      // Obtener datos reales desde la API
      final data = await UserService.getProfile(identifier);

      if (mounted) {
        setState(() {
          _userData = {
            'displayname': data?['username'] ?? 'Usuario',
            'email': data?['email'] ?? 'sin correo electronico',
            'avatarUrl':
                data?['picture'] ??
                'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/250px-Default_pfp.svg.png',
            'firstname': data?['client']?['firstName'] ?? '',
            'lastname': data?['client']?['lastName'] ?? '',
          };
          _isLoading = false;
        });
      }
    } catch (e) {
      print("❌ Error al cargar perfil: $e");
      _setDefaultUser();
    }
  }

  /// 🔸 Configura usuario genérico por defecto
  void _setDefaultUser() {
    if (mounted) {
      setState(() {
        _userData = {
          'displayname': 'Usuario',
          'email': 'jhon.mendez@cecar.edu.co',
          'avatarUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/250px-Default_pfp.svg.png',
        };
        _isLoading = false;
      });
    }
  }

  /// 🔹 Cerrar sesión
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

  /// 📸 Cambiar foto de perfil
  Future<void> _changeProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return; // Usuario canceló

    final file = File(pickedFile.path);
    final identifier = await StorageService.getUserIdentifier();

    if (identifier == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No se encontró el identificador del usuario."),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Subiendo imagen...")));

    final success = await UserService.updateProfilePicture(
      identifier,
      file.path,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Imagen actualizada con éxito")),
      );
      _loadUserProfile(); // 🔄 Recargar avatar en pantalla
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ No se pudo actualizar la imagen")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // 🔹 Carga del perfil al iniciar
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),

                    // 🧑‍💻 Avatar + botón editar
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundImage: NetworkImage(
                            _userData?['avatarUrl'] ??
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/250px-Default_pfp.svg.png',
                          ),
                          backgroundColor: Colors.grey[200],
                        ),
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.4,
                                ),
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
                            onPressed: _changeProfilePicture,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    //  Nombre y correo
                    Text(
                      _userData?['displayname'] ?? 'Usuario',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Color(0xFF222222),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // 👤 Nombre real del cliente (si existe)
                    if ((_userData?['firstname'] ?? '').isNotEmpty)
                      Text(
                        "${_userData?['firstname']} ${_userData?['lastname']}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF444444),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      _userData?['email'] ?? 'correo@ejemplo.com',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),

                    const SizedBox(height: 28),

                    // 🔹 Accesos rápidos (placeholders para futuras integraciones)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _quickButton(context, Icons.lock_outline, "Seguridad"),
                        _quickButton(
                          context,
                          Icons.notifications_none,
                          "Alertas",
                        ),
                        _quickButton(context, Icons.help_outline, "Ayuda"),
                      ],
                    ),

                    const SizedBox(height: 35),

                    // ⚙️ Ajustes generales
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
                          _optionTile(
                            FontAwesomeIcons.userPen,
                            "Editar perfil",
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/editProfile',
                                arguments: _userData,
                              ).then((value) => _loadUserProfile());
                            },
                          ),
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
                            onTap: _logout,
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

  // 🔸 Botones rápidos (placeholders para futuras funciones)
  Widget _quickButton(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        print("🔸 [$label] función aún no implementada");
      },
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

  // 🔸 Switch de configuración
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

  // 🔸 Opciones de menú
  Widget _optionTile(
    IconData icon,
    String text, {
    Color? color,
    VoidCallback? onTap,
  }) {
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
      onTap: onTap,
    );
  }

  Widget _divider() => const Divider(height: 1, color: Color(0xFFEAEAEA));
}

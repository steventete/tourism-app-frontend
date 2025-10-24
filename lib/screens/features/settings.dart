import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/storage_service.dart';
import '../../services/user_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../utils/theme_controller.dart';

class SettingsPage extends StatefulWidget {
  final ThemeController themeController;

  const SettingsPage({super.key, required this.themeController});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  bool _hasLoadedOnce = false;

  @override
  bool get wantKeepAlive => true;

  Future<void> _loadUserProfile() async {
    if (_hasLoadedOnce) return;
    _hasLoadedOnce = true;

    try {
      final identifier = await StorageService.getUserIdentifier();
      if (identifier == null) {
        _setDefaultUser();
        return;
      }

      final data = await UserService.getProfile(identifier);
      if (mounted) {
        setState(() {
          _userData = {
            'displayname': data?['username'] ?? 'Usuario',
            'email': data?['email'] ?? 'sin correo electrónico',
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
      _setDefaultUser();
    }
  }

  void _setDefaultUser() {
    if (mounted) {
      setState(() {
        _userData = {
          'displayname': 'Usuario',
          'email': 'usuario@ejemplo.com',
          'avatarUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/250px-Default_pfp.svg.png',
        };
        _isLoading = false;
      });
    }
  }

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

  Future<void> _changeProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final identifier = await StorageService.getUserIdentifier();
    if (identifier == null) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Subiendo imagen...")));

    final success = await UserService.updateProfilePicture(
      identifier,
      file.path,
    );

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Imagen actualizada")));
      _loadUserProfile();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error al actualizar")));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 👈 Necesario por AutomaticKeepAliveClientMixin

    final isDarkMode = widget.themeController.isDarkMode;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundImage: NetworkImage(
                            _userData?['avatarUrl'] ?? '',
                          ),
                          backgroundColor: colorScheme.surfaceContainerHighest,
                        ),
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
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
                    Text(
                      _userData?['displayname'] ?? 'Usuario',
                      style: TextStyle(
                        fontSize: 22,
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if ((_userData?['firstname'] ?? '').isNotEmpty)
                      Text(
                        "${_userData?['firstname']} ${_userData?['lastname']}",
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      _userData?['email'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 35),
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _switchTile(
                            FontAwesomeIcons.bell,
                            "Notificaciones",
                            notificationsEnabled,
                            (val) {
                              setState(() => notificationsEnabled = val);
                            },
                          ),
                          _divider(colorScheme),
                          _switchTile(
                            FontAwesomeIcons.moon,
                            "Modo oscuro",
                            isDarkMode,
                            (val) {
                              widget.themeController.toggleTheme();
                              setState(() => darkModeEnabled = val);
                            },
                          ),
                          _divider(colorScheme),
                          _optionTile(
                            FontAwesomeIcons.userPen,
                            "Editar perfil",
                            colorScheme,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/editProfile',
                                arguments: _userData,
                              ).then((_) => _loadUserProfile());
                            },
                          ),
                          _divider(colorScheme),
                          _optionTile(
                            FontAwesomeIcons.shieldHalved,
                            "Privacidad y seguridad",
                            colorScheme,
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/privacySecurity',
                            ),
                          ),
                          _divider(colorScheme),
                          _optionTile(
                            FontAwesomeIcons.arrowRightFromBracket,
                            "Cerrar sesión",
                            colorScheme,
                            color: Colors.redAccent,
                            onTap: _logout,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Kuagro Explorer",
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "v1.0.0",
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
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
    final colorScheme = Theme.of(context).colorScheme;
    return SwitchListTile(
      secondary: Icon(icon, color: colorScheme.onSurfaceVariant, size: 20),
      title: Text(
        text,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 15.5,
          fontWeight: FontWeight.w500,
        ),
      ),
      value: value,
      activeThumbColor: colorScheme.primary,
      onChanged: onChanged,
    );
  }

  Widget _optionTile(
    IconData icon,
    String text,
    ColorScheme colorScheme, {
    Color? color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? colorScheme.onSurfaceVariant,
        size: 20,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: color ?? colorScheme.onSurface,
          fontSize: 15.5,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: colorScheme.outline),
      onTap: onTap,
    );
  }

  Widget _divider(ColorScheme colorScheme) =>
      Divider(height: 1, color: colorScheme.outlineVariant);
}

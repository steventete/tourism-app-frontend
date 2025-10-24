import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tourism_app/models/user_profile.dart';
import 'package:tourism_app/services/auth_service.dart';
import 'package:tourism_app/utils/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourism_app/utils/theme_controller.dart';

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

  UserProfile? _userProfile;
  bool _isLoading = true;
  bool _hasLoadedOnce = false;

  @override
  bool get wantKeepAlive => true;

  Future<void> _loadUserProfile() async {
    if (_hasLoadedOnce) return;
    _hasLoadedOnce = true;

    try {
      final profile = await AuthService.getUserProfile();
      
      if (profile == null) {
        // Si no hay perfil guardado, intentar obtenerlo del servidor
        final fetchedProfile = await AuthService.fetchAndSaveUserProfile();
        if (mounted) {
          setState(() {
            _userProfile = fetchedProfile;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _userProfile = profile;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error al cargar perfil: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshUserProfile() async {
    setState(() => _isLoading = true);
    
    try {
      final profile = await AuthService.refreshUserProfile();
      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error al refrescar perfil: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    
    if (pickedFile == null) return;

    // Mostrar loading
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Subiendo imagen...")),
      );
    }

    final success = await AuthService.updateProfilePicture(pickedFile.path);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Imagen actualizada exitosamente")),
        );
        // Refrescar el perfil para mostrar la nueva imagen
        await _refreshUserProfile();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al actualizar la imagen")),
        );
      }
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
            : RefreshIndicator(
                onRefresh: _refreshUserProfile,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                            backgroundImage: _userProfile?.picture != null
                                ? NetworkImage(_userProfile!.picture!)
                                : null,
                            backgroundColor: colorScheme.surfaceContainerHighest,
                            child: _userProfile?.picture == null
                                ? Text(
                                    _userProfile?.client.firstName
                                            .substring(0, 1)
                                            .toUpperCase() ??
                                        'U',
                                    style: TextStyle(
                                      fontSize: 32,
                                      color: colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
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
                        _userProfile?.displayName ?? 'Usuario',
                        style: TextStyle(
                          fontSize: 22,
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userProfile?.fullName ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userProfile?.email ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (_userProfile?.isVerified == true) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.verified,
                                color: Colors.green,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Verificado',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                      // Información adicional del usuario (si es admin)
                      if (_userProfile?.isAdmin == true)

                      const SizedBox(height: 20),
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
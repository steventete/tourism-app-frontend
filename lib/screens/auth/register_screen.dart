import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tourism_app/utils/api_routes.dart';

const Color primaryColor = Color(0xFF0ba6da);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _documentController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();

  bool _isLoading = false;
  String? _selectedDocTypeId;
  String? _selectedGender;

  final List<Map<String, String>> _documentTypes = [
    {"id": "54bbc972-c83f-4372-a2b8-36be122ba17b", "name": "Cédula de Ciudadanía"},
    {"id": "703dc169-4b2e-42ca-b6cd-a09463aa431f", "name": "Tarjeta de Identidad"},
    {"id": "ad7a7d6a-429d-4f03-8715-1c9d444a703b", "name": "Registro Civil de Nacimiento"},
    {"id": "904d0241-f27f-452c-be2f-129bb90a11ea", "name": "Cédula de Extranjería"},
    {"id": "42735a41-aef0-40cd-8c72-94fbadbee70a", "name": "Permiso Especial de Permanencia"},
    {"id": "4bf3d416-e55b-4c0b-9a48-b4ea298bd09f", "name": "Pasaporte"},
  ];

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final url = Uri.parse(ApiRoutes.register);
    final body = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text.trim(),
      "username": _usernameController.text.trim(),
      "displayName": _displayNameController.text.trim(),
      "documentTypeId": _selectedDocTypeId,
      "document": _documentController.text.trim(),
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "phone": _phoneController.text.trim(),
      "gender": _selectedGender,
      "birthDate": _birthDateController.text.trim(),
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      setState(() => _isLoading = false);

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registro exitoso. Revisa tu email para verificar tu cuenta."), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        final error = jsonDecode(response.body);
        debugPrint("❌ Error: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${error['message'] ?? 'Error desconocido'}"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error de conexión: $e"), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final divider = Divider(color: Colors.grey.shade300, height: 32);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Crear cuenta", style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _sectionCard(
                  title: "Cuenta",
                  icon: FontAwesomeIcons.circleUser,
                  children: [
                    _inputField(
                      controller: _emailController,
                      label: "Correo electrónico *",
                      icon: Icons.alternate_email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                    ),
                    _inputField(
                      controller: _passwordController,
                      label: "Contraseña *",
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (v) => v!.length < 6 ? 'Mínimo 6 caracteres' : null,
                    ),
                    _inputField(controller: _usernameController, label: "Usuario", icon: Icons.person_outline),
                    _inputField(controller: _displayNameController, label: "Nombre visible", icon: Icons.badge_outlined),
                  ],
                ),
                divider,
                _sectionCard(
                  title: "Identificación",
                  icon: FontAwesomeIcons.idCardClip,
                  children: [
                    DropdownMenu<String>(
                      width: MediaQuery.of(context).size.width - 70,
                      initialSelection: _selectedDocTypeId,
                      label: const Text("Tipo de documento *"),
                      onSelected: (v) => setState(() => _selectedDocTypeId = v),
                      dropdownMenuEntries: _documentTypes
                          .map((doc) => DropdownMenuEntry(value: doc["id"]!, label: doc["name"]!))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    _inputField(
                      controller: _documentController,
                      label: "Número de documento *",
                      icon: Icons.numbers_outlined,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                    ),
                  ],
                ),
                divider,
                _sectionCard(
                  title: "Información personal",
                  icon: FontAwesomeIcons.addressCard,
                  children: [
                    _inputField(
                      controller: _firstNameController,
                      label: "Nombres *",
                      icon: Icons.person_outline,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                    ),
                    _inputField(
                      controller: _lastNameController,
                      label: "Apellidos *",
                      icon: Icons.people_outline,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                    ),
                    _inputField(
                      controller: _phoneController,
                      label: "Teléfono *",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                    ),
                    DropdownMenu<String>(
                      width: MediaQuery.of(context).size.width - 70,
                      initialSelection: _selectedGender,
                      label: const Text("Género *"),
                      onSelected: (v) => setState(() => _selectedGender = v),
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(value: "male", label: "Masculino"),
                        DropdownMenuEntry(value: "female", label: "Femenino"),
                        DropdownMenuEntry(value: "other", label: "Otro"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _inputField(
                      controller: _birthDateController,
                      label: "Fecha de nacimiento *",
                      icon: Icons.calendar_today_outlined,
                      readOnly: true,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          _birthDateController.text =
                              "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                        }
                      },
                      validator: (v) => v!.isEmpty ? 'Seleccione una fecha' : null,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _register,
                  icon: _isLoading
                      ? const SizedBox(
                          height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.check_circle_outline, color: Colors.white),
                  label: const Text(
                    "Crear cuenta",
                    style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    minimumSize: Size(MediaQuery.of(context).size.width, 50),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool obscureText = false,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: primaryColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

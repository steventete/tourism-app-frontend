import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    {"id": "1", "name": "Cédula de Ciudadanía"},
    {"id": "2", "name": "Tarjeta de Identidad"},
    {"id": "3", "name": "Pasaporte"},
    {"id": "4", "name": "Cédula de Extranjería"},
  ];

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2)); 

    setState(() => _isLoading = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Registro exitoso")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final divider = Divider(color: Colors.grey.shade300, height: 32);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Crear cuenta",
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600),
        ),
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
                  icon: FontAwesomeIcons.userPlus,
                  children: [
                    _inputField(
                      controller: _emailController,
                      label: "Correo electrónico *",
                      icon: Icons.email_outlined,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                    ),
                    _inputField(
                      controller: _passwordController,
                      label: "Contraseña *",
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (v) =>
                          v!.length < 6 ? 'Mínimo 6 caracteres' : null,
                    ),
                    _inputField(
                      controller: _usernameController,
                      label: "Nombre de usuario",
                      icon: Icons.alternate_email,
                    ),
                    _inputField(
                      controller: _displayNameController,
                      label: "Nombre visible",
                      icon: Icons.person_outline,
                    ),
                  ],
                ),
                divider,
                _sectionCard(
                  title: "Identificación",
                  icon: FontAwesomeIcons.idCard,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _selectedDocTypeId,
                      decoration: const InputDecoration(
                        labelText: "Tipo de documento *",
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                      ),
                      items: _documentTypes
                          .map(
                            (doc) => DropdownMenuItem(
                              value: doc["id"],
                              child: Text(doc["name"]!),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedDocTypeId = v),
                      validator: (v) =>
                          v == null ? 'Seleccione un tipo de documento' : null,
                    ),
                    const SizedBox(height: 16),
                    _inputField(
                      controller: _documentController,
                      label: "Número de documento *",
                      icon: Icons.confirmation_number_outlined,
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
                    DropdownButtonFormField<String>(
                      initialValue: _selectedGender,
                      decoration: const InputDecoration(
                        labelText: "Género *",
                        prefixIcon: Icon(Icons.wc_outlined),
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Masculino",
                          child: Text("Masculino"),
                        ),
                        DropdownMenuItem(
                          value: "Femenino",
                          child: Text("Femenino"),
                        ),
                        DropdownMenuItem(value: "Otro", child: Text("Otro")),
                      ],
                      onChanged: (v) => setState(() => _selectedGender = v),
                      validator: (v) =>
                          v == null ? 'Seleccione un género' : null,
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
                      validator: (v) =>
                          v!.isEmpty ? 'Seleccione una fecha' : null,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _register,
                  icon: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: const Text(
                    "Crear cuenta",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
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

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueAccent, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
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
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

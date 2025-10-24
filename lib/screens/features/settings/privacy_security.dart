import 'package:flutter/material.dart';

class PrivacySecurityPage extends StatelessWidget {
  const PrivacySecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacidad y seguridad")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text(
            "Política de Privacidad",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
              "En Kuagro Explorer protegemos tus datos personales conforme a la ley. "
              "No compartimos tu información con terceros sin tu consentimiento."),
          SizedBox(height: 25),
          Text(
            "Política de Seguridad",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
              "Tus datos son encriptados y almacenados en servidores seguros. "
              "Recomendamos usar contraseñas fuertes y mantener actualizada tu cuenta."),
        ],
      ),
    );
  }
}

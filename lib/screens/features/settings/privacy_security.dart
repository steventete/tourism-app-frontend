import 'package:flutter/material.dart';

class PrivacySecurityPage extends StatelessWidget {
  const PrivacySecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacidad y Seguridad"),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader(
            icon: Icons.privacy_tip_outlined,
            title: "Política de Privacidad",
            color: Colors.blue,
          ),
          const SizedBox(height: 15),
          _buildInfoCard(
            title: "Recopilación de Datos",
            content:
                "En Kuagro Explorer recopilamos únicamente la información necesaria para brindarte "
                "nuestros servicios. Esto incluye datos de registro, información de perfil y datos "
                "relacionados con el uso de la aplicación.",
            icon: Icons.data_usage,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            title: "Uso de la Información",
            content:
                "Utilizamos tus datos para personalizar tu experiencia, mejorar nuestros servicios, "
                "enviarte notificaciones relevantes y mantener la seguridad de tu cuenta. "
                "Nunca vendemos tu información personal a terceros.",
            icon: Icons.info_outline,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            title: "Compartir Información",
            content:
                "No compartimos tu información con terceros sin tu consentimiento explícito, excepto "
                "cuando sea requerido por ley o para proteger nuestros derechos legales. "
                "Trabajamos únicamente con proveedores de servicios confiables que cumplen con "
                "estrictos estándares de privacidad.",
            icon: Icons.share_outlined,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            title: "Tus Derechos",
            content:
                "Tienes derecho a acceder, corregir, eliminar o exportar tus datos personales en "
                "cualquier momento. También puedes solicitar la limitación del procesamiento de tus "
                "datos o retirar tu consentimiento cuando aplique.",
            icon: Icons.gavel,
          ),
          const SizedBox(height: 30),
          _buildSectionHeader(
            icon: Icons.security,
            title: "Política de Seguridad",
            color: Colors.green,
          ),
          const SizedBox(height: 15),
          _buildInfoCard(
            title: "Encriptación de Datos",
            content:
                "Todos tus datos son encriptados utilizando protocolos de seguridad estándar de la "
                "industria (SSL/TLS) tanto en tránsito como en reposo. Esto garantiza que tu "
                "información permanezca protegida en todo momento.",
            icon: Icons.lock_outline,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            title: "Almacenamiento Seguro",
            content:
                "Tu información se almacena en servidores seguros con múltiples capas de protección, "
                "incluyendo firewalls, sistemas de detección de intrusos y copias de seguridad "
                "regulares para prevenir pérdida de datos.",
            icon: Icons.cloud_done_outlined,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            title: "Autenticación",
            content:
                "Implementamos medidas robustas de autenticación para proteger tu cuenta. "
                "Recomendamos usar contraseñas fuertes con al menos 8 caracteres, incluyendo "
                "mayúsculas, minúsculas, números y símbolos.",
            icon: Icons.fingerprint,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            title: "Actualizaciones de Seguridad",
            content:
                "Mantén tu aplicación siempre actualizada para beneficiarte de las últimas mejoras "
                "de seguridad. Revisa regularmente la configuración de tu cuenta y reporta cualquier "
                "actividad sospechosa inmediatamente.",
            icon: Icons.system_update_alt,
          ),
          const SizedBox(height: 30),
          _buildSectionHeader(
            icon: Icons.tips_and_updates_outlined,
            title: "Recomendaciones de Seguridad",
            color: Colors.orange,
          ),
          const SizedBox(height: 15),
          _buildRecommendationTile("No compartas tu contraseña con nadie"),
          _buildRecommendationTile("Cierra sesión en dispositivos compartidos"),
          _buildRecommendationTile(
              "Verifica los permisos de la aplicación regularmente"),
          _buildRecommendationTile(
              "Desconfía de correos o mensajes sospechosos"),
          _buildRecommendationTile(
              "Activa notificaciones de actividad en tu cuenta"),
          const SizedBox(height: 30),
          _buildContactSection(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.grey[700], size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationTile(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.contact_support, color: Colors.blue),
              SizedBox(width: 10),
              Text(
                "¿Preguntas o Inquietudes?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Si tienes alguna pregunta sobre nuestras políticas de privacidad "
            "o seguridad, o si deseas ejercer tus derechos, contáctanos a través de:\n\n"
            "📧 privacidad@kuagroexplorer.com\n"
            "📞 +57 (1) 234-5678\n\n"
            "Última actualización: Octubre 2025",
            style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.5),
          ),
        ],
      ),
    );
  }
}
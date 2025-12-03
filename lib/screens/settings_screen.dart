import 'package:caropshibrida/l10n/app_localizations.dart';
import 'package:caropshibrida/provider/language_provider.dart';
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _isLoading = false;
    });
  }

  Future<void> _checkNotificationPermission() async {
    var status = await Permission.notification.status;

    if (!mounted) return;

    if (status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permiso de notificaciones ya concedido")),
      );
    } else if (status.isDenied) {
      if (await Permission.notification.request().isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Permiso de notificaciones concedido"),
            ),
          );
        }
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (!mounted) return;

    if (status.isGranted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Permiso ya concedido")));
    } else if (status.isDenied) {
      if (await Permission.camera.request().isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Permiso concedido")));
        }
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final l10n = AppLocalizations.of(context)!;
    final languageProvider = context.watch<LanguageProvider>();
    final currentCode = languageProvider.currentLocale.languageCode;

    // Detectamos si es Android Nativo
    final isAndroidMobile =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

    // Helper para nombre del idioma actual
    String getCurrentLanguageName() {
      switch (currentCode) {
        case 'es':
          return l10n.language_es;
        case 'en':
          return l10n.language_en;
        case 'pt':
          return l10n.language_pt;
        default:
          return currentCode;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tooltip_settings), // "Ajustes"
      ),
      body: ListView(
        children: [
          // --- SECCIÓN GENERAL (IDIOMA) ---
          _buildSectionHeader(l10n.settings_general_section), // "General"

          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language_label), // "Idioma"
            subtitle: Text(getCurrentLanguageName()), // "Español"
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showLanguageSelector(context),
          ),

          const Divider(),

          if (!kIsWeb) ...[
            _buildSectionHeader(l10n.settings_notifications_section),

            ListTile(
              leading: const Icon(Icons.notifications_active),
              title: Text(l10n.settings_receive_notifications),
              trailing: const Icon(Icons.notifications_active, size: 20),
              onTap: _checkNotificationPermission,
            ),

            const Divider(),
          ],

          // --- SECCIÓN PERMISOS (SOLO ANDROID) ---
          if (isAndroidMobile) ...[
            _buildSectionHeader(
              l10n.settings_permissions_section,
            ), // "Permisos y Sistema"

            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l10n.settings_camera_permission), // "Acceso a Cámara"
              trailing: const Icon(Icons.settings, size: 20),
              onTap: _checkCameraPermission,
            ),

            ListTile(
              leading: const Icon(Icons.settings_applications),
              title: Text(
                l10n.settings_system_settings,
              ), // "Abrir configuración..."
              trailing: const Icon(Icons.open_in_new, size: 20),
              onTap: () => openAppSettings(),
            ),
            const Divider(),
          ],

          // --- SECCIÓN INFO ---
          _buildSectionHeader(l10n.settings_info_section), // "Información"

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.settings_version), // "Versión"
            subtitle: const Text("1.0.0"),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para los títulos de sección
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // Modal para cambiar idioma
  void _showLanguageSelector(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.select_language,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),

              _buildLanguageOption(ctx, "🇪🇸", l10n.language_es, 'es'),
              _buildLanguageOption(ctx, "🇺🇸", l10n.language_en, 'en'),
              _buildLanguageOption(ctx, "🇧🇷", l10n.language_pt, 'pt'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext ctx,
    String flag,
    String name,
    String code,
  ) {
    // Detectamos si es el seleccionado para ponerle un check
    final isSelected =
        context.read<LanguageProvider>().currentLocale.languageCode == code;

    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(name),
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).primaryColor)
          : null,
      onTap: () {
        context.read<LanguageProvider>().changeLanguage(code);
        Navigator.pop(ctx);
      },
    );
  }
}

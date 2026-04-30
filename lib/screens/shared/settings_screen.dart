import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _locationServices = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
            child: Row(children: [
              KuyogBackButton(onTap: () => Navigator.pop(context)),
              const SizedBox(width: 12),
              Text('Settings', style: AppTheme.headline(size: 20)),
            ]),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                _sectionHeader('Preferences'),
                _switchTile('Push Notifications', 'Receive alerts for bookings and chats', _pushNotifications, (v) => setState(() => _pushNotifications = v)),
                _switchTile('Email Notifications', 'Receive marketing and recap emails', _emailNotifications, (v) => setState(() => _emailNotifications = v)),
                _switchTile('Location Services', 'Needed for Mindanao Crawl stamps', _locationServices, (v) => setState(() => _locationServices = v)),
                _switchTile('Dark Mode', 'Toggle dark theme (coming soon)', _darkMode, (v) => setState(() => _darkMode = v)),
                const SizedBox(height: 24),
                _sectionHeader('Account & Privacy'),
                _linkTile('Privacy Policy'),
                _linkTile('Terms of Service'),
                _linkTile('Delete Account', isDestructive: true),
                const SizedBox(height: 40),
                Center(child: Text('Kuyog App v1.0.0 (Build 42)', style: AppTheme.body(size: 12, color: AppColors.textLight))),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: AppTheme.headline(size: 16)),
    );
  }

  Widget _switchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: SwitchListTile(
        title: Text(title, style: AppTheme.label(size: 14)),
        subtitle: Text(subtitle, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _linkTile(String title, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(children: [
        Text(title, style: AppTheme.body(size: 14, color: isDestructive ? AppColors.error : AppColors.textPrimary)),
        const Spacer(),
        Icon(Icons.chevron_right, size: 18, color: isDestructive ? AppColors.error : AppColors.textLight),
      ]),
    );
  }
}

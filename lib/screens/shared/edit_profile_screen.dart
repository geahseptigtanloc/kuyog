import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl = TextEditingController(text: 'Current User');
  final _bioCtrl = TextEditingController(text: 'Exploring the beauty of Mindanao!');
  final _phoneCtrl = TextEditingController(text: '+63 912 345 6789');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

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
              Text('Edit Profile', style: AppTheme.headline(size: 20)),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated'), backgroundColor: AppColors.success));
                },
                child: Text('Save', style: AppTheme.label(size: 16, color: AppColors.primary)),
              ),
            ]),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage('https://picsum.photos/seed/user/200/200'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _field('Full Name', _nameCtrl),
                const SizedBox(height: 16),
                _field('Bio', _bioCtrl, maxLines: 3),
                const SizedBox(height: 16),
                _field('Phone Number', _phoneCtrl, keyboard: TextInputType.phone),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {int maxLines = 1, TextInputType? keyboard}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTheme.label(size: 14)),
      const SizedBox(height: 6),
      TextField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboard,
        style: AppTheme.body(size: 15),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide.none),
        ),
      ),
    ]);
  }
}

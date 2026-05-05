import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';
import '../../providers/role_provider.dart';
import '../../data/services/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _phoneCtrl;
  bool _isLoading = false;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = context.read<RoleProvider>().currentUser;
    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _bioCtrl = TextEditingController(text: user?.bio ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? selected = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (selected != null) {
      setState(() => _imageFile = selected);
    }
  }

  Future<void> _saveProfile() async {
    final roleProvider = context.read<RoleProvider>();
    final user = roleProvider.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      String? avatarUrl = user.avatarUrl;

      // Upload image if a new one was picked
      if (_imageFile != null) {
        final bytes = await _imageFile!.readAsBytes();
        String ext = 'jpg';
        if (_imageFile!.path.contains('.')) {
          ext = _imageFile!.path.split('.').last.toLowerCase();
        }
        avatarUrl = await ProfileService().uploadAvatar(user.id, bytes, ext);
      }

      final updates = {
        'name': _nameCtrl.text.trim(),
        'bio': _bioCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'avatarUrl': avatarUrl,
      };
      
      await ProfileService().updateProfile(user.id, updates);
      await roleProvider.initialize(); // Refresh the profile in the app state
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully'), backgroundColor: AppColors.success)
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e'), backgroundColor: AppColors.error)
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<RoleProvider>().currentUser;
    
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
              _isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : TextButton(
                    onPressed: _saveProfile,
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
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primary.withAlpha(31),
                          backgroundImage: _imageFile != null 
                              ? (kIsWeb ? NetworkImage(_imageFile!.path) : FileImage(File(_imageFile!.path)) as ImageProvider)
                              : (user?.avatarUrl != null && user!.avatarUrl.isNotEmpty ? NetworkImage(user.avatarUrl) : null),
                          child: (_imageFile == null && (user?.avatarUrl == null || user!.avatarUrl.isEmpty)) 
                              ? const Icon(Icons.person, size: 50, color: AppColors.primary) 
                              : null,
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


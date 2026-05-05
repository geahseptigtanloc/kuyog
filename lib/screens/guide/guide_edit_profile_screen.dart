import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';
import '../../providers/role_provider.dart';
import '../../data/services/profile_service.dart';

class GuideEditProfileScreen extends StatefulWidget {
  const GuideEditProfileScreen({super.key});
  @override
  State<GuideEditProfileScreen> createState() => _GuideEditProfileScreenState();
}

class _GuideEditProfileScreenState extends State<GuideEditProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _bioCtrl;
  late TextEditingController _storyCtrl;
  late TextEditingController _experienceCtrl;
  double _maxGroupSize = 5;
  
  final List<String> _availablePayments = ['Cash', 'GCash', 'Maya', 'Bank Transfer', 'Credit/Debit Card'];
  List<String> _selectedPayments = ['Cash'];

  final List<String> _availableSpecialties = ['Adventure', 'Cultural', 'Food', 'Nature', 'Photography', 'History', 'Hiking'];
  List<String> _selectedSpecialties = [];

  bool _isLoading = true;
  bool _isSaving = false;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _bioCtrl = TextEditingController();
    _storyCtrl = TextEditingController();
    _experienceCtrl = TextEditingController();
    _loadData();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _storyCtrl.dispose();
    _experienceCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final user = context.read<RoleProvider>().currentUser;
    if (user == null) return;

    try {
      final res = await Supabase.instance.client
          .from('guide_profiles')
          .select('fullStory, maxGroupSize, acceptedPayments, yearsExperience, specialties')
          .eq('profile_id', user.id)
          .maybeSingle();

      setState(() {
        _nameCtrl.text = user.name;
        _bioCtrl.text = user.bio;
        
        if (res != null) {
          _storyCtrl.text = res['fullStory'] ?? '';
          _experienceCtrl.text = (res['yearsExperience'] ?? 0).toString();
          _maxGroupSize = (res['maxGroupSize'] ?? 5).toDouble();
          _selectedPayments = List<String>.from(res['acceptedPayments'] ?? ['Cash']);
          _selectedSpecialties = List<String>.from(res['specialties'] ?? []);
        }
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading guide profile data: $e');
      setState(() => _isLoading = false);
    }
  }

  void _togglePayment(String method) {
    setState(() {
      if (_selectedPayments.contains(method)) {
        if (_selectedPayments.length > 1) {
          _selectedPayments.remove(method);
        }
      } else {
        _selectedPayments.add(method);
      }
    });
  }

  void _toggleSpecialty(String specialty) {
    setState(() {
      if (_selectedSpecialties.contains(specialty)) {
        _selectedSpecialties.remove(specialty);
      } else {
        _selectedSpecialties.add(specialty);
      }
    });
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

  Future<void> _saveData() async {
    final roleProvider = context.read<RoleProvider>();
    final user = roleProvider.currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);

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

      // 1. Update basic profiles table
      final profileUpdates = {
        'name': _nameCtrl.text.trim(),
        'bio': _bioCtrl.text.trim(),
        'avatarUrl': avatarUrl,
      };
      await ProfileService().updateProfile(user.id, profileUpdates);
      
      // 2. Update guide_profiles table
      final guideUpdates = {
        'fullStory': _storyCtrl.text.trim(),
        'storyExcerpt': _storyCtrl.text.trim().length > 100 
            ? '${_storyCtrl.text.trim().substring(0, 97)}...' 
            : _storyCtrl.text.trim(),
        'maxGroupSize': _maxGroupSize.toInt(),
        'acceptedPayments': _selectedPayments,
        'yearsExperience': int.tryParse(_experienceCtrl.text) ?? 0,
        'specialties': _selectedSpecialties,
      };
      await Supabase.instance.client
          .from('guide_profiles')
          .update(guideUpdates)
          .eq('profile_id', user.id);

      await roleProvider.initialize(); // Refresh user state
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Profile updated successfully'), backgroundColor: AppColors.success)
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e'), backgroundColor: AppColors.error)
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

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
              Text('Edit Guide Profile', style: AppTheme.headline(size: 20)),
              const Spacer(),
              _isSaving 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : TextButton(
                    onPressed: _saveData,
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
                              ? Icon(Icons.person, size: 50, color: AppColors.primary) 
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('Basic Info'),
                _field('Full Name', _nameCtrl),
                const SizedBox(height: 16),
                _field('Short Bio', _bioCtrl, maxLines: 2),
                const SizedBox(height: 16),
                _field('Years of Experience', _experienceCtrl, keyboard: TextInputType.number),
                const SizedBox(height: 32),

                _buildSectionTitle('Specialties'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableSpecialties.map((s) {
                    final isSelected = _selectedSpecialties.contains(s);
                    return FilterChip(
                      label: Text(s),
                      selected: isSelected,
                      onSelected: (_) => _toggleSpecialty(s),
                      selectedColor: AppColors.primary.withAlpha(51),
                      checkmarkColor: AppColors.primary,
                      labelStyle: AppTheme.body(size: 13, color: isSelected ? AppColors.primary : AppColors.textPrimary),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),

                _buildSectionTitle('Your Story'),
                Text('Tell tourists about your background, your local community, and why you love guiding.', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 12),
                _field('Full Story', _storyCtrl, maxLines: 5),
                const SizedBox(height: 32),

                _buildSectionTitle('Tour Preferences'),
                Text('Maximum Group Size: ${_maxGroupSize.toInt()} tourists', style: AppTheme.label(size: 14)),
                const SizedBox(height: 4),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.primary,
                    thumbColor: AppColors.primary,
                    inactiveTrackColor: AppColors.primaryLight.withAlpha(76),
                  ),
                  child: Slider(
                    value: _maxGroupSize,
                    min: 1,
                    max: 20,
                    divisions: 19,
                    label: _maxGroupSize.toInt().toString(),
                    onChanged: (val) => setState(() => _maxGroupSize = val),
                  ),
                ),
                const SizedBox(height: 32),

                _buildSectionTitle('Accepted Payments'),
                Text('What payment methods do you accept?', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _availablePayments.map((method) {
                    final isSelected = _selectedPayments.contains(method);
                    return GestureDetector(
                      onTap: () => _togglePayment(method),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected) const Icon(Icons.check, size: 16, color: Colors.white),
                            if (isSelected) const SizedBox(width: 6),
                            Text(method, style: AppTheme.label(size: 13, color: isSelected ? Colors.white : AppColors.textPrimary)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: AppTheme.headline(size: 18, color: AppColors.primary)),
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


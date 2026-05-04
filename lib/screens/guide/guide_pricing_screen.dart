import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';
import '../../providers/role_provider.dart';

class GuidePricingScreen extends StatefulWidget {
  const GuidePricingScreen({super.key});
  @override
  State<GuidePricingScreen> createState() => _GuidePricingScreenState();
}

class _GuidePricingScreenState extends State<GuidePricingScreen> {
  final _hourlyCtrl = TextEditingController();
  final _dailyCtrl = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadPricing();
  }

  Future<void> _loadPricing() async {
    final user = context.read<RoleProvider>().currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final res = await Supabase.instance.client
          .from('guide_profiles')
          .select('price_min, price_max')
          .eq('profile_id', user.id)
          .maybeSingle();

      if (res != null && mounted) {
        _hourlyCtrl.text = res['price_min']?.toString() ?? '';
        _dailyCtrl.text = res['price_max']?.toString() ?? '';
      }
    } catch (e) {
      debugPrint('Error loading pricing: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _savePricing() async {
    final user = context.read<RoleProvider>().currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);
    
    try {
      final updates = {
        'price_min': double.tryParse(_hourlyCtrl.text) ?? 0.0,
        'price_max': double.tryParse(_dailyCtrl.text) ?? 0.0,
      };

      await Supabase.instance.client
          .from('guide_profiles')
          .update(updates)
          .eq('profile_id', user.id);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rates updated successfully!'), backgroundColor: AppColors.success)
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update rates: $e'), backgroundColor: AppColors.error)
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() { _hourlyCtrl.dispose(); _dailyCtrl.dispose(); super.dispose(); }

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
              Text('Pricing & Rates', style: AppTheme.headline(size: 20)),
            ]),
          ),
          Expanded(
            child: _isLoading 
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : ListView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              children: [
                _field('Hourly Rate (PHP)', _hourlyCtrl),
                const SizedBox(height: 16),
                _field('Daily Rate (PHP)', _dailyCtrl),
                const SizedBox(height: 24),
                Text('Standard Kuyog guide rates range from ₱300-₱500/hr depending on experience and certifications.', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, boxShadow: AppShadows.bottomNav),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading || _isSaving ? null : _savePricing,
                child: _isSaving 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Save Rates'),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTheme.label(size: 14)),
      const SizedBox(height: 8),
      TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true, fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide.none),
        ),
      ),
    ]);
  }
}

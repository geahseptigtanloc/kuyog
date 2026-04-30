import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';

class MerchantDeliverySettingsScreen extends StatefulWidget {
  const MerchantDeliverySettingsScreen({super.key});
  @override
  State<MerchantDeliverySettingsScreen> createState() => _MerchantDeliverySettingsScreenState();
}

class _MerchantDeliverySettingsScreenState extends State<MerchantDeliverySettingsScreen> {
  bool _localPickup = true;
  bool _standardShipping = true;
  bool _expressShipping = false;
  final _feeCtrl = TextEditingController(text: '100');

  @override
  void dispose() { _feeCtrl.dispose(); super.dispose(); }

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
              Text('Delivery Settings', style: AppTheme.headline(size: 20)),
            ]),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              children: [
                _switchTile('Local Pickup', 'Customers can pick up from your physical store', _localPickup, (v) => setState(() => _localPickup = v)),
                _switchTile('Standard Shipping', '3-5 business days delivery', _standardShipping, (v) => setState(() => _standardShipping = v)),
                if (_standardShipping) ...[
                  const SizedBox(height: 12),
                  _field('Standard Shipping Fee (PHP)', _feeCtrl),
                ],
                const SizedBox(height: 16),
                _switchTile('Express Shipping', 'Same-day or next-day delivery (Grab/Lalamove)', _expressShipping, (v) => setState(() => _expressShipping = v)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, boxShadow: AppShadows.bottomNav),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delivery settings saved'), backgroundColor: AppColors.merchantAmber));
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.merchantAmber),
                child: const Text('Save Settings'),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _switchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), boxShadow: AppShadows.card),
      child: SwitchListTile(
        title: Text(title, style: AppTheme.label(size: 15)),
        subtitle: Text(subtitle, style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.merchantAmber,
        contentPadding: EdgeInsets.zero,
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

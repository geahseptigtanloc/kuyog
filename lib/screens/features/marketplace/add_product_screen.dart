import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../widgets/kuyog_back_button.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  int _step = 0;
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _category = 'Crafts';
  int _stock = 50;
  bool _isMindanaoMade = true;

  @override
  void dispose() { _nameCtrl.dispose(); _priceCtrl.dispose(); _descCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
          child: Row(children: [
            KuyogBackButton(onTap: () => _step > 0 ? setState(() => _step--) : Navigator.pop(context)),
            const SizedBox(width: 12),
            Text('Add Product', style: AppTheme.headline(size: 20)),
            const Spacer(),
            Text('Step ${_step + 1}/3', style: AppTheme.label(size: 13, color: AppColors.primary)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(children: List.generate(3, (i) => Expanded(child: Container(
            height: 4, margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
            decoration: BoxDecoration(color: i <= _step ? AppColors.accent : AppColors.divider, borderRadius: BorderRadius.circular(2)),
          )))),
        ),
        Expanded(child: [_stepBasicInfo(), _stepDetails(), _stepReview()][_step]),
        _buildBottomButtons(),
      ])),
    );
  }

  Widget _stepBasicInfo() {
    return SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Product Information', style: AppTheme.headline(size: 18)),
      const SizedBox(height: 16),
      _field('Product Name', _nameCtrl, 'e.g. T\'nalak Woven Bag'),
      const SizedBox(height: 12),
      _field('Price (PHP)', _priceCtrl, 'e.g. 1850', keyboard: TextInputType.number),
      const SizedBox(height: 16),
      Text('Category', style: AppTheme.label(size: 14)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: ['Crafts', 'Food', 'Fashion', 'Souvenirs', 'Other'].map((c) => ChoiceChip(
        label: Text(c), selected: _category == c, onSelected: (_) => setState(() => _category = c),
        selectedColor: AppColors.accent, labelStyle: TextStyle(color: _category == c ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600),
      )).toList()),
    ]));
  }

  Widget _stepDetails() {
    return SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('More Details', style: AppTheme.headline(size: 18)),
      const SizedBox(height: 16),
      TextField(controller: _descCtrl, maxLines: 4, style: AppTheme.body(size: 14),
        decoration: InputDecoration(hintText: 'Describe your product...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)))),
      const SizedBox(height: 16),
      Row(children: [
        Text('Stock:', style: AppTheme.label(size: 14)),
        const Spacer(),
        IconButton(onPressed: _stock > 1 ? () => setState(() => _stock--) : null, icon: const Icon(Icons.remove_circle_outline)),
        Text('$_stock', style: AppTheme.headline(size: 18)),
        IconButton(onPressed: () => setState(() => _stock++), icon: const Icon(Icons.add_circle_outline, color: AppColors.primary)),
      ]),
      const SizedBox(height: 12),
      SwitchListTile(
        title: Text('Mindanao-Made', style: AppTheme.label(size: 14)),
        subtitle: Text('Tag as locally sourced', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
        value: _isMindanaoMade, onChanged: (v) => setState(() => _isMindanaoMade = v),
        activeColor: AppColors.primary,
      ),
      const SizedBox(height: 16),
      GestureDetector(
        onTap: () {},
        child: Container(
          height: 120, width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: AppColors.divider, width: 1.5)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.add_a_photo, size: 32, color: AppColors.primary.withOpacity(0.5)),
            const SizedBox(height: 8),
            Text('Add Photos', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
          ]),
        ),
      ),
    ]));
  }

  Widget _stepReview() {
    return SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Review Product', style: AppTheme.headline(size: 18)),
      const SizedBox(height: 16),
      _row('Name', _nameCtrl.text.isEmpty ? 'Not set' : _nameCtrl.text),
      _row('Price', _priceCtrl.text.isEmpty ? 'Not set' : '\u20B1${_priceCtrl.text}'),
      _row('Category', _category),
      _row('Stock', '$_stock units'),
      _row('Mindanao-Made', _isMindanaoMade ? 'Yes' : 'No'),
      _row('Description', _descCtrl.text.isEmpty ? 'Not set' : _descCtrl.text),
    ]));
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(children: [Text(label, style: AppTheme.label(size: 13, color: AppColors.textSecondary)), const Spacer(), Flexible(child: Text(value, style: AppTheme.label(size: 14), textAlign: TextAlign.end))])),
  );

  Widget _field(String label, TextEditingController ctrl, String hint, {TextInputType? keyboard}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTheme.label(size: 14)), const SizedBox(height: 6),
      TextField(controller: ctrl, keyboardType: keyboard, style: AppTheme.body(size: 15),
        decoration: InputDecoration(hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)))),
    ]);
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, -2))]),
      child: Row(children: [
        if (_step > 0) Expanded(child: OutlinedButton(onPressed: () => setState(() => _step--), child: const Text('Back'))),
        if (_step > 0) const SizedBox(width: 12),
        Expanded(child: ElevatedButton(
          onPressed: () { if (_step < 2) setState(() => _step++); else { Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Product added!'), backgroundColor: AppColors.primary)); } },
          style: ElevatedButton.styleFrom(backgroundColor: _step == 2 ? AppColors.accent : AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
          child: Text(_step == 2 ? 'Publish Product' : 'Next'),
        )),
      ]),
    );
  }
}

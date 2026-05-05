import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../models/transport_rental.dart';
import '../../../widgets/kuyog_back_button.dart';
import '../../../widgets/durie_loading.dart';

class TransportBookingScreen extends StatefulWidget {
  const TransportBookingScreen({super.key});
  @override
  State<TransportBookingScreen> createState() => _TransportBookingScreenState();
}

class _TransportBookingScreenState extends State<TransportBookingScreen> with SingleTickerProviderStateMixin {
  List<TransportRental> _partners = [];
  bool _loading = true;
  TransportRental? _selected;
  bool _waiver = false;
  String _payment = 'GCash';
  bool _fullDay = true;
  DateTime _date = DateTime.now().add(const Duration(days: 3));
  int _step = 0;
  late TabController _tabCtrl;
  final _types = ['van', 'car', 'airport_transfer', 'boat'];
  final _typeLabels = ['Van', 'Sedan', 'Airport', 'Boat'];

  @override
  void initState() { super.initState(); _tabCtrl = TabController(length: 4, vsync: this); _load(); }
  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  Future<void> _load() async {
    final p = await MockData.getTransportPartners();
    if (mounted) setState(() { _partners = p; _loading = false; });
  }

  List<TransportRental> _byType(String t) => _partners.where((p) => p.vehicleType == t).toList();
  double get _price => _selected == null ? 0 : (_fullDay ? _selected!.pricePerDay : _selected!.pricePerHalfDay);
  double get _fee => _price * 0.08;
  double get _total => _price + _fee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: KuyogBackButton(onTap: () { if (_step > 0) {
          setState(() => _step--);
        } else {
          Navigator.pop(context);
        } }),
        title: Text(_step == 0 ? 'Transport Rental' : _step == 1 ? 'Booking Details' : _step == 2 ? 'Confirm' : 'Booked!'),
      ),
      body: _loading ? const DurieLoading() : _step == 0 ? _selectVehicle() : _step == 1 ? _details() : _step == 2 ? _confirm() : _done(),
      bottomNavigationBar: _step < 3 ? Container(
        padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, boxShadow: AppShadows.bottomNav),
        child: SafeArea(child: SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: _canContinue ? () => setState(() => _step++) : null,
          style: ElevatedButton.styleFrom(backgroundColor: _step == 2 ? AppColors.success : AppColors.accent, padding: const EdgeInsets.symmetric(vertical: 16)),
          child: Text(_step == 2 ? 'Confirm & Pay P${_total.toInt()}' : 'Continue', style: AppTheme.label(size: 16, color: Colors.white)),
        ))),
      ) : null,
    );
  }

  bool get _canContinue {
    if (_step == 0) return _selected != null;
    if (_step == 1) return true;
    if (_step == 2) return _waiver;
    return true;
  }

  Widget _selectVehicle() => Column(children: [
    // Pill Tabs
    Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl, vertical: 12),
      child: Row(
        children: List.generate(
          _typeLabels.length,
          (i) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i != _typeLabels.length - 1 ? 8 : 0),
              child: GestureDetector(
                onTap: () {
                  _tabCtrl.animateTo(i);
                  setState(() {});
                },
                child: AnimatedBuilder(
                  animation: _tabCtrl,
                  builder: (context, _) {
                    final isSelected = _tabCtrl.index == i;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 44,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.divider,
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _typeLabels[i],
                          style: AppTheme.body(
                            size: 12,
                            weight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    Expanded(child: TabBarView(controller: _tabCtrl, children: _types.map((t) {
      final list = _byType(t);
      if (list.isEmpty) return Center(child: Text('No ${t.replaceAll('_', ' ')} partners yet', style: AppTheme.body(size: 14, color: AppColors.textLight)));
      return ListView.builder(padding: const EdgeInsets.all(16), itemCount: list.length, itemBuilder: (c, i) => _vehicleCard(list[i]));
    }).toList())),
  ]);

  Widget _vehicleCard(TransportRental p) {
    final sel = _selected?.id == p.id;
    return GestureDetector(
      onTap: () => setState(() => _selected = p),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: sel ? AppColors.primary : AppColors.divider, width: sel ? 2 : 1), boxShadow: sel ? [BoxShadow(color: AppColors.primary.withAlpha(26), blurRadius: 8)] : AppShadows.card),
        child: Row(children: [
          ClipRRect(borderRadius: BorderRadius.circular(AppRadius.md),
            child: CachedNetworkImage(imageUrl: p.photoUrl, width: 90, height: 70, fit: BoxFit.cover,
              placeholder: (c,u) => Container(width: 90, height: 70, color: AppColors.divider),
              errorWidget: (c,u,e) => Container(width: 90, height: 70, color: AppColors.primary.withAlpha(26)))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(p.partnerName, style: AppTheme.label(size: 14))),
              if (p.isKuyogVetted) Icon(Icons.verified, size: 16, color: AppColors.verified),
            ]),
            Text(p.vehicleModel, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
              Text(' ${p.rating}', style: AppTheme.label(size: 12)),
              Text(' (${p.reviewCount})', style: AppTheme.body(size: 11, color: AppColors.textLight)),
              const Spacer(),
              Text('P${p.pricePerDay.toInt()}', style: AppTheme.label(size: 14, color: AppColors.primary)),
              Text('/day', style: AppTheme.body(size: 10, color: AppColors.textLight)),
            ]),
            Row(children: [
              const Icon(Icons.people, size: 14, color: AppColors.textLight),
              Text(' ${p.capacity} pax', style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
              if (p.insuranceVerified) ...[const SizedBox(width: 8), const Icon(Icons.security, size: 12, color: AppColors.success), Text(' Insured', style: AppTheme.body(size: 10, color: AppColors.success))],
            ]),
          ])),
        ]),
      ),
    );
  }

  Widget _details() => SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(_selected!.partnerName, style: AppTheme.headline(size: 18)),
    Text(_selected!.vehicleModel, style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
    const SizedBox(height: 20),
    Text('Date', style: AppTheme.label(size: 15)),
    const SizedBox(height: 8),
    GestureDetector(
      onTap: () async { final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365))); if (d != null) setState(() => _date = d); },
      child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: AppColors.divider)),
        child: Row(children: [const Icon(Icons.calendar_today, color: AppColors.primary), const SizedBox(width: 12), Text(DateFormat('EEEE, MMMM d, y').format(_date), style: AppTheme.body(size: 15))])),
    ),
    const SizedBox(height: 20),
    Text('Duration', style: AppTheme.label(size: 15)),
    const SizedBox(height: 8),
    Row(children: [
      Expanded(child: GestureDetector(onTap: () => setState(() => _fullDay = true), child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: _fullDay ? AppColors.primary.withAlpha(26) : Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: _fullDay ? AppColors.primary : AppColors.divider)),
        child: Column(children: [Text('Full Day', style: AppTheme.label(size: 14, color: _fullDay ? AppColors.primary : AppColors.textPrimary)), Text('P${_selected!.pricePerDay.toInt()}', style: AppTheme.body(size: 12, color: AppColors.textSecondary))])))),
      const SizedBox(width: 12),
      Expanded(child: GestureDetector(onTap: () => setState(() => _fullDay = false), child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: !_fullDay ? AppColors.primary.withAlpha(26) : Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: !_fullDay ? AppColors.primary : AppColors.divider)),
        child: Column(children: [Text('Half Day', style: AppTheme.label(size: 14, color: !_fullDay ? AppColors.primary : AppColors.textPrimary)), Text('P${_selected!.pricePerHalfDay.toInt()}', style: AppTheme.body(size: 12, color: AppColors.textSecondary))])))),
    ]),
    const SizedBox(height: 20),
    Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.primary.withAlpha(15), borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Rental', style: AppTheme.body(size: 14)), Text('P${_price.toInt()}', style: AppTheme.label(size: 14))]),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('KUYOG Fee (8%)', style: AppTheme.body(size: 14)), Text('P${_fee.toInt()}', style: AppTheme.label(size: 14))]),
        const Divider(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Total', style: AppTheme.label(size: 16)), Text('P${_total.toInt()}', style: AppTheme.headline(size: 20, color: AppColors.primary))]),
      ])),
  ]));

  Widget _confirm() => SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Confirm Booking', style: AppTheme.headline(size: 18)),
    const SizedBox(height: 16),
    Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Column(children: [
        _row('Vehicle', '${_selected!.partnerName} - ${_selected!.vehicleModel}'),
        _row('Date', DateFormat('MMM d, y').format(_date)),
        _row('Duration', _fullDay ? 'Full Day' : 'Half Day'),
        _row('Total', 'P${_total.toInt()}'),
      ])),
    const SizedBox(height: 16),
    // Waiver
    Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.warning.withAlpha(15), borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: AppColors.warning.withAlpha(76))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Transport Liability Waiver', style: AppTheme.label(size: 14, color: AppColors.warning)),
        const SizedBox(height: 8),
        Text('I acknowledge that transport services are provided by a third-party KUYOG-vetted partner. I confirm that I have reviewed the vehicle condition and agree to the rental terms.', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 12),
        Row(children: [
          Checkbox(value: _waiver, onChanged: (v) => setState(() => _waiver = v ?? false), activeColor: AppColors.primary),
          Expanded(child: Text('I accept the transport liability waiver', style: AppTheme.label(size: 13))),
        ]),
      ])),
    const SizedBox(height: 16),
    Text('Payment Method', style: AppTheme.label(size: 15)),
    const SizedBox(height: 8),
    ...['GCash', 'Maya', 'Cash'].map((p) => GestureDetector(
      onTap: () => setState(() => _payment = p),
      child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: _payment == p ? AppColors.primary : AppColors.divider)),
        child: Row(children: [
          Icon(_payment == p ? Icons.radio_button_checked : Icons.radio_button_off, color: _payment == p ? AppColors.primary : AppColors.textLight),
          const SizedBox(width: 12), Text(p, style: AppTheme.label(size: 14)),
        ])),
    )),
  ]));

  Widget _done() => Center(child: Padding(padding: const EdgeInsets.all(40), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.success.withAlpha(26), shape: BoxShape.circle),
      child: const Icon(Icons.check_circle, size: 64, color: AppColors.success)),
    const SizedBox(height: 24),
    Text('Transport Booked!', style: AppTheme.headline(size: 22)),
    const SizedBox(height: 8),
    Text('Your driver will contact you before pickup', style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
    const SizedBox(height: 24),
    Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.accent.withAlpha(20), borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.emoji_events, size: 20, color: AppColors.accent),
        const SizedBox(width: 8),
        Text('+200 Madayaw Points earned!', style: AppTheme.label(size: 13, color: AppColors.accent)),
      ])),
    const SizedBox(height: 32),
    SizedBox(width: double.infinity, child: ElevatedButton(
      onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
      child: Text('Back to Home', style: AppTheme.label(size: 16, color: Colors.white)),
    )),
  ])));

  Widget _row(String l, String v) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(l, style: AppTheme.body(size: 14, color: AppColors.textSecondary)), Flexible(child: Text(v, style: AppTheme.label(size: 14), textAlign: TextAlign.right)),
  ]));
}


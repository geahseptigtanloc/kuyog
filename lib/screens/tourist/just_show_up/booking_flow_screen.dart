import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../app_theme.dart';
import '../../../models/tour_operator.dart';
import '../../../widgets/kuyog_back_button.dart';

class BookingFlowScreen extends StatefulWidget {
  final TourPackage package;
  final TourOperator? operator;
  const BookingFlowScreen({super.key, required this.package, this.operator});
  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  int _step = 0;
  DateTime _date = DateTime.now().add(const Duration(days: 7));
  int _pax = 2;
  final Set<int> _addOnIndices = {};
  String _payment = 'GCash';
  final _payments = ['GCash', 'Maya', 'Credit/Debit Card', 'Bank Transfer'];

  double get _tourTotal => widget.package.price * _pax;
  double get _addOnTotal => _addOnIndices.fold(0.0, (s, i) => s + ((widget.package.addOns[i]['price'] as num?)?.toDouble() ?? 0));
  double get _serviceFee => (_tourTotal + _addOnTotal) * 0.08;
  double get _total => _tourTotal + _addOnTotal + _serviceFee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(_stepTitle), leading: KuyogBackButton(onTap: () { if (_step > 0) { setState(() => _step--); } else { Navigator.pop(context); } })),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: _buildStep()),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  String get _stepTitle => ['Select Date & Group', 'Add-Ons', 'Review Booking', 'Payment', 'Confirmed!'][_step];

  Widget _buildStep() {
    switch (_step) {
      case 0: return _dateAndPax();
      case 1: return _addOns();
      case 2: return _review();
      case 3: return _paymentStep();
      case 4: return _confirmation();
      default: return const SizedBox();
    }
  }

  Widget _dateAndPax() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(widget.package.name, style: AppTheme.headline(size: 18)),
    const SizedBox(height: 20),
    Text('Select Date', style: AppTheme.label(size: 15)),
    const SizedBox(height: 8),
    GestureDetector(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
        if (d != null) setState(() => _date = d);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: AppColors.divider)),
        child: Row(children: [
          const Icon(Icons.calendar_today, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(DateFormat('EEEE, MMMM d, y').format(_date), style: AppTheme.body(size: 15)),
        ]),
      ),
    ),
    const SizedBox(height: 24),
    Text('Group Size', style: AppTheme.label(size: 15)),
    const SizedBox(height: 8),
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: AppColors.divider)),
      child: Row(children: [
        IconButton(onPressed: _pax > widget.package.minGroupSize ? () => setState(() => _pax--) : null, icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary)),
        Expanded(child: Center(child: Text('$_pax person(s)', style: AppTheme.headline(size: 20)))),
        IconButton(onPressed: _pax < widget.package.maxPax ? () => setState(() => _pax++) : null, icon: const Icon(Icons.add_circle_outline, color: AppColors.primary)),
      ]),
    ),
    const SizedBox(height: 8),
    Text('Min: ${widget.package.minGroupSize} / Max: ${widget.package.maxPax}', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
    const SizedBox(height: 24),
    Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.primary.withAlpha(15), borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Subtotal', style: AppTheme.label(size: 15)),
        Text('P${_tourTotal.toInt()}', style: AppTheme.headline(size: 20, color: AppColors.primary)),
      ]),
    ),
  ]);

  Widget _addOns() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Optional Add-Ons', style: AppTheme.headline(size: 18)),
    const SizedBox(height: 8),
    Text('Enhance your experience', style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
    const SizedBox(height: 16),
    if (widget.package.addOns.isEmpty) Center(child: Padding(padding: const EdgeInsets.all(40), child: Text('No add-ons available', style: AppTheme.body(size: 14, color: AppColors.textLight)))),
    ...widget.package.addOns.asMap().entries.map((e) {
      final i = e.key; final a = e.value; final sel = _addOnIndices.contains(i);
      return GestureDetector(
        onTap: () => setState(() { if (sel) {
          _addOnIndices.remove(i);
        } else {
          _addOnIndices.add(i);
        } }),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: sel ? AppColors.primary : AppColors.divider, width: sel ? 2 : 1)),
          child: Row(children: [
            Icon(sel ? Icons.check_circle : Icons.circle_outlined, color: sel ? AppColors.primary : AppColors.textLight),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(a['name'] ?? '', style: AppTheme.label(size: 14)),
              Text(a['desc'] ?? '', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
            ])),
            Text('+P${(a['price'] as num?)?.toInt() ?? 0}', style: AppTheme.label(size: 14, color: AppColors.primary)),
          ]),
        ),
      );
    }),
  ]);

  Widget _review() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Booking Summary', style: AppTheme.headline(size: 18)),
    const SizedBox(height: 16),
    _reviewRow('Tour', widget.package.name),
    if (widget.operator != null) _reviewRow('Operator', widget.operator!.companyName),
    _reviewRow('Date', DateFormat('MMM d, y').format(_date)),
    _reviewRow('Group Size', '$_pax person(s)'),
    const Divider(height: 24),
    _reviewRow('Tour Price', 'P${_tourTotal.toInt()}'),
    if (_addOnTotal > 0) _reviewRow('Add-Ons', 'P${_addOnTotal.toInt()}'),
    _reviewRow('KUYOG Service Fee (8%)', 'P${_serviceFee.toInt()}'),
    const Divider(height: 24),
    _reviewRow('Total', 'P${_total.toInt()}', bold: true),
    const SizedBox(height: 12),
    Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.touristBlue.withAlpha(15), borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(children: [
        const Icon(Icons.info_outline, size: 16, color: AppColors.touristBlue),
        const SizedBox(width: 8),
        Expanded(child: Text('Payment is held in escrow. The operator receives payment 24 hours after you confirm trip completion.', style: AppTheme.body(size: 11, color: AppColors.touristBlue))),
      ]),
    ),
  ]);

  Widget _reviewRow(String label, String value, {bool bold = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: bold ? AppTheme.label(size: 15) : AppTheme.body(size: 14, color: AppColors.textSecondary)),
      Flexible(child: Text(value, style: bold ? AppTheme.headline(size: 18, color: AppColors.primary) : AppTheme.label(size: 14), textAlign: TextAlign.right)),
    ]),
  );

  Widget _paymentStep() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Payment Method', style: AppTheme.headline(size: 18)),
    const SizedBox(height: 16),
    ..._payments.map((p) => GestureDetector(
      onTap: () => setState(() => _payment = p),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: _payment == p ? AppColors.primary : AppColors.divider, width: _payment == p ? 2 : 1)),
        child: Row(children: [
          Icon(_payment == p ? Icons.radio_button_checked : Icons.radio_button_off, color: _payment == p ? AppColors.primary : AppColors.textLight),
          const SizedBox(width: 12),
          Text(p, style: AppTheme.label(size: 14)),
        ]),
      ),
    )),
    const SizedBox(height: 16),
    Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.primary.withAlpha(15), borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Total to Pay', style: AppTheme.label(size: 16)),
        Text('P${_total.toInt()}', style: AppTheme.headline(size: 22, color: AppColors.primary)),
      ]),
    ),
  ]);

  Widget _confirmation() {
    return Column(children: [
      const SizedBox(height: 40),
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.success.withAlpha(26), shape: BoxShape.circle),
        child: const Icon(Icons.check_circle, size: 64, color: AppColors.success)),
      const SizedBox(height: 24),
      Text('Booking Confirmed!', style: AppTheme.headline(size: 24)),
      const SizedBox(height: 8),
      Text('Your adventure awaits', style: AppTheme.body(size: 15, color: AppColors.textSecondary)),
      const SizedBox(height: 24),
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg)),
        child: Column(children: [
          _reviewRow('Tour', widget.package.name),
          _reviewRow('Date', DateFormat('MMM d, y').format(_date)),
          _reviewRow('Group', '$_pax person(s)'),
          _reviewRow('Total Paid', 'P${_total.toInt()}'),
          _reviewRow('Payment', _payment),
          _reviewRow('Booking Ref', 'KYG-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}'),
        ]),
      ),
      const SizedBox(height: 16),
      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.accent.withAlpha(20), borderRadius: BorderRadius.circular(AppRadius.md)),
        child: Row(children: [
          const Icon(Icons.emoji_events, size: 20, color: AppColors.accent),
          const SizedBox(width: 8),
          Expanded(child: Text('You earned 500 Madayaw Points!', style: AppTheme.label(size: 13, color: AppColors.accent))),
        ]),
      ),
    ]);
  }

  Widget _buildBottomBar() {
    if (_step == 4) {
      return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, boxShadow: AppShadows.bottomNav),
        child: SafeArea(child: SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: () { Navigator.popUntil(context, (r) => r.isFirst); },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
          child: Text('Back to Home', style: AppTheme.label(size: 16, color: Colors.white)),
        ))));
    }
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, boxShadow: AppShadows.bottomNav),
      child: SafeArea(child: SizedBox(width: double.infinity, child: ElevatedButton(
        onPressed: () => setState(() => _step++),
        style: ElevatedButton.styleFrom(backgroundColor: _step == 3 ? AppColors.success : AppColors.accent, padding: const EdgeInsets.symmetric(vertical: 16)),
        child: Text(_step == 3 ? 'Confirm & Pay P${_total.toInt()}' : 'Continue', style: AppTheme.label(size: 16, color: Colors.white)),
      ))));
  }
}


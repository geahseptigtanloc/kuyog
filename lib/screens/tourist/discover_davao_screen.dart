import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/destination.dart';
import '../../widgets/kuyog_back_button.dart';
import '../../widgets/durie_loading.dart';
import '../tourist/roam_free/destination_detail_screen.dart';

class DiscoverDavaoScreen extends StatefulWidget {
  const DiscoverDavaoScreen({super.key});
  @override
  State<DiscoverDavaoScreen> createState() => _DiscoverDavaoScreenState();
}

class _DiscoverDavaoScreenState extends State<DiscoverDavaoScreen> {
  List<Destination> _all = [];
  bool _loading = true;
  String _province = 'All';
  final _provinces = ['All', 'Davao City', 'Davao del Norte', 'Davao del Sur', 'Davao de Oro', 'Davao Occidental'];

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final d = await MockData.getDestinations();
    if (mounted) setState(() { _all = d; _loading = false; });
  }

  List<Destination> get _filtered => _province == 'All' ? _all : _all.where((d) => d.province == _province).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: KuyogBackButton(onTap: () => Navigator.pop(context)),
        title: Text('Discover Davao', style: AppTheme.headline(size: 20)),
      ),
      body: _loading ? const DurieLoading() : Column(children: [
        // Province filter
        SizedBox(height: 42, child: ListView.builder(
          scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          itemCount: _provinces.length,
          itemBuilder: (c, i) {
            final sel = _province == _provinces[i];
            return Padding(padding: const EdgeInsets.only(right: 8), child: GestureDetector(
              onTap: () => setState(() => _province = _provinces[i]),
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(color: sel ? AppColors.primary : Colors.white, borderRadius: BorderRadius.circular(AppRadius.pill), border: Border.all(color: sel ? AppColors.primary : AppColors.divider)),
                child: Center(child: Text(_provinces[i], style: AppTheme.label(size: 11, color: sel ? Colors.white : AppColors.textSecondary)))),
            ));
          },
        )),
        const SizedBox(height: 8),
        Expanded(child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 0.72),
          itemCount: _filtered.length,
          itemBuilder: (c, i) => _destGridCard(_filtered[i]),
        )),
      ]),
    );
  }

  Widget _destGridCard(Destination d) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DestinationDetailScreen(destination: d))),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 3, child: Stack(children: [
            CachedNetworkImage(imageUrl: d.imageUrl, width: double.infinity, fit: BoxFit.cover,
              placeholder: (c,u) => Container(color: AppColors.divider),
              errorWidget: (c,u,e) => Container(color: AppColors.primary.withAlpha(26))),
            Positioned(top: 8, right: 8, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: Colors.white.withAlpha(230), borderRadius: BorderRadius.circular(AppRadius.pill)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.star_rounded, size: 12, color: AppColors.warning),
                Text(' ${d.rating}', style: AppTheme.label(size: 10)),
              ]),
            )),
          ])),
          Expanded(flex: 2, child: Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d.name, style: AppTheme.label(size: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(d.province, style: AppTheme.body(size: 10, color: AppColors.textSecondary)),
            const Spacer(),
            Row(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: AppColors.primary.withAlpha(20), borderRadius: BorderRadius.circular(4)),
                child: Text(d.category, style: AppTheme.body(size: 9, color: AppColors.primary))),
              const Spacer(),
              Text(d.isFreeEntry ? 'Free' : 'P${d.pricePerDay.toInt()}', style: AppTheme.label(size: 11, color: d.isFreeEntry ? AppColors.success : AppColors.primary)),
            ]),
          ]))),
        ]),
      ),
    );
  }
}


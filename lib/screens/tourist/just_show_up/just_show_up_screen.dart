import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../models/tour_operator.dart';
import '../../../widgets/kuyog_back_button.dart';
import '../../../widgets/durie_loading.dart';
import 'package_detail_screen.dart';

class JustShowUpScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const JustShowUpScreen({super.key, this.onBack});
  @override
  State<JustShowUpScreen> createState() => _JustShowUpScreenState();
}

class _JustShowUpScreenState extends State<JustShowUpScreen> {
  List<TourPackage> _packages = [];
  List<TourOperator> _operators = [];
  bool _loading = true;
  String _selectedCategory = 'All';
  String _selectedProvince = 'All';
  final _categories = ['All', 'City Tours', 'Nature & Adventure', 'Wildlife', 'Beach & Island', 'Cultural Heritage', 'Food & Market'];
  final _provinces = ['All', 'Davao City', 'Davao del Sur', 'Davao Oriental', 'Davao de Oro'];

  String _getProvinceFor(TourPackage pkg) {
    final provinces = ['Davao City', 'Davao del Sur', 'Davao Oriental', 'Davao de Oro'];
    return provinces[pkg.id.hashCode % provinces.length];
  }

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final pkgs = await MockData.getTourPackages();
    final ops = await MockData.getTourOperators();
    if (mounted) setState(() { _packages = pkgs; _operators = ops; _loading = false; });
  }

  TourOperator? _operatorFor(String opId) {
    try { return _operators.firstWhere((o) => o.id == opId); } catch (_) { return null; }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: KuyogBackButton(onTap: widget.onBack ?? () => Navigator.pop(context)),
        title: Text(
          'Just Show Up',
          style: GoogleFonts.baloo2(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.textPrimary),
            onPressed: () {
              // Open filter modal
            },
          ),
        ],
      ),
      body: _loading
          ? const DurieLoading()
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recommended for You
                  _sectionHeader('Recommended for You', 'AI-matched to your interests'),
                  _horizontalPackageList(_packages.take(5).toList()),

                  // Featured by KUYOG
                  _sectionHeader('Featured by KUYOG', 'Editorially picked packages'),
                  _horizontalPackageList(_packages.take(5).toList()),

                  // Trending in Davao
                  _sectionHeader('Trending in Davao', 'Popular packages this month'),
                  _horizontalPackageList(_packages.take(5).toList()),

                  // Filters
                  _filterDropdowns(),

                  // Filtered Package Grid
                  _sectionHeader('All Packages', ''),
                  _packageGrid(),
                ],
              ),
            ),
    );
  }

  Widget _sectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xxxl, AppSpacing.xl, AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.baloo2(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTheme.body(size: 12, color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _horizontalPackageList(List<TourPackage> packages) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        itemCount: packages.length,
        itemBuilder: (context, index) => _packageCard(packages[index]),
      ),
    );
  }

  Widget _packageCard(TourPackage pkg) {
    final op = _operatorFor(pkg.operatorId);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PackageDetailScreen(package: pkg, operator: op),
        ),
      ),
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: pkg.photoUrl,
                  height: 150,
                  width: 260,
                  fit: BoxFit.cover,
                  placeholder: (c, u) => Container(height: 150, color: AppColors.divider),
                  errorWidget: (c, u, e) => Container(height: 150, color: AppColors.primary.withAlpha(38)),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(pkg.difficulty, style: AppTheme.label(size: 10, color: Colors.white)),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(230),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
                        const SizedBox(width: 2),
                        Text('${pkg.rating}', style: AppTheme.label(size: 11)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pkg.name, style: AppTheme.label(size: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  if (op != null)
                    Text(op.companyName, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('P${pkg.price.toInt()}', style: AppTheme.headline(size: 16, color: AppColors.primary)),
                      Text(' /person', style: AppTheme.body(size: 11, color: AppColors.textLight)),
                      const Spacer(),
                      Icon(Icons.schedule, size: 14, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text(pkg.duration.isNotEmpty ? pkg.duration : '${pkg.durationDays}D', style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterDropdowns() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
      child: Row(
        children: [
          // Category Dropdown
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category', style: AppTheme.label(size: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                      items: _categories.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: AppTheme.body(size: 13)),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() => _selectedCategory = newValue!);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Province Dropdown
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Province', style: AppTheme.label(size: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedProvince,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                      items: _provinces.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: AppTheme.body(size: 13)),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() => _selectedProvince = newValue!);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _packageGrid() {
    final filteredPackages = _packages.where((pkg) {
      final categoryMatch = _selectedCategory == 'All' || pkg.categoryTags.contains(_selectedCategory);
      final provinceMatch = _selectedProvince == 'All' || _getProvinceFor(pkg) == _selectedProvince;
      return categoryMatch && provinceMatch;
    }).toList();

    if (filteredPackages.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No packages found for this category')));

    final leftColumn = <TourPackage>[];
    final rightColumn = <TourPackage>[];
    for (var i = 0; i < filteredPackages.length; i++) {
      if (i % 2 == 0) {
        leftColumn.add(filteredPackages[i]);
      } else {
        rightColumn.add(filteredPackages[i]);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: leftColumn.map((p) => _staggeredPackageCard(p, leftColumn.indexOf(p) % 2 == 0)).toList(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: rightColumn.map((p) => _staggeredPackageCard(p, rightColumn.indexOf(p) % 2 != 0)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _staggeredPackageCard(TourPackage pkg, bool isTall) {
    final op = _operatorFor(pkg.operatorId);
    final imageHeight = isTall ? 240.0 : 170.0;
    
    // Mock province for the pill
    final provinces = ['Davao City', 'Davao del Sur', 'Davao Oriental', 'Davao de Oro'];
    final province = provinces[pkg.id.hashCode % provinces.length];

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PackageDetailScreen(package: pkg, operator: op),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: pkg.photoUrl,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (c, u) => Container(height: imageHeight, color: AppColors.divider),
                ),
                // Location Pill (Top Left)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(120),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      province,
                      style: AppTheme.label(size: 10, color: Colors.white),
                    ),
                  ),
                ),
                // Difficulty/Tag (Bottom Left)
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(pkg.difficulty, style: AppTheme.label(size: 9, color: Colors.white)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pkg.name,
                    style: AppTheme.headline(size: 14, height: 1.2),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '₱${pkg.price.toInt()}',
                        style: AppTheme.headline(size: 15, color: AppColors.primary),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text('${pkg.rating}', style: AppTheme.label(size: 11)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

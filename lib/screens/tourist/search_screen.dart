import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/guide.dart';
import '../../models/destination.dart';
import '../../models/product.dart';
import '../../widgets/kuyog_back_button.dart';
import '../../widgets/durie_loading.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  List<Guide> _guides = [];
  List<Destination> _destinations = [];
  List<Product> _products = [];
  bool _loaded = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadAll();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  Future<void> _loadAll() async {
    final g = await MockData.getGuides();
    final d = await MockData.getDestinations();
    final p = await MockData.getProducts();
    if (mounted) setState(() { _guides = g; _destinations = d; _products = p; _loaded = true; });
  }

  @override
  void dispose() { _controller.dispose(); _focusNode.dispose(); super.dispose(); }

  List<Guide> get _filteredGuides => _query.isEmpty ? [] : _guides.where((g) => g.name.toLowerCase().contains(_query.toLowerCase())).toList();
  List<Destination> get _filteredDests => _query.isEmpty ? [] : _destinations.where((d) => d.name.toLowerCase().contains(_query.toLowerCase())).toList();
  List<Product> get _filteredProducts => _query.isEmpty ? [] : _products.where((p) => p.name.toLowerCase().contains(_query.toLowerCase())).toList();

  bool get _hasResults => _filteredGuides.isNotEmpty || _filteredDests.isNotEmpty || _filteredProducts.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
              child: Row(
                children: [
                  KuyogBackButton(onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        boxShadow: AppShadows.card,
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onChanged: (v) => setState(() => _query = v),
                        style: AppTheme.body(size: 15),
                        decoration: InputDecoration(
                          hintText: 'Search guides, places, products...',
                          hintStyle: AppTheme.body(size: 14, color: AppColors.textLight),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          suffixIcon: _query.isNotEmpty
                              ? GestureDetector(
                                  onTap: () => setState(() { _controller.clear(); _query = ''; }),
                                  child: const Icon(Icons.close, size: 20, color: AppColors.textLight),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: !_loaded
                  ? const DurieLoading()
                  : _query.isEmpty
                      ? _buildRecentSearches()
                      : _hasResults
                          ? _buildResults()
                          : DurieEmptyState(message: 'No results found for "$_query"'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    final recents = ['Davao', 'Mt. Apo', 'Rico Guide', 'Durian Candy'];
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        Text('Recent Searches', style: AppTheme.headline(size: 16)),
        const SizedBox(height: 12),
        ...recents.map((r) => InkWell(
          onTap: () => setState(() { _controller.text = r; _query = r; }),
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(children: [
              const Icon(Icons.history, size: 20, color: AppColors.textLight),
              const SizedBox(width: 12),
              Text(r, style: AppTheme.body(size: 14)),
              const Spacer(),
              const Icon(Icons.north_west, size: 16, color: AppColors.textLight),
            ]),
          ),
        )),
      ],
    );
  }

  Widget _buildResults() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_filteredGuides.isNotEmpty) ...[
            _sectionHeader('Guides', _filteredGuides.length),
            ..._filteredGuides.take(3).map((g) => _resultTile(
              imageUrl: g.photoUrl, title: g.name, subtitle: g.city, category: 'Guide',
            )),
            const SizedBox(height: 16),
          ],
          if (_filteredDests.isNotEmpty) ...[
            _sectionHeader('Destinations', _filteredDests.length),
            ..._filteredDests.take(3).map((d) => _resultTile(
              imageUrl: d.imageUrl, title: d.name, subtitle: d.province, category: 'Destination',
            )),
            const SizedBox(height: 16),
          ],
          if (_filteredProducts.isNotEmpty) ...[
            _sectionHeader('Products', _filteredProducts.length),
            ..._filteredProducts.take(3).map((p) => _resultTile(
              imageUrl: p.imageUrl, title: p.name, subtitle: '\u20B1${p.price.toStringAsFixed(0)}', category: 'Product',
            )),
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(title, style: AppTheme.headline(size: 16)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
            child: Text('$count', style: AppTheme.label(size: 11, color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _resultTile({required String imageUrl, required String title, required String subtitle, required String category}) {
    Color catColor = category == 'Guide' ? AppColors.guideGreen : category == 'Destination' ? AppColors.touristBlue : AppColors.merchantAmber;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: CachedNetworkImage(imageUrl: imageUrl, width: 48, height: 48, fit: BoxFit.cover,
              placeholder: (c, u) => Container(width: 48, height: 48, color: AppColors.divider),
              errorWidget: (c, u, e) => Container(width: 48, height: 48, color: AppColors.primary.withOpacity(0.1), child: const Icon(Icons.image, size: 20, color: AppColors.primary))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTheme.label(size: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(subtitle, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
            ],
          )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: catColor.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
            child: Text(category, style: AppTheme.label(size: 10, color: catColor)),
          ),
        ],
      ),
    );
  }
}

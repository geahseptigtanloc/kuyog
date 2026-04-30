import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../models/event.dart';
import '../../../providers/crawl_provider.dart';
import 'crawl_spot_detail_screen.dart';

class CrawlHomeScreen extends StatefulWidget {
  const CrawlHomeScreen({super.key});

  @override
  State<CrawlHomeScreen> createState() => _CrawlHomeScreenState();
}

class _CrawlHomeScreenState extends State<CrawlHomeScreen> {
  List<CrawlEvent> _events = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ev = await MockData.getEvents();
    if (mounted) setState(() { _events = ev; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final crawl = context.watch<CrawlProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text('Mindanao Crawl', style: AppTheme.headline(size: 20)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.accent, AppColors.accentLight]),
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Your Progress', style: AppTheme.body(size: 14, color: Colors.white70)),
                              const SizedBox(height: 4),
                              Text('${crawl.stampCount} Stamps', style: AppTheme.headline(size: 28, color: Colors.white)),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: crawl.stampCount / 8,
                                backgroundColor: Colors.black.withOpacity(0.2),
                                valueColor: const AlwaysStoppedAnimation(Colors.white),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              const SizedBox(height: 8),
                              Text('${8 - crawl.stampCount} more to win rewards!', style: AppTheme.body(size: 12, color: Colors.white)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                          child: const Icon(Icons.emoji_events, size: 48, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Active Events', style: AppTheme.headline(size: 18)),
                      Text('Past Events', style: AppTheme.label(size: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._events.map((e) => _eventCard(e)),
                ],
              ),
            ),
    );
  }

  Widget _eventCard(CrawlEvent e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
            child: CachedNetworkImage(
              imageUrl: e.imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
                      child: Text(e.category, style: AppTheme.label(size: 11, color: AppColors.accent)),
                    ),
                    const Spacer(),
                    Icon(Icons.calendar_today, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(e.dateRange, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(e.name, style: AppTheme.headline(size: 18)),
                const SizedBox(height: 4),
                Text(e.description, style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CrawlSpotDetailScreen(event: e))),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.accent, side: const BorderSide(color: AppColors.accent)),
                    child: const Text('View Spots'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

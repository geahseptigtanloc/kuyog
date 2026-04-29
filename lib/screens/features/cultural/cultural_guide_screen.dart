import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class CulturalGuideScreen extends StatefulWidget {
  const CulturalGuideScreen({super.key});

  @override
  State<CulturalGuideScreen> createState() => _CulturalGuideScreenState();
}

class _CulturalGuideScreenState extends State<CulturalGuideScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text('Cultural Guide', style: AppTheme.headline(size: 20)),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                _tabItem(0, 'Language'),
                const SizedBox(width: 12),
                _tabItem(1, 'Etiquette'),
                const SizedBox(width: 12),
                _tabItem(2, 'Traditions'),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: _selectedTab == 0 ? _buildLanguageTab() : _buildContentTab(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabItem(int index, String label) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
        ),
        child: Text(label, style: AppTheme.label(size: 13, color: isSelected ? Colors.white : AppColors.textPrimary)),
      ),
    );
  }

  Widget _buildLanguageTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.touristBlue, Color(0xFF0284C7)]),
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Learn Visayan', style: AppTheme.headline(size: 20, color: Colors.white)),
                    const SizedBox(height: 8),
                    Text('Take a quick quiz to earn Kuyog Miles while learning the local tongue.', style: AppTheme.body(size: 13, color: Colors.white70)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.touristBlue),
                      child: const Text('Start Quiz'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.translate, size: 64, color: Colors.white54),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text('Essential Phrases', style: AppTheme.headline(size: 18)),
        const SizedBox(height: 16),
        _phraseCard('Good morning', 'Maayong buntag'),
        _phraseCard('Thank you', 'Salamat'),
        _phraseCard('How much?', 'Tagpila?'),
        _phraseCard('Where is the...', 'Aha ang...'),
        _phraseCard('Delicious', 'Lami'),
      ],
    );
  }

  Widget _phraseCard(String english, String local) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(english, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text(local, style: AppTheme.label(size: 16)),
            ],
          ),
          IconButton(icon: const Icon(Icons.volume_up, color: AppColors.primary), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildContentTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.xl), boxShadow: AppShadows.card),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.handshake, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Text('Respect the Locals', style: AppTheme.headline(size: 16)),
                ],
              ),
              const SizedBox(height: 16),
              Text('Mindanao is a melting pot of cultures, tribes, and religions. Always ask for permission before taking photos of indigenous people or sacred sites.', style: AppTheme.body(size: 14)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.xl), boxShadow: AppShadows.card),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.touristBlue.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.checkroom, color: AppColors.touristBlue),
                  ),
                  const SizedBox(width: 16),
                  Text('Dress Modestly', style: AppTheme.headline(size: 16)),
                ],
              ),
              const SizedBox(height: 16),
              Text('When visiting religious sites, mosques, or conservative communities, it is highly recommended to wear clothing that covers your shoulders and knees.', style: AppTheme.body(size: 14)),
            ],
          ),
        ),
      ],
    );
  }
}

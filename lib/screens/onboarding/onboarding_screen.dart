import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_logo.dart';
import '../../widgets/durie_mascot.dart';

class OnboardingScreen extends StatefulWidget {
  final Function(String role) onRoleSelected;

  const OnboardingScreen({
    super.key,
    required this.onRoleSelected,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  String _selectedRole = 'tourist';

  final _pages = [
    ('https://picsum.photos/seed/mindanao_fest/800/1200', 'Welcome to KUYOG', 'Discover exciting activities and make the most of your Mindanao experience!'),
    ('https://picsum.photos/seed/waterfall_mn/800/1200', 'Discover Activities', 'Find happenings that match your interests.'),
    ('https://picsum.photos/seed/aerial_beach2/800/1200', 'Get Involved', 'Join communities and meet like-minded people.'),
  ];

  void _nextPage() {
    if (_currentPage < 4) {
      _controller.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            children: [
              ..._pages.map((p) => _buildImagePage(p.$1, p.$2, p.$3)),
              _buildRoleSelectionPage(),
              _buildStoryPage(),
            ],
          ),
          if (_currentPage < 4)
            Positioned(
              bottom: 100, left: 0, right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i ? 24 : 8, height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i ? AppColors.accent : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
              ),
            ),
          if (_currentPage >= 3)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8, right: 16,
              child: TextButton(
                onPressed: () => widget.onRoleSelected(_selectedRole),
                child: Text('Skip', style: GoogleFonts.nunito(color: _currentPage == 4 ? AppColors.textPrimary : Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          if (_currentPage < 4)
            Positioned(
              bottom: 40, right: 24,
              child: FloatingActionButton(
                mini: true, backgroundColor: AppColors.accent, onPressed: _nextPage,
                child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePage(String imageUrl, String title, String subtitle) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover,
          placeholder: (c, u) => Container(color: AppColors.primaryDark, child: const Center(child: CircularProgressIndicator(color: Colors.white))),
          errorWidget: (c, u, e) => Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.primaryDark, AppColors.primary])))),
        Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.7)]))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Spacer(flex: 2),
            const KuyogLogo(fontSize: 42, color: Colors.white, showTagline: true),
            const SizedBox(height: 8),
            const DurieMascot(size: 70),
            const Spacer(flex: 3),
            Text(title, style: GoogleFonts.baloo2(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(subtitle, style: GoogleFonts.nunito(fontSize: 16, color: Colors.white.withOpacity(0.9), height: 1.4), textAlign: TextAlign.center),
            const Spacer(),
          ]),
        ),
      ],
    );
  }

  Widget _buildRoleSelectionPage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(imageUrl: 'https://picsum.photos/seed/lake_mtn2/800/1200', fit: BoxFit.cover,
          placeholder: (c, u) => Container(color: AppColors.primaryDark),
          errorWidget: (c, u, e) => Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.primaryDark, AppColors.primary])))),
        Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withOpacity(0.2), Colors.black.withOpacity(0.75)]))),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              const Spacer(flex: 2),
              const KuyogLogo(fontSize: 36, color: Colors.white),
              const SizedBox(height: 8),
              const DurieMascot(size: 60),
              const SizedBox(height: 20),
              Text('Who are you?', style: GoogleFonts.baloo2(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 8),
              Text('Tell us how you want to experience Mindanao.', style: GoogleFonts.nunito(fontSize: 15, color: Colors.white.withOpacity(0.85)), textAlign: TextAlign.center),
              const SizedBox(height: 32),
              _roleCard(Icons.luggage, "I'm a Tourist", 'I want to explore Mindanao', AppColors.touristBlue, () {
                setState(() => _selectedRole = 'tourist');
                _controller.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
              }),
              const SizedBox(height: 12),
              _roleCard(Icons.explore, "I'm a Tour Guide", 'I want to host travelers', AppColors.primary, () {
                setState(() => _selectedRole = 'guide');
                _controller.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
              }),
              const SizedBox(height: 12),
              _roleCard(Icons.store, "I'm a Merchant", 'I want to list my business', AppColors.merchantAmber, () {
                setState(() => _selectedRole = 'merchant');
                _controller.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
              }),
              const Spacer(flex: 3),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _roleCard(IconData icon, String label, String subtitle, Color tintColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: tintColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: tintColor.withOpacity(0.4)),
        ),
        child: Row(children: [
          Icon(icon, size: 32, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: GoogleFonts.nunito(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
            Text(subtitle, style: GoogleFonts.nunito(fontSize: 12, color: Colors.white.withOpacity(0.7))),
          ])),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 18),
        ]),
      ),
    );
  }

  Widget _buildStoryPage() {
    final photoSeeds = ['mn1', 'mn2', 'mn3', 'mn4', 'mn5', 'mn6', 'mn7', 'mn8', 'mn9'];
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const SizedBox(height: 16),
            const KuyogLogo(fontSize: 32, showTagline: false),
            const SizedBox(height: 4),
            const DurieMascot(size: 50),
            const SizedBox(height: 8),
            Text('Story of Our Journey', style: GoogleFonts.baloo2(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text('Travel with heart, travel with KUYOG.', style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.accentLight.withOpacity(0.12), borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: AppColors.accentLight.withOpacity(0.3))),
              child: Row(children: [
                const Icon(Icons.location_on, color: AppColors.accent, size: 20),
                const SizedBox(width: 10),
                Expanded(child: Text('Tip: Discover authentic Mindanaoan hospitality.', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accent))),
              ]),
            ),
            const SizedBox(height: 20),
            Text('KUYOG was born from a simple belief: that travel is best experienced together. Our name comes from the Visayan word "kuyog," meaning "to go together" — and that\'s exactly what we\'re about.\n\nWe connect curious travelers with passionate local guides who know Mindanao\'s hidden gems, vibrant festivals, and warm communities.',
              style: GoogleFonts.nunito(fontSize: 14, height: 1.6, color: AppColors.textPrimary)),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 6, mainAxisSpacing: 6),
              itemCount: 9,
              itemBuilder: (c, i) => ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: CachedNetworkImage(imageUrl: 'https://picsum.photos/seed/${photoSeeds[i]}/200/200', fit: BoxFit.cover,
                  placeholder: (c, u) => Container(color: AppColors.divider),
                  errorWidget: (c, u, e) => Container(color: AppColors.primary.withOpacity(0.1), child: const Icon(Icons.image, color: AppColors.primary, size: 24))),
              ),
            ),
            const SizedBox(height: 20),
            Text('Our mission is to promote sustainable, community-based tourism that benefits both travelers and locals. Every trip you take with KUYOG directly supports local guides, homestays, and small businesses across Mindanao.',
              style: GoogleFonts.nunito(fontSize: 14, height: 1.6, color: AppColors.textPrimary)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => widget.onRoleSelected(_selectedRole),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Get Started', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }
}

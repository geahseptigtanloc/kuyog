import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app_theme.dart';
import '../../widgets/durie_mascot.dart';
import '../../widgets/kuyog_logo.dart';
import '../../widgets/core/kuyog_button.dart';
import '../../widgets/core/kuyog_card.dart';
import '../../widgets/terms_agreement_sheet.dart';
import '../../providers/role_provider.dart';

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen>
    with TickerProviderStateMixin {
  // Intro carousel
  final PageController _introController = PageController();
  int _introPage = 0;
  bool _introComplete = false;
  static const int _introPageCount = 4;

  // Setup flow
  final PageController _pageController = PageController(initialPage: 0);
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Step 1: Account Creation
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isEmailSignup = true; // true for email, false for mobile
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());

  // Step 2: Travel Profile
  String _travelerType = ''; // 'solo' or 'group'
  String _visitorType = ''; // 'local' or 'international'

  // Step 3: Interest Selection
  final Set<String> _selectedInterests = {};
  final int _maxInterests = 10;

  // Step 4: Trip Details
  DateTime? _arrivalDate;
  DateTime? _departureDate;
  String _budgetRange = ''; // 'economy', 'standard', 'premium'
  int _numberOfPeople = 1;



  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _introController.dispose();
    _pageController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _finishIntro() {
    setState(() {
      _introComplete = true;
      _currentStep = 0;
    });
    // Ensure the setup PageView starts at the first page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    });
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }



  Future<void> _completeOnboarding() async {
    // Show celebration animation
    setState(() => _currentStep = 4); // Move to completion step
    await Future.delayed(const Duration(seconds: 2)); // Show celebration for 2 seconds

    // Show terms agreement
    await TermsAgreementSheet.checkAndShow(
      context,
      UserRole.tourist,
      () async {
        // Save onboarding data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('onboarding_completed', true);
      },
    );

    if (!mounted) return;
    GoRouter.of(context).go('/home');
  }

  @override
  Widget build(BuildContext context) {
    if (!_introComplete) {
      return _buildIntroCarousel();
    }
    return _buildSetupFlow();
  }

  // ─── INTRO CAROUSEL ───────────────────────────────────
  Widget _buildIntroCarousel() {
    final introData = [
      (
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&q=80&w=800',
        '',
        'Welcome to the heart of Mindanao tourism. Let us travel together.',
      ),
      (
        'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&q=80&w=800',
        'Discover Hidden Gems',
        'AI-matched tours, curated itineraries, and local experiences await you in Davao.',
      ),
      (
        'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&q=80&w=800',
        'Travel Together',
        'Connect with passionate local guides and fellow travelers. Experience Mindanao as it was meant to be.',
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _introController,
            onPageChanged: (i) => setState(() => _introPage = i),
            children: [
              ...introData.map((d) => _introImagePage(d.$1, d.$2, d.$3)),
              _introStoryPage(),
            ],
          ),
          // Dot indicators
          if (_introPage < _introPageCount - 1)
            Positioned(
              bottom: 110,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_introPageCount, (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _introPage == i ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _introPage == i
                        ? AppColors.accent
                        : Colors.white.withAlpha(140),
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
              ),
            ),

          // Bottom button
          Positioned(
            bottom: 50,
            left: 32,
            right: 32,
            child: _introPage < _introPageCount - 1
                ? const SizedBox.shrink()
                : KuyogButton(
                    label: 'Get Started',
                    variant: KuyogButtonVariant.primary,
                    fullWidth: true,
                    onPressed: _finishIntro,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _introImagePage(String imageUrl, String title, String subtitle) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (c, u) => Container(
            color: AppColors.primaryDark,
            child: const Center(child: CircularProgressIndicator(color: Colors.white)),
          ),
          errorWidget: (c, u, e) => Container(color: AppColors.primary),
        ),
        Container(
          color: Colors.black.withAlpha(100),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),
                const KuyogLogo(fontSize: 36, color: Colors.white),
                const SizedBox(height: 12),
                const DurieMascot(size: 64),
                const Spacer(flex: 3),
                if (title.isNotEmpty) ...[
                  Text(
                    title,
                    style: GoogleFonts.baloo2(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  subtitle,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: Colors.white.withAlpha(220),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 160),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _introStoryPage() {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 160),
          child: Column(
            children: [
              const KuyogLogo(fontSize: 36, type: KuyogLogoType.green),
              const SizedBox(height: 8),
              const DurieMascot(size: 56),
              const SizedBox(height: 12),
              Text(
                'The Story of Kuyog',
                style: GoogleFonts.baloo2(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Travel with heart, travel with KUYOG.',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              // Tip card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.accentLight.withAlpha(30),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.accentLight.withAlpha(80)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, color: AppColors.accent, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Kuyog means "to go together" in Bisaya.',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'KUYOG was born from a simple belief: that travel is best experienced together. '
                'Our name comes from the Visayan word "kuyog," meaning "to go together" — '
                'and that\'s exactly what we\'re about.\n\n'
                'We connect curious travelers with passionate local guides who know Mindanao\'s '
                'hidden gems, vibrant festivals, and warm communities.',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  height: 1.7,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              // Photo grid
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  children: List.generate(9, (i) {
                    final seeds = ['davao1','davao2','davao3','beach1','mountain1','culture1','food1','island1','sunset1'];
                    return CachedNetworkImage(
                      imageUrl: 'https://picsum.photos/seed/${seeds[i]}/200/200',
                      fit: BoxFit.cover,
                      placeholder: (c, u) => Container(color: AppColors.divider),
                      errorWidget: (c, u, e) => Container(
                        color: AppColors.primary.withAlpha(25),
                        child: const Icon(Icons.image, color: AppColors.primary, size: 20),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Our mission is to promote sustainable, community-based tourism that benefits '
                'both travelers and locals. Every trip you take with KUYOG directly supports '
                'local guides, homestays, and small businesses across Mindanao.',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  height: 1.7,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── SETUP FLOW ───────────────────────────────────────
  Widget _buildSetupFlow() {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (i) => setState(() => _currentStep = i),
            children: [
              _buildAccountCreationStep(),
              _buildTravelProfileStep(),
              _buildInterestSelectionStep(),
              _buildTripDetailsStep(),
              _buildCompletionStep(),
            ],
          ),
        ],
      ),
    );
  }



  Widget _buildAccountCreationStep() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Your Account',
                style: AppTheme.headline(size: 28),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Join thousands of travelers discovering Davao',
                style: AppTheme.body(size: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              // Full Name
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Email or Mobile
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: _isEmailSignup ? 'Email Address' : 'Mobile Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  suffixIcon: TextButton(
                    onPressed: () {
                      setState(() => _isEmailSignup = !_isEmailSignup);
                    },
                    child: Text(
                      _isEmailSignup ? 'Use Mobile' : 'Use Email',
                      style: AppTheme.body(size: 12, color: AppColors.primary),
                    ),
                  ),
                ),
                keyboardType: _isEmailSignup ? TextInputType.emailAddress : TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.lg),
              // Password
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              // Sign Up Button
              KuyogButton(
                label: 'Sign Up',
                onPressed: _nextStep,
                fullWidth: true,
              ),
              const SizedBox(height: AppSpacing.xl),
              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.divider)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      'or continue with',
                      style: AppTheme.body(size: 12, color: AppColors.textSecondary),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.divider)),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              // Social Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.g_mobiledata, color: Colors.red),
                      label: const Text('Google'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        side: const BorderSide(color: AppColors.divider),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.facebook, color: Color(0xFF1877F2)),
                      label: const Text('Facebook'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        side: const BorderSide(color: AppColors.divider),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?', style: AppTheme.body(size: 14)),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushReplacementNamed('/auth/login'),
                    child: Text('Log In', style: AppTheme.label(size: 14, color: AppColors.primary)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTravelProfileStep() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How are you visiting Davao?',
                style: GoogleFonts.baloo2(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'This helps us show you the most relevant experiences.',
                style: AppTheme.body(size: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              // Question 1
              Text(
                'Who are you traveling as?',
                style: AppTheme.label(size: 16),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _buildProfileOption(
                      title: 'Solo Traveler',
                      icon: Icons.person_outline,
                      isSelected: _travelerType == 'solo',
                      onTap: () => setState(() => _travelerType = 'solo'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildProfileOption(
                      title: 'Group (Family or Friends)',
                      icon: Icons.groups,
                      isSelected: _travelerType == 'group',
                      onTap: () => setState(() => _travelerType = 'group'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxxl),
              // Question 2
              Text(
                'Where are you from?',
                style: AppTheme.label(size: 16),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _buildProfileOption(
                      title: 'Local Davaoeño',
                      icon: Icons.home_outlined,
                      isSelected: _visitorType == 'local',
                      onTap: () => setState(() => _visitorType = 'local'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildProfileOption(
                      title: 'International Tourist',
                      icon: Icons.flight_outlined,
                      isSelected: _visitorType == 'international',
                      onTap: () => setState(() => _visitorType = 'international'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxxl),
              // Continue Button
              KuyogButton(
                label: 'Continue',
                onPressed: (_travelerType.isNotEmpty && _visitorType.isNotEmpty) ? _nextStep : null,
                variant: KuyogButtonVariant.primary,
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 120, // Force equal height
        child: KuyogCard(
          color: isSelected ? AppColors.primary : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: 2,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: isSelected ? Colors.white : AppColors.primary,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  title,
                  style: AppTheme.label(
                    size: 13,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInterestSelectionStep() {
    final interests = {
      'Nature and Outdoors': [
        'Adventure', 'Mountains', 'Hiking', 'Camping', 'Wildlife', 'Water Adventures', 'Beaches', 'Water Park', 'Extreme Sports'
      ],
      'Food and Drink': [
        'Award-Winning Cuisines', 'Recommended Cuisines', 'Fine Dining', 'Street Food', 'Desserts', 'Cafe Hopping', 'Halal Food', 'Vegetarian', 'Exotic Food', 'Night Market', 'Dining'
      ],
      'Arts and Culture': [
        'Art', 'Art and Culture', 'Architecture', 'Festivals', 'Music', 'Religious', 'Walking Tours', 'Education'
      ],
      'Lifestyle': [
        'Photography', 'Shopping', 'Wellness and Beauty', 'Night Life', 'Bars', 'Golfing', 'Sports', 'Pickleball', 'Content Seeker', 'Staycations'
      ],
      'Exploration': [
        'Hidden Gems', 'City and Urban Exploration', 'Family Oriented', 'Guided Tour', 'Specialty Coffee', 'Fashion', 'Workshop'
      ],
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What excites you most?',
                    style: GoogleFonts.baloo2(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Select exactly 10 interests. We will match you with the best Davao experiences.',
                    style: AppTheme.body(size: 14, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      '${_selectedInterests.length} / $_maxInterests selected',
                      style: AppTheme.label(size: 12, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: interests.entries.map((category) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.key,
                          style: AppTheme.label(size: 16, weight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: category.value.map((interest) {
                            final isSelected = _selectedInterests.contains(interest);
                            return FilterChip(
                              label: Text(interest),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected && _selectedInterests.length < _maxInterests) {
                                    _selectedInterests.add(interest);
                                  } else if (!selected) {
                                    _selectedInterests.remove(interest);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('You can only select exactly 10 interests. Deselect one first.'),
                                      ),
                                    );
                                  }
                                });
                              },
                              backgroundColor: isSelected ? AppColors.primary : Colors.white,
                              selectedColor: AppColors.primary,
                              checkmarkColor: Colors.white,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : AppColors.primary,
                              ),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : AppColors.primary,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: KuyogButton(
                label: 'Continue',
                onPressed: _selectedInterests.length == 10 ? _nextStep : null,
                fullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripDetailsStep() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tell us about your trip',
                style: GoogleFonts.baloo2(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              // Arrival Date
              Text(
                'Arrival Date',
                style: AppTheme.label(size: 16),
              ),
              const SizedBox(height: AppSpacing.sm),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _arrivalDate = date);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.textSecondary),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        _arrivalDate != null
                            ? '${_arrivalDate!.day}/${_arrivalDate!.month}/${_arrivalDate!.year}'
                            : 'Select arrival date',
                        style: AppTheme.body(
                          color: _arrivalDate != null ? AppColors.textPrimary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Departure Date
              Text(
                'Departure Date',
                style: AppTheme.label(size: 16),
              ),
              const SizedBox(height: AppSpacing.sm),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _arrivalDate ?? DateTime.now().add(const Duration(days: 1)),
                    firstDate: _arrivalDate ?? DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _departureDate = date);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.textSecondary),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        _departureDate != null
                            ? '${_departureDate!.day}/${_departureDate!.month}/${_departureDate!.year}'
                            : 'Select departure date',
                        style: AppTheme.body(
                          color: _departureDate != null ? AppColors.textPrimary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Budget Range
              Text(
                'Budget Range (per day)',
                style: AppTheme.label(size: 16),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  _buildBudgetOption('Economy\n(under 2,000)', 'economy'),
                  const SizedBox(width: AppSpacing.sm),
                  _buildBudgetOption('Standard\n(2,000–5,000)', 'standard'),
                  const SizedBox(width: AppSpacing.sm),
                  _buildBudgetOption('Premium\n(5,000+)', 'premium'),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              // Number of People
              Text(
                'Number of People',
                style: AppTheme.label(size: 16),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  IconButton(
                    onPressed: _numberOfPeople > 1
                        ? () => setState(() => _numberOfPeople--)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                    color: AppColors.primary,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.divider),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Text(
                      _numberOfPeople.toString(),
                      style: AppTheme.headline(size: 18),
                    ),
                  ),
                  IconButton(
                    onPressed: _numberOfPeople < 50
                        ? () => setState(() => _numberOfPeople++)
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxxl),
              // Finish Setup Button
              KuyogButton(
                label: 'Finish Setup',
                onPressed: (_arrivalDate != null && _departureDate != null && _budgetRange.isNotEmpty)
                    ? _completeOnboarding
                    : null,
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetOption(String label, String value) {
    final isSelected = _budgetRange == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _budgetRange = value),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.divider,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Text(
            label,
            style: AppTheme.body(
              size: 12,
              color: isSelected ? Colors.white : AppColors.textPrimary,
              weight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionStep() {
    return Container(
      color: AppColors.primary,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Durie celebration animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 1.0 + (value * 0.2 * (1 - value)), // Bounce effect
                  child: const DurieMascot(size: 120),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'You are all set!',
              style: GoogleFonts.baloo2(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Here is your Davao.',
              style: GoogleFonts.baloo2(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_logo.dart';
import '../../widgets/durie_mascot.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _durieController;
  late AnimationController _taglineController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _durieFade;
  late Animation<Offset> _durieSlide;
  late Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    // Logo: scale up + fade in
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    // Durie: slide up + fade in (starts after logo)
    _durieController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _durieFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _durieController, curve: Curves.easeOut),
    );
    _durieSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _durieController, curve: Curves.easeOutCubic),
    );

    // Tagline: fade in (starts after Durie)
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _taglineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeIn),
    );

    // Staggered sequence
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _durieController.forward();
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _taglineController.forward();
    });
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _durieController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.2),
            radius: 1.2,
            colors: [
              Color(0xFF4A9B55), // lighter center
              AppColors.primary,  // #3A7D44
              AppColors.primaryDark, // #2A5C32 edges
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Durie mascot
              SlideTransition(
                position: _durieSlide,
                child: FadeTransition(
                  opacity: _durieFade,
                  child: const DurieMascot(size: 80),
                ),
              ),
              const SizedBox(height: 16),
              // Logo with scale + fade
              ScaleTransition(
                scale: _logoScale,
                child: FadeTransition(
                  opacity: _logoFade,
                  child: const KuyogLogo(
                    fontSize: 56,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Tagline
              FadeTransition(
                opacity: _taglineFade,
                child: Text(
                  'Experience Davao. Your Way.',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withAlpha(179),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_theme.dart';
import '../../widgets/durie_mascot.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _fadeController;
  late Animation<double> _bounceAnim;
  late Animation<double> _fadeAnim;
  String _tagline = '';
  final String _fullTagline = 'Kuyog ta!';

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _bounceAnim = Tween<double>(begin: -30, end: 0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.bounceOut),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _bounceController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _fadeController.forward();
    });
    Future.delayed(const Duration(milliseconds: 900), () => _typeTagline());
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) widget.onComplete();
    });
  }

  void _typeTagline() async {
    for (int i = 0; i <= _fullTagline.length; i++) {
      await Future.delayed(const Duration(milliseconds: 80));
      if (mounted) setState(() => _tagline = _fullTagline.substring(0, i));
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryDark, AppColors.primary, AppColors.primaryLight],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _bounceAnim,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, _bounceAnim.value),
                child: const DurieMascot(size: 100),
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _fadeAnim,
              child: Text(
                'KUYOG',
                style: GoogleFonts.baloo2(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _tagline,
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.9),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

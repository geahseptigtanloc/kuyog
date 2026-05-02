import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_logo.dart';

class LoginSignupScreen extends StatefulWidget {
  final Function(String email) onNext;

  const LoginSignupScreen({super.key, required this.onNext});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  int _tabIndex = 0;
  final _emailController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const KuyogLogo(fontSize: 32, showTagline: true),
              const SizedBox(height: 32),
              Text(
                'Log in or sign up',
                style: GoogleFonts.nunito(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Get a Kuyog account and find your joy wherever you are or wherever you\'re going',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              // Tab switcher
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _tabIndex = 0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _tabIndex == 0 ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(
                            'Email address',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _tabIndex == 0 ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _tabIndex = 1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _tabIndex == 1 ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(
                            'Phone number',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _tabIndex == 1 ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Input field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: _tabIndex == 0 ? 'Enter your email' : 'Enter phone number',
                  prefixIcon: Icon(
                    _tabIndex == 0 ? Icons.email_outlined : Icons.phone_outlined,
                    color: AppColors.textLight,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Next step button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => widget.onNext(_emailController.text),
                  child: const Text('Next step'),
                ),
              ),
              const SizedBox(height: 24),
              // Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.divider)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Or log in with',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.divider)),
                ],
              ),
              const SizedBox(height: 20),
              // Social login buttons
              _socialButton(
                icon: Icons.facebook_rounded,
                label: 'Continue with Facebook',
                color: AppColors.facebookBlue,
                textColor: Colors.white,
                onTap: () => widget.onNext(_emailController.text),
              ),
              const SizedBox(height: 10),
              _socialButton(
                icon: Icons.g_mobiledata_rounded,
                label: 'Continue with Google',
                color: Colors.white,
                textColor: AppColors.textPrimary,
                borderColor: AppColors.divider,
                onTap: () => widget.onNext(_emailController.text),
              ),
              const SizedBox(height: 10),
              _socialButton(
                icon: Icons.apple_rounded,
                label: 'Continue with Apple',
                color: AppColors.appleDark,
                textColor: Colors.white,
                onTap: () => widget.onNext(_emailController.text),
              ),
              const SizedBox(height: 24),
              Text.rich(
                TextSpan(
                  style: GoogleFonts.nunito(fontSize: 11, color: AppColors.textSecondary),
                  children: const [
                    TextSpan(text: 'By continuing, you agree to our '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: borderColor != null ? Border.all(color: borderColor) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

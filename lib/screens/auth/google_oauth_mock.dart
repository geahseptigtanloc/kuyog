import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_theme.dart';

class GoogleOauthMockScreen extends StatelessWidget {
  final VoidCallback onAccountSelected;

  const GoogleOauthMockScreen({super.key, required this.onAccountSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Mock browser bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border(bottom: BorderSide(color: AppColors.divider)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lock_outline, size: 14, color: AppColors.success),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Text(
                        'accounts.google.com',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.more_vert, size: 18, color: AppColors.textLight),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Google logo
                    Text(
                      'G',
                      style: GoogleFonts.roboto(
                        fontSize: 48,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4285F4),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Choose an account',
                      style: GoogleFonts.roboto(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'to continue to Kuyog',
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Account 1
                    _accountTile(
                      name: 'Maria Clara',
                      email: 'maria.clara@gmail.com',
                      avatar: 'MC',
                      color: const Color(0xFF4285F4),
                      onTap: onAccountSelected,
                    ),
                    const Divider(height: 1),
                    // Account 2
                    _accountTile(
                      name: 'Leonor Rivera',
                      email: 'leonor.rivera@gmail.com',
                      avatar: 'LR',
                      color: const Color(0xFFEA4335),
                      onTap: onAccountSelected,
                    ),
                    const Divider(height: 1),
                    // Use another account
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: const Icon(Icons.person_add_outlined, size: 20, color: AppColors.textSecondary),
                      ),
                      title: Text(
                        'Use another account',
                        style: GoogleFonts.roboto(fontSize: 14, color: AppColors.textPrimary),
                      ),
                      onTap: onAccountSelected,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accountTile({
    required String name,
    required String email,
    required String avatar,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: color,
        child: Text(
          avatar,
          style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ),
      title: Text(name, style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(email, style: GoogleFonts.roboto(fontSize: 12, color: AppColors.textSecondary)),
      onTap: onTap,
    );
  }
}

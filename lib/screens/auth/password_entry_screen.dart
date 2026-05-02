import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_theme.dart';

class PasswordEntryScreen extends StatefulWidget {
  final String email;
  final String role;
  final Function(String email, String password, String role) onNext;

  const PasswordEntryScreen({
    super.key, 
    required this.email,
    required this.role,
    required this.onNext,
  });

  @override
  State<PasswordEntryScreen> createState() => _PasswordEntryScreenState();
}

class _PasswordEntryScreenState extends State<PasswordEntryScreen> {
  bool _obscure = true;
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'G',
              style: GoogleFonts.roboto(
                fontSize: 40,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF4285F4),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome',
              style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: const Color(0xFF4285F4),
                  child: Text('MC', style: GoogleFonts.roboto(color: Colors.white, fontSize: 10)),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.email,
                  style: GoogleFonts.roboto(fontSize: 14, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _passwordController,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'Enter your password',
                labelStyle: GoogleFonts.roboto(color: AppColors.textSecondary),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {},
              child: Text(
                'Forgot password?',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: const Color(0xFF4285F4),
                ),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => widget.onNext(widget.email, _passwordController.text, widget.role),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4285F4),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text('Next', style: GoogleFonts.roboto(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

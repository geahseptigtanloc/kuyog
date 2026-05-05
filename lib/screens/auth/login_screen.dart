import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_logo.dart';
import '../../data/services/auth_service.dart';
import '../../providers/role_provider.dart';
import '../../widgets/core/kuyog_button.dart';

class LoginScreen extends StatefulWidget {
  final String role;

  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;
  String? _generalError;

  String _getFriendlyErrorMessage(Object e) {
    if (e is AuthException) {
      final msg = e.message.toLowerCase();
      if (msg.contains('invalid login credentials')) {
        return 'Invalid email or password. Please try again.';
      }
      if (msg.contains('email not confirmed')) {
        return 'Please verify your email address before logging in.';
      }
      if (msg.contains('too many requests')) {
        return 'Too many attempts. Please try again later.';
      }
      return e.message;
    }
    return 'An unexpected error occurred. Please check your connection.';
  }

  void _logIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _emailError = null;
      _passwordError = null;
      _generalError = null;
    });

    bool hasError = false;
    if (email.isEmpty) {
      setState(() => _emailError = 'Email is required');
      hasError = true;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() => _emailError = 'Please enter a valid email address');
      hasError = true;
    }

    if (password.isEmpty) {
      setState(() => _passwordError = 'Password is required');
      hasError = true;
    }

    if (hasError) return;

    setState(() => _isLoading = true);

    try {
      final auth = AuthService();
      await auth.signIn(
        email: email,
        password: password,
      );

      if (context.mounted) {
        await Provider.of<RoleProvider>(context, listen: false).initialize();
        context.go('/auth/loading');
      }
    } catch (e) {
      if (context.mounted) {
        setState(() => _generalError = _getFriendlyErrorMessage(e));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(_generalError!)),
            ]),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              context.pop();
            } else {
              context.go('/auth', extra: {'role': widget.role});
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xl),
              const KuyogLogo(fontSize: 32, showTagline: false),
              const SizedBox(height: AppSpacing.xxxl),
              Text(
                'Welcome back',
                style: AppTheme.headline(size: 24),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Log in to continue planning your trip.',
                style: AppTheme.body(
                  size: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              // Email field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() => _emailError = null),
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  errorText: _emailError,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColors.textLight,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Password field
              TextField(
                controller: _passwordController,
                obscureText: _obscure,
                onChanged: (_) => setState(() => _passwordError = null),
                decoration: InputDecoration(
                  hintText: 'Password',
                  errorText: _passwordError,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.textLight,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textLight,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot password?',
                    style: AppTheme.label(
                      size: 14,
                      color: AppColors.primary,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              // Log in button
              KuyogButton(
                label: 'Log in',
                onPressed: _logIn,
                isLoading: _isLoading,
                width: double.infinity,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              // Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.divider)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Text(
                      'Or',
                      style: AppTheme.label(
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.divider)),
                ],
              ),
              const SizedBox(height: AppSpacing.xxxl),
              // Signup link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account? ',
                    style: AppTheme.body(color: AppColors.textSecondary),
                  ),
                  TextButton(
                    onPressed: () =>
                        context.go('/auth', extra: {'role': widget.role}),
                    child: Text(
                      'Sign up',
                      style: AppTheme.label(
                        color: AppColors.primary,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}


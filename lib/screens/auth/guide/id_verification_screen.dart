import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../data/services/onboarding_service.dart';
import '../../../providers/role_provider.dart';

class IdVerificationScreen extends StatefulWidget {
  final VoidCallback onNext;

  const IdVerificationScreen({super.key, required this.onNext});

  @override
  State<IdVerificationScreen> createState() => _IdVerificationScreenState();
}

class _IdVerificationScreenState extends State<IdVerificationScreen> {
  bool _isLoading = false;

  XFile? _capturedImage;

  Future<void> _handleCapture() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (image == null) return;

    setState(() {
      _capturedImage = image;
      _isLoading = true;
    });

    final roleProvider = Provider.of<RoleProvider>(context, listen: false);
    final user = roleProvider.currentUser;
    if (user == null) return;

    try {
      final onboarding = OnboardingService();
      
      // Upload ID image
      final bytes = await image.readAsBytes();
      final idUrl = await onboarding.uploadVerificationFile(
        userId: user.id,
        fileName: 'id_${image.name}',
        fileBytes: bytes,
      );

      // Save to verification table (upsert)
      await onboarding.submitGuideVerification(
        userId: user.id,
        idFrontUrl: idUrl,
      );
      
      widget.onNext();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving verification: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const Spacer(),
                  const Icon(Icons.flash_off, color: Colors.white),
                ],
              ),
            ),
            const Spacer(flex: 2),
            // Camera viewfinder
            Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 3),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Stack(
                children: [
                  // Mock ID card
                  Center(
                    child: Container(
                      width: 250,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.divider,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(Icons.person, color: AppColors.textLight),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('DRIVER\'S LICENSE', style: GoogleFonts.roboto(fontSize: 8, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                                  const SizedBox(height: 2),
                                  Text('Maria Clara Santos', style: GoogleFonts.roboto(fontSize: 11, fontWeight: FontWeight.w600)),
                                  Text('DL No: N04-12-345678', style: GoogleFonts.roboto(fontSize: 8, color: AppColors.textSecondary)),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(height: 2, color: AppColors.divider),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('DOB: 01/15/1995', style: GoogleFonts.roboto(fontSize: 8, color: AppColors.textSecondary)),
                              Text('EXP: 01/15/2028', style: GoogleFonts.roboto(fontSize: 8, color: AppColors.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Corner brackets
                  ..._cornerBrackets(),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Take a photo of your valid\nidentification card',
              style: GoogleFonts.nunito(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 3),
            // Capture button
            GestureDetector(
              onTap: _isLoading ? null : _handleCapture,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isLoading ? AppColors.textLight : AppColors.primary,
                  ),
                  child: _isLoading ? const Center(child: CircularProgressIndicator(color: Colors.white)) : null,
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  List<Widget> _cornerBrackets() {
    return [
      Positioned(top: 0, left: 0, child: _corner(true, true)),
      Positioned(top: 0, right: 0, child: _corner(true, false)),
      Positioned(bottom: 0, left: 0, child: _corner(false, true)),
      Positioned(bottom: 0, right: 0, child: _corner(false, false)),
    ];
  }

  Widget _corner(bool top, bool left) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(painter: _CornerPainter(top: top, left: left)),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool top;
  final bool left;

  _CornerPainter({required this.top, required this.left});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (top && left) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (top && !left) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (!top && left) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

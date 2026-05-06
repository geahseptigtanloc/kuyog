import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../app_theme.dart';
import '../../../models/guide.dart';

class GuideVoiceCallScreen extends StatefulWidget {
  final Guide guide;

  const GuideVoiceCallScreen({super.key, required this.guide});

  @override
  State<GuideVoiceCallScreen> createState() => _GuideVoiceCallScreenState();
}

class _GuideVoiceCallScreenState extends State<GuideVoiceCallScreen>
    with SingleTickerProviderStateMixin {
  bool _isMuted = false;
  bool _isSpeaker = false;
  int _seconds = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Simulate call timer
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _seconds++);
      return true;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final mins = _seconds ~/ 60;
    final secs = _seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),

            // KUYOG-hosted badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(20),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.shield_outlined, size: 14, color: Colors.white70),
                const SizedBox(width: 6),
                Text('KUYOG Secure Call', style: AppTheme.label(size: 11, color: Colors.white70)),
              ]),
            ),

            const SizedBox(height: 32),

            // Guide avatar with pulse
            ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withAlpha(40), width: 3),
                ),
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: AppColors.primary.withAlpha(80),
                  backgroundImage: CachedNetworkImageProvider(widget.guide.photoUrl),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(widget.guide.name,
                style: AppTheme.headline(size: 24, color: Colors.white)),
            const SizedBox(height: 4),
            Text(widget.guide.specialty,
                style: AppTheme.body(size: 14, color: Colors.white70)),

            const SizedBox(height: 16),

            // Call timer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(15),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(_formattedTime, style: AppTheme.label(size: 16, color: Colors.white)),
              ]),
            ),

            const Spacer(flex: 3),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _callAction(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    label: _isMuted ? 'Unmute' : 'Mute',
                    color: _isMuted ? AppColors.error : Colors.white.withAlpha(30),
                    onTap: () => setState(() => _isMuted = !_isMuted),
                  ),
                  _callAction(
                    icon: _isSpeaker ? Icons.volume_up : Icons.volume_down,
                    label: _isSpeaker ? 'Speaker On' : 'Speaker',
                    color: _isSpeaker ? AppColors.primary : Colors.white.withAlpha(30),
                    onTap: () => setState(() => _isSpeaker = !_isSpeaker),
                  ),
                  _callAction(
                    icon: Icons.chat_bubble_outline,
                    label: 'Chat',
                    color: Colors.white.withAlpha(30),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // End call button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 72, height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.call_end, color: Colors.white, size: 32),
              ),
            ),

            const SizedBox(height: 12),
            Text('End Call', style: AppTheme.body(size: 12, color: Colors.white70)),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _callAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTheme.body(size: 11, color: Colors.white70)),
      ]),
    );
  }
}

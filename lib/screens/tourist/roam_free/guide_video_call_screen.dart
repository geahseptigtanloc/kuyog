import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../app_theme.dart';
import '../../../models/guide.dart';

class GuideVideoCallScreen extends StatefulWidget {
  final Guide guide;

  const GuideVideoCallScreen({super.key, required this.guide});

  @override
  State<GuideVideoCallScreen> createState() => _GuideVideoCallScreenState();
}

class _GuideVideoCallScreenState extends State<GuideVideoCallScreen> {
  bool _isMuted = false;
  bool _isCameraOff = false;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
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

  String get _formattedTime {
    final mins = _seconds ~/ 60;
    final secs = _seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Guide's "video feed" (simulated with photo + gradient)
          Positioned.fill(
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.guide.bannerUrl,
                  fit: BoxFit.cover,
                  placeholder: (c, u) => Container(color: AppColors.primaryDark),
                  errorWidget: (c, u, e) => Container(color: AppColors.primaryDark),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withAlpha(80),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withAlpha(180),
                      ],
                      stops: const [0.0, 0.25, 0.6, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Top bar
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    // KUYOG badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(100),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.shield_outlined, size: 12, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text('KUYOG Secure', style: AppTheme.label(size: 10, color: Colors.white70)),
                      ]),
                    ),
                    const Spacer(),
                    // Timer
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(100),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Container(
                          width: 6, height: 6,
                          decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        Text(_formattedTime, style: AppTheme.label(size: 12, color: Colors.white)),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Guide name overlay
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 56),
                child: Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(widget.guide.name, style: AppTheme.headline(size: 20, color: Colors.white)),
                    Text(widget.guide.specialty, style: AppTheme.body(size: 13, color: Colors.white70)),
                  ]),
                ),
              ),
            ),
          ),

          // Self-view (small camera preview in corner)
          Positioned(
            top: MediaQuery.of(context).padding.top + 100,
            right: 16,
            child: Container(
              width: 100, height: 140,
              decoration: BoxDecoration(
                color: _isCameraOff ? AppColors.primaryDark : AppColors.primary.withAlpha(180),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withAlpha(60), width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(60), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Center(
                child: _isCameraOff
                    ? Column(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.videocam_off, color: Colors.white54, size: 28),
                        const SizedBox(height: 4),
                        Text('Camera off', style: AppTheme.body(size: 9, color: Colors.white54)),
                      ])
                    : Column(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.person, color: Colors.white70, size: 36),
                        const SizedBox(height: 4),
                        Text('You', style: AppTheme.label(size: 10, color: Colors.white70)),
                      ]),
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).padding.bottom + 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withAlpha(200)],
                ),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                // Action buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _controlButton(
                      icon: _isMuted ? Icons.mic_off : Icons.mic,
                      label: _isMuted ? 'Unmute' : 'Mute',
                      isActive: _isMuted,
                      onTap: () => setState(() => _isMuted = !_isMuted),
                    ),
                    _controlButton(
                      icon: _isCameraOff ? Icons.videocam_off : Icons.videocam,
                      label: _isCameraOff ? 'Camera On' : 'Camera Off',
                      isActive: _isCameraOff,
                      onTap: () => setState(() => _isCameraOff = !_isCameraOff),
                    ),
                    _controlButton(
                      icon: Icons.screen_share,
                      label: 'Share',
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Screen sharing coming soon'), behavior: SnackBarBehavior.floating),
                      ),
                    ),
                    _controlButton(
                      icon: Icons.chat_bubble_outline,
                      label: 'Chat',
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // End call
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 64, height: 64,
                    decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                    child: const Icon(Icons.call_end, color: Colors.white, size: 28),
                  ),
                ),
                const SizedBox(height: 8),
                Text('End Call', style: AppTheme.body(size: 11, color: Colors.white70)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 50, height: 50,
          decoration: BoxDecoration(
            color: isActive ? AppColors.error.withAlpha(180) : Colors.white.withAlpha(30),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTheme.body(size: 9, color: Colors.white70)),
      ]),
    );
  }
}

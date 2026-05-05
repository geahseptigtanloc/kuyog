import 'package:flutter/material.dart';
import '../app_theme.dart';

enum BadgeType { lguEndorsed, dotAccredited, businessPermit, communityCertified, communityGuide, regionalGuide, adminApproved, mindanaoMade }

class VerifiedContentBadge extends StatelessWidget {
  final BadgeType type;
  final double fontSize;
  final bool compact;

  const VerifiedContentBadge({super.key, required this.type, this.fontSize = 10, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();
    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: config.color.withAlpha(25),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: config.color.withAlpha(77), width: 0.5),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(config.icon, size: fontSize + 2, color: config.color),
          const SizedBox(width: 3),
          Text(config.label, style: AppTheme.label(size: fontSize, color: config.color)),
        ]),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withAlpha(25),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: config.color.withAlpha(77), width: 0.5),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(config.icon, size: fontSize + 4, color: config.color),
        const SizedBox(width: 4),
        Text(config.label, style: AppTheme.label(size: fontSize, color: config.color)),
      ]),
    );
  }

  _BadgeConfig _getConfig() {
    switch (type) {
      case BadgeType.lguEndorsed:
        return _BadgeConfig('LGU Endorsed', Icons.verified, AppColors.primary);
      case BadgeType.dotAccredited:
        return _BadgeConfig('DOT Accredited', Icons.shield, const Color(0xFF0D9488));
      case BadgeType.businessPermit:
        return _BadgeConfig('Business Permit Verified', Icons.business, const Color(0xFF2563EB));
      case BadgeType.communityCertified:
        return _BadgeConfig('Community Certified', Icons.people, AppColors.primary);
      case BadgeType.communityGuide:
        return _BadgeConfig('Community Guide', Icons.eco, AppColors.primary);
      case BadgeType.regionalGuide:
        return _BadgeConfig('Regional Guide', Icons.terrain, const Color(0xFF2563EB));
      case BadgeType.adminApproved:
        return _BadgeConfig('Admin-Approved Rates', Icons.check_circle, AppColors.primary);
      case BadgeType.mindanaoMade:
        return _BadgeConfig('Mindanao-Made', Icons.handshake, AppColors.accent);
    }
  }
}

class _BadgeConfig {
  final String label;
  final IconData icon;
  final Color color;
  const _BadgeConfig(this.label, this.icon, this.color);
}

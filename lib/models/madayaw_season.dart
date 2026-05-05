import 'package:flutter/material.dart';

class MadayawSeason {
  final String id;
  final String name;
  final String month;
  final String festivalAnchor;
  final String theme;
  final String duration;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final String durieVariant; // durie costume name
  final List<String> stopIds;
  final int minStampsForReward;
  final bool isActive;

  const MadayawSeason({
    required this.id,
    required this.name,
    required this.month,
    required this.festivalAnchor,
    required this.theme,
    this.duration = '3 weeks',
    this.description = '',
    this.primaryColor = const Color(0xFF3A7D44),
    this.secondaryColor = const Color(0xFFE8872A),
    this.durieVariant = 'default',
    this.stopIds = const [],
    this.minStampsForReward = 5,
    this.isActive = false,
  });

  factory MadayawSeason.fromJson(Map<String, dynamic> json) {
    return MadayawSeason(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      month: json['month'] ?? '',
      festivalAnchor: json['festivalAnchor'] ?? '',
      theme: json['theme'] ?? '',
      duration: json['duration'] ?? '3 weeks',
      description: json['description'] ?? '',
      primaryColor: Color(int.parse(json['primaryColor'] ?? '0xFF3A7D44')),
      secondaryColor: Color(int.parse(json['secondaryColor'] ?? '0xFFE8872A')),
      durieVariant: json['durieVariant'] ?? 'default',
      stopIds: List<String>.from(json['stopIds'] ?? []),
      minStampsForReward: json['minStampsForReward'] ?? 5,
      isActive: json['isActive'] ?? false,
    );
  }
}

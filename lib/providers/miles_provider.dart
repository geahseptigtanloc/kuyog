import 'package:flutter/material.dart';
import '../models/miles_activity.dart';

class MilesProvider extends ChangeNotifier {
  int _balance = 2750;
  int _displayBalance = 0;
  bool _animationComplete = false;

  int get balance => _balance;
  int get displayBalance => _displayBalance;
  bool get animationComplete => _animationComplete;

  String get currentTierName {
    if (_balance >= 10000) return 'Kuyog Champion';
    if (_balance >= 5000) return 'Explorer';
    if (_balance >= 1000) return 'Traveler';
    return 'Seedling';
  }

  String get currentTierIcon {
    if (_balance >= 10000) return 'star';
    if (_balance >= 5000) return 'mountain';
    if (_balance >= 1000) return 'leaf';
    return 'seedling';
  }

  int get currentTierIndex {
    if (_balance >= 10000) return 3;
    if (_balance >= 5000) return 2;
    if (_balance >= 1000) return 1;
    return 0;
  }

  double get tierProgress {
    if (_balance >= 10000) return 1.0;
    if (_balance >= 5000) return (_balance - 5000) / 5000;
    if (_balance >= 1000) return (_balance - 1000) / 4000;
    return _balance / 1000;
  }

  int get milesToNextTier {
    if (_balance >= 10000) return 0;
    if (_balance >= 5000) return 10000 - _balance;
    if (_balance >= 1000) return 5000 - _balance;
    return 1000 - _balance;
  }

  double get pesoEquivalent => _balance * 0.10;

  void animateBalance() {
    _displayBalance = 0;
    _animationComplete = false;
    notifyListeners();
  }

  void setDisplayBalance(int val) {
    _displayBalance = val;
    if (val >= _balance) _animationComplete = true;
    notifyListeners();
  }

  void earn(int amount) {
    _balance += amount;
    notifyListeners();
  }

  void redeem(int amount) {
    if (_balance >= amount) {
      _balance -= amount;
      notifyListeners();
    }
  }

  List<MilesTier> get tiers => const [
    MilesTier(name: 'Seedling', icon: 'seedling', minMiles: 0, maxMiles: 999,
      perks: ['Basic rewards access', 'Community events']),
    MilesTier(name: 'Traveler', icon: 'leaf', minMiles: 1000, maxMiles: 4999,
      perks: ['5% booking discount', 'Priority matching', 'Exclusive events']),
    MilesTier(name: 'Explorer', icon: 'mountain', minMiles: 5000, maxMiles: 9999,
      perks: ['10% booking discount', 'Free Crawl pass', 'VIP guide access', 'Durie merch']),
    MilesTier(name: 'Kuyog Champion', icon: 'star', minMiles: 10000, maxMiles: 99999,
      perks: ['15% all discounts', 'Free tours monthly', 'Ambassador badge', 'Exclusive merch']),
  ];

  List<MilesReward> get rewards => const [
    MilesReward(id: 'r1', name: '₱50 Voucher', photoUrl: 'https://picsum.photos/seed/voucher50/300/200', milesCost: 500),
    MilesReward(id: 'r2', name: 'Durie Tote Bag', photoUrl: 'https://picsum.photos/seed/tote_bag/300/200', milesCost: 1000),
    MilesReward(id: 'r3', name: 'Free Tour Activity', photoUrl: 'https://picsum.photos/seed/free_tour/300/200', milesCost: 2000),
    MilesReward(id: 'r4', name: 'Durie Plushie', photoUrl: 'https://picsum.photos/seed/plushie/300/200', milesCost: 3000),
    MilesReward(id: 'r5', name: 'Exclusive Crawl Pass', photoUrl: 'https://picsum.photos/seed/crawl_pass/300/200', milesCost: 5000, isAvailable: false),
  ];

  List<MilesActivity> get history => [
    MilesActivity(id: 'h1', description: 'Completed Mt. Apo Trek', miles: 150, date: 'Apr 28, 2026', type: 'earned', category: 'booking'),
    MilesActivity(id: 'h2', description: 'Posted to StoryHub', miles: 30, date: 'Apr 27, 2026', type: 'earned', category: 'post'),
    MilesActivity(id: 'h3', description: 'Redeemed ₱50 Voucher', miles: 500, date: 'Apr 25, 2026', type: 'redeemed', category: 'redeem'),
    MilesActivity(id: 'h4', description: 'Left a Review', miles: 50, date: 'Apr 24, 2026', type: 'earned', category: 'review'),
    MilesActivity(id: 'h5', description: 'Collected Crawl Stamp', miles: 100, date: 'Apr 22, 2026', type: 'earned', category: 'crawl'),
    MilesActivity(id: 'h6', description: 'Referred a Friend', miles: 200, date: 'Apr 20, 2026', type: 'earned', category: 'referral'),
    MilesActivity(id: 'h7', description: 'Completed Language Quiz', miles: 20, date: 'Apr 18, 2026', type: 'earned', category: 'quiz'),
    MilesActivity(id: 'h8', description: 'Completed Challenge: Visit 3 Waterfalls', miles: 500, date: 'Apr 15, 2026', type: 'earned', category: 'challenge'),
  ];
}

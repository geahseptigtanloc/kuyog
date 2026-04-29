import 'package:flutter/material.dart';

class MilesEntry {
  final String description;
  final int amount;
  final String icon;

  const MilesEntry({required this.description, required this.amount, required this.icon});
}

class MilesProvider extends ChangeNotifier {
  int _balance = 1240;

  final List<MilesEntry> _history = const [
    MilesEntry(description: 'Completed Siargao booking', amount: 150, icon: ''),
    MilesEntry(description: 'Left a review for Maria', amount: 50, icon: ''),
    MilesEntry(description: 'Posted to StoryHub', amount: 30, icon: ''),
    MilesEntry(description: 'Completed crawl stamp', amount: 100, icon: ''),
    MilesEntry(description: 'Completed CDO booking', amount: 150, icon: ''),
    MilesEntry(description: 'Referred a friend', amount: 200, icon: ''),
    MilesEntry(description: 'Left a product review', amount: 50, icon: ''),
    MilesEntry(description: 'Completed Mount Apo trek', amount: 150, icon: ''),
    MilesEntry(description: 'Daily login streak (7 days)', amount: 70, icon: ''),
    MilesEntry(description: 'Completed crawl stamp', amount: 100, icon: ''),
    MilesEntry(description: 'Posted to StoryHub', amount: 30, icon: ''),
    MilesEntry(description: 'App anniversary bonus', amount: 100, icon: ''),
  ];

  int get balance => _balance;
  List<MilesEntry> get history => _history;

  void addMiles(int amount) {
    _balance += amount;
    notifyListeners();
  }

  bool redeemMiles(int amount) {
    if (_balance >= amount) {
      _balance -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }
}

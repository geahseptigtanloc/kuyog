import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'dart:async';

class MockQrScanner extends StatefulWidget {
  const MockQrScanner({super.key});
  @override
  State<MockQrScanner> createState() => _MockQrScannerState();
}

class _MockQrScannerState extends State<MockQrScanner> {
  bool _scanned = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _scanned = true);
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.pop(context, true);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: _scanned ? AppColors.success : AppColors.primary, width: 4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: _scanned 
                ? const Icon(Icons.check_circle, color: AppColors.success, size: 80)
                : Stack(children: [
                    Container(color: Colors.white.withAlpha(25)),
                    const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  ]),
          ),
        ),
        Positioned(
          top: 60,
          left: 20,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 32),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        Positioned(
          bottom: 100,
          left: 0, right: 0,
          child: Center(
            child: Text(
              _scanned ? 'Stamp Collected!' : 'Scanning for Madayaw Crawl QR...',
              style: AppTheme.headline(size: 18, color: Colors.white),
            ),
          ),
        ),
      ]),
    );
  }
}

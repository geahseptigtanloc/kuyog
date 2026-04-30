import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'router.dart';
import 'providers/role_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/miles_provider.dart';
import 'providers/crawl_provider.dart';
import 'providers/chat_provider.dart';

void main() {
  runApp(const KuyogApp());
}

class KuyogApp extends StatelessWidget {
  const KuyogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoleProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => MilesProvider()),
        ChangeNotifierProvider(create: (_) => CrawlProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp.router(
        title: 'Kuyog',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

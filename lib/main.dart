import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kuyog/core/supabase/client.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'router.dart';
import 'providers/role_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/miles_provider.dart';
import 'providers/crawl_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/story_provider.dart';
import 'providers/product_provider.dart';
import 'providers/connectivity_provider.dart';
import 'providers/match_provider.dart';
import 'providers/itinerary_provider.dart';
import 'providers/travel_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/transport_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env"); // load env variables

  try {
    await AppSupabase.initialize();
    debugPrint('supabase connected');
  } catch (e) {
    debugPrint('Supabase initialization failed: $e');
  }

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
        ChangeNotifierProvider(create: (_) => StoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => MatchProvider()),
        ChangeNotifierProvider(create: (_) => ItineraryProvider()),
        ChangeNotifierProvider(create: (_) => TravelProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => TransportProvider()),
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

 import 'package:supabase_flutter/supabase_flutter.dart';
 import '../config/env.dart';
 
 class AppSupabase {
   const AppSupabase._();
 
   static bool _initialized = false;
 
   static Future<void> initialize() async {
     if (_initialized) return;
 
     Env.validate();
 
     await Supabase.initialize(
       url: Env.supabaseUrl,
       anonKey: Env.supabaseAnonKey,
     );
 
     _initialized = true;
   }
 
   static SupabaseClient get client {
     if (!_initialized) {
       throw StateError('Supabase not initialized. Call AppSupabase.initialize() first.');
     }
     return Supabase.instance.client;
   }
 
 }
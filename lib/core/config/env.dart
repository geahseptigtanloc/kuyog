import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  const Env._();

  static final String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  static final String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  static void validate() {
    if (supabaseUrl.isEmpty) {
      throw StateError('Missing SUPABASE_URL');
    }
    if (supabaseAnonKey.isEmpty) {
      throw StateError('Missing SUPABASE_ANON_KEY');
    }
  }
}

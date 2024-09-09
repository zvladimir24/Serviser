import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpRepository {
  final supabaseClient = GetIt.instance<SupabaseClient>();

  Future<void> startEmailConfirmationProcess() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isEmailConfirmationPending', true);

    final isEmailConfirmationPending =
        prefs.getBool('isEmailConfirmationPending');
    debugPrint(
        '***** isEmailConfirmationPending is set to: $isEmailConfirmationPending');
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required String fullname,
  }) async {
    try {
      final AuthResponse response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'username': username, 'fullname': fullname},
        emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
      await startEmailConfirmationProcess();

      final user = response.user;

      if (user != null) {
        debugPrint('***** Sign-up successful, user: ${user.email}');
      } else {
        debugPrint('***** Sign-up failed, no user returned.');
        throw Exception('No user returned');
      }
    } catch (e) {
      debugPrint('***** Sign-up Exception: $e');
      throw Exception('Sign-up process encountered an error: $e');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginRepository {
  final supabaseClient = GetIt.instance<SupabaseClient>();

  Future<void> loginWithSupabase(String email, String password) async {
    try {
      final AuthResponse response =
          await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;

      if (user != null && user.emailConfirmedAt != null) {
        final username = user.userMetadata?['username'] ?? 'default_username';
        final fullName = user.userMetadata?['full_name'] ?? 'default_fullname';

        // Email confirmed, check if profile exists
        await _checkAndCreateProfile(user.id, username, fullName, email);
      } else {
        debugPrint('Login failed or email not confirmed.');
        throw Exception('Please confirm your email before logging in.');
      }
    } catch (e) {
      debugPrint('Login Exception: $e');
      rethrow;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      const webClientId =
          '502709059899-mkneuaj8jsfti46mgu2sre05thpqpjpq.apps.googleusercontent.com';
      const iosClientId =
          '502709059899-0lo04lgvle4hv2budu8qd8oo5svc3hn6.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;

      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null || accessToken == null) {
        throw Exception('Google Sign-In failed. Missing tokens.');
      }

      await supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  Future<void> loginWithGoogleWeb() async {
    const redirectUri = 'my-scheme://login-callback';

    try {
      await supabaseClient.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: redirectUri,
      );
    } catch (e) {
      throw Exception('Google OAuth Web Sign-In failed: $e');
    }
  }

  Future<void> _checkAndCreateProfile(
      String userId, String username, String fullname, String email) async {
    try {
      final List<dynamic> existingProfiles =
          await supabaseClient.from('profiles').select().eq('id', userId);

      if (existingProfiles.isEmpty) {
        await supabaseClient.from('profiles').insert({
          'id': userId,
          'username': username,
          'full_name': fullname,
          'email': email,
        });
        debugPrint('Profile created successfully for $email');
      } else {
        debugPrint('Profile already exists for $email');
      }
    } catch (e) {
      debugPrint('Profile creation/check Exception: $e');
      throw Exception('Error checking/creating profile: $e');
    }
  }
}

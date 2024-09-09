import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginRepository {
  final supabaseClient = GetIt.instance<SupabaseClient>();

  Future<void> loginWithSupabase(String email, String password) async {
    try {
      // ignore: unused_local_variable
      final AuthResponse response =
          await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('Login Exception: $e');
      rethrow; // Optionally rethrow or handle error further
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

      // Supabase sign in using OAuth (for Android/iOS)
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
}

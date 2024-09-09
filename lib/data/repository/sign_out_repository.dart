import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignOutRepository {
  final supabaseClient = GetIt.instance<SupabaseClient>();

  Future<void> signOutWithSupaBase() async {
    // ignore: unused_local_variable
    final response = await supabaseClient.auth.signOut();
  }
}

import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyProfileRepository {
  final supabaseClient = GetIt.instance<SupabaseClient>();

  Future<Map<String, dynamic>> fatchProfileData(String userId) async {
    final response = await supabaseClient
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return response;
  }
}

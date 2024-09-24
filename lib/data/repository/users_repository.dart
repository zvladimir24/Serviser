import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersRepository {
  final supabaseClient = GetIt.instance<SupabaseClient>();

  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    final response =
        await supabaseClient.from('profiles').select('id, full_name');

    final List<dynamic> data = response;

    return data.map<Map<String, dynamic>>((user) {
      return {
        'id': user['id'],
        'full_name': user['full_name'],
      };
    }).toList();
  }
}

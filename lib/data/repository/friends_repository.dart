import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FriendsRepository {
  final supabaseClient = GetIt.instance<SupabaseClient>();

  // Send a friend request
  Future<void> sendFriendRequest(String senderId, String receiverId) async {
    debugPrint('Sender ID: $senderId');
    debugPrint('Receiver ID: $receiverId');

    // ignore: unused_local_variable
    final response = await supabaseClient.from('friend_requests').insert({
      'sender_id': senderId,
      'receiver_id': receiverId,
    });
  }

  // Accept a friend request
  Future<void> acceptFriendRequest(String requestId) async {
    // Update the friend request status to 'accepted'
    final updateResponse = await supabaseClient
        .from('friend_requests')
        .update({'status': 'accepted'}).eq('id', requestId);

    if (updateResponse == null) {
      throw Exception('Error accepting friend request: ');
    }

    // Get the sender and receiver IDs
    final requestResponse = await supabaseClient
        .from('friend_requests')
        .select('sender_id, receiver_id')
        .eq('id', requestId)
        .single();

    final requestData = requestResponse;
    final senderId = requestData['sender_id'];
    final receiverId = requestData['receiver_id'];

    final insertResponse = await supabaseClient.from('friends').insert([
      {'user_id': senderId, 'friend_id': receiverId},
      {'user_id': receiverId, 'friend_id': senderId},
    ]);

    if (insertResponse == null) {
      throw Exception('Error adding friends: ');
    }
  }

  // Get friends list
  Future<List<dynamic>> getFriendsList(String userId) async {
    final response = await supabaseClient
        .from('friends')
        .select('friend_id')
        .eq('user_id', userId);

    return response as List<dynamic>; // Return the list of friend IDs
  }
}

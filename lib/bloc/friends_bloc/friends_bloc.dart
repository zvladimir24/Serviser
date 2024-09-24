import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:serviser/bloc/friends_bloc/friends_bloc_event.dart';
import 'package:serviser/bloc/friends_bloc/friends_bloc_state.dart';
import 'package:serviser/data/repository/friends_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FriendsBloc extends Bloc<FriendsBlocEvent, FriendsBlocState> {
  final supabaseClient = GetIt.instance<SupabaseClient>();
  final friendsRepository = GetIt.instance<FriendsRepository>();
  FriendsBloc() : super(FriendsInitalState()) {
    on<FetchFriendsListEvent>(
        (event, emitter) => _fetchFriendsList(event, emitter));
    on<SendFriendRequestEvent>(
        (event, emitter) => _handleSendFriendRequest(event, emitter));
    on<AcceptFriendRequestEvent>(
        (event, emitter) => _handleAcceptFriendRequest(event, emitter));
  }

  Future<void> _fetchFriendsList(
      FetchFriendsListEvent event, Emitter<FriendsBlocState> emitter) async {
    try {
      emitter(FriendsLoadingState());
      //await friendsRepository.getFriendsList();
      //emitter(FriendsLoadedState());
    } catch (e) {
      debugPrint('***** Login Failure: $e');
      emitter(FriendsLodingFaildState());
    }
  }

  Future<void> _handleSendFriendRequest(
      SendFriendRequestEvent event, Emitter<FriendsBlocState> emitter) async {
    try {
      emitter(FriendsInitalState());
      final currentUser = GetIt.instance<SupabaseClient>().auth.currentUser;
      final String? senderId = currentUser?.id;
      final receiverId = event.receiverId;
      await friendsRepository.sendFriendRequest(senderId!, receiverId);
      emitter(FriendRequestSentState());
    } catch (e) {
      debugPrint('***** Login Failure: $e');
      emitter(FriendsLodingFaildState());
    }
  }

  Future<void> _handleAcceptFriendRequest(
      AcceptFriendRequestEvent event, Emitter<FriendsBlocState> emitter) async {
    try {
      emitter(FriendsInitalState());
      // await friendsRepository.acceptFriendRequest();
      emitter(FriendRequestSentState());
    } catch (e) {
      debugPrint('***** Login Failure: $e');
      emitter(FriendsLodingFaildState());
    }
  }
}

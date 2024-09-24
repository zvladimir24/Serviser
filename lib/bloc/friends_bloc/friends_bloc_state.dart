import 'package:flutter/material.dart';

@immutable
sealed class FriendsBlocState {}

final class FriendsInitalState extends FriendsBlocState {}

final class FriendsLoadingState extends FriendsBlocState {}

final class FriendsLoadedState extends FriendsBlocState {
  final List<dynamic> friendsList;

  FriendsLoadedState(this.friendsList);
}

final class FriendsLodingFaildState extends FriendsBlocState {}

final class FriendRequestSentState extends FriendsBlocState {}

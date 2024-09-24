import 'package:flutter/material.dart';

@immutable
sealed class FriendsBlocEvent {}

final class SendFriendRequestEvent extends FriendsBlocEvent {
  final String receiverId;
  SendFriendRequestEvent(this.receiverId);
}

class AcceptFriendRequestEvent extends FriendsBlocEvent {
  final String requestId;

  AcceptFriendRequestEvent(this.requestId);
}

final class FetchFriendsListEvent extends FriendsBlocEvent {
  FetchFriendsListEvent();
}

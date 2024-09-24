import 'package:flutter/material.dart';

@immutable
sealed class UsersBlocState {}

final class UsersIntialState extends UsersBlocState {}

final class UsersLoadingState extends UsersBlocState {}

final class UsersFetchedState extends UsersBlocState {
  final List<Map<String, dynamic>> usersList;
  UsersFetchedState(this.usersList);
}

final class UsersFaildState extends UsersBlocState {}

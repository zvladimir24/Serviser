import 'package:flutter/material.dart';

@immutable
sealed class MyProfileBlocEvent {}

final class FatchUserDataEvent extends MyProfileBlocEvent {
  final String userId;

  FatchUserDataEvent(this.userId);
}

import 'package:flutter/material.dart';

@immutable
sealed class SignOutBlocEvent {}

final class SignOutButtonPressed extends SignOutBlocEvent {
  SignOutButtonPressed();
}

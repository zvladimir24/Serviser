import 'package:flutter/material.dart';

@immutable
sealed class SignUpBlocEvent {}

final class SignUpInButtonPressed extends SignUpBlocEvent {
  final String username;
  final String fullname;
  final String email;
  final String password;

  SignUpInButtonPressed(
      {required this.username,
      required this.fullname,
      required this.email,
      required this.password});
}

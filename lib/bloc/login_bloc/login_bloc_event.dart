import 'package:flutter/material.dart';

@immutable
sealed class LoginBlocEvent {}

final class LoginButtonPressed extends LoginBlocEvent {
  final String email;
  final String password;

  LoginButtonPressed({required this.email, required this.password});
}

final class LoginGoogleButtonPressed extends LoginBlocEvent {}

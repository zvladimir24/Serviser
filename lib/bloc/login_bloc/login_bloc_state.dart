import 'package:flutter/material.dart';

@immutable
sealed class LoginBlocState {}

final class LoginInitial extends LoginBlocState {}

final class LoginInProgress extends LoginBlocState {}

final class LoginSuccess extends LoginBlocState {}

final class LoginFail extends LoginBlocState {}

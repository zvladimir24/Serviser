import 'package:flutter/material.dart';

@immutable
sealed class SignOutBlocState {}

final class SignOutInitial extends SignOutBlocState {}

final class SignOutInProgress extends SignOutBlocState {}

final class SignOutSuccess extends SignOutBlocState {}

final class SignOutFail extends SignOutBlocState {}

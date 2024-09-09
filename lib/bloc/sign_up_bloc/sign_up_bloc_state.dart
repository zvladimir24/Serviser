import 'package:flutter/material.dart';

@immutable
sealed class SignUpBlocState {}

final class SignUpInitial extends SignUpBlocState {}

final class SignUpInProgress extends SignUpBlocState {}

final class SignUpSuccess extends SignUpBlocState {}

final class SignUpFail extends SignUpBlocState {}

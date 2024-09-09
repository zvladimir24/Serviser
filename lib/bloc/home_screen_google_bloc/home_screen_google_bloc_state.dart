import 'package:flutter/material.dart';

@immutable
sealed class HomeScreenGoogleBlocState {}

final class HomeScreenGoogleInitial extends HomeScreenGoogleBlocState {}

final class HomeScreenGoogleInProgress extends HomeScreenGoogleBlocState {}

final class HomeScreenGoogleSuccess extends HomeScreenGoogleBlocState {}

final class HomeScreenGoogleFail extends HomeScreenGoogleBlocState {}

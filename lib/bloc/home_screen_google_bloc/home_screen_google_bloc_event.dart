import 'package:flutter/material.dart';

@immutable
sealed class HomeScreenGoogleBlocEvent {}

final class FatchGoogleData extends HomeScreenGoogleBlocEvent {
  FatchGoogleData();
}

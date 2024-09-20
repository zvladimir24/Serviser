import 'package:flutter/material.dart';

@immutable
sealed class SearchBlocEvent {}

final class SearchButtonPressed extends SearchBlocEvent {
  final String query;
  final String ll;
  final int radius;
  final int limit;

  SearchButtonPressed(
      {required this.query,
      required this.ll,
      required this.radius,
      required this.limit});
}

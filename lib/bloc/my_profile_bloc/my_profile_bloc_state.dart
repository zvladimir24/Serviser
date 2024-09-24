import 'package:flutter/material.dart';

@immutable
sealed class MyProfileBlocState {}

final class MyProfileBlocInitalState extends MyProfileBlocState {}

final class MyProfileBlocInProgressState extends MyProfileBlocState {}

final class MyProfileBlocDataFatchedState extends MyProfileBlocState {
  final Map<String, dynamic> profileData;

  MyProfileBlocDataFatchedState(this.profileData);
}

final class MyProfileBlocFaildDataFatchingState extends MyProfileBlocState {}

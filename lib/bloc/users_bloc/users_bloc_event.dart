import 'package:flutter/material.dart';

@immutable
sealed class UsersBlocEvent {}

final class FetchUsersData extends UsersBlocEvent {}

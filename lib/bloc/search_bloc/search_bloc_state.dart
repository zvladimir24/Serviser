import 'package:flutter/material.dart';
import 'package:serviser/models/fsqr_places_model.dart';

@immutable
sealed class SearchBlocState {}

final class SearchBlocInitial extends SearchBlocState {}

final class SearchBlocInProgress extends SearchBlocState {}

final class SearchBlocSuccess extends SearchBlocState {
  final ApiResponseModel response;

  SearchBlocSuccess(this.response);
}

final class SearchBlocFail extends SearchBlocState {}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:serviser/bloc/search_bloc/search_bloc_event.dart';
import 'package:serviser/bloc/search_bloc/search_bloc_state.dart';
import 'package:serviser/data/repository/search_repository.dart';
import 'package:serviser/models/fsqr_places_model.dart';

class SearchBloc extends Bloc<SearchBlocEvent, SearchBlocState> {
  final searchRepository = GetIt.instance<SearchRepository>();

  SearchBloc() : super(SearchBlocInitial()) {
    on<SearchButtonPressed>(
        (event, emitter) => _handleSearching(event, emitter));
  }

  Future<void> _handleSearching(
      SearchButtonPressed event, Emitter<SearchBlocState> emitter) async {
    try {
      debugPrint('***** Search Triggered: $event');
      emitter(SearchBlocInProgress());

      final String query = event.query;
      final String ll = event.ll;
      final int radius = event.radius;
      final int limit = event.limit;

      final ApiResponseModel response =
          await searchRepository.searchFoursquare(query, ll, radius, limit);

      debugPrint('***** Search Triggered: $query $ll $radius $limit');

      // Emitting success state with ApiResponseModel
      emitter(SearchBlocSuccess(response));

      debugPrint(
          '***** THIS IS SEARCH RESULT: ${response.places?.map((place) => place.toString()).join('\n')}');
    } catch (e) {
      debugPrint('***** Search Failure: $e');
      emitter(SearchBlocFail());
    }
  }
}

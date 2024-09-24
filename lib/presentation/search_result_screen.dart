import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviser/bloc/search_bloc/search_bloc.dart';
import 'package:serviser/bloc/search_bloc/search_bloc_state.dart';
import 'package:serviser/models/fsqr_places_model.dart';
import 'package:serviser/presentation/widgets/place_card.dart';

class SearchResultScreen extends StatelessWidget {
  const SearchResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SearchBloc, SearchBlocState>(
        builder: (context, state) {
          if (state is SearchBlocInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchBlocSuccess) {
            // Ensure that places is of type List<FsqrPlacesModel>
            final ApiResponseModel response = state.response;
            final List<FsqrPlacesModel>? places = response.places;
            final ContextModel? contextModel = response.context;

            if (places!.isNotEmpty) {
              // Access fsqId of an individual place
              final String? firstPlaceId = places[0].fsqId;
              debugPrint('First Place ID: $firstPlaceId');

              return ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  final place = places[index];
                  return PlaceCard(place: place, contextModel: contextModel);
                },
              );
            } else {
              return const Text('No places found.');
            }
          } else if (state is SearchBlocFail) {
            return const Text('Failed to load places');
          } else {
            return const Text('Start searching for places...');
          }
        },
      ),
    );
  }
}

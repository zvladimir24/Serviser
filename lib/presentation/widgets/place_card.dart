import 'package:flutter/material.dart';
import 'package:serviser/models/fsqr_places_model.dart';

class PlaceCard extends StatelessWidget {
  final FsqrPlacesModel place;
  final ContextModel? contextModel; // Include the ContextModel

  const PlaceCard({
    super.key,
    required this.place,
    this.contextModel, // Pass ContextModel
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: const Icon(Icons.place, size: 50),
        title: Text(place.name ?? 'No Name'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (place.address != null) Text('Address: ${place.address}'),
            if (place.latitude != null && place.longitude != null)
              Text('Coordinates: ${place.latitude}, ${place.longitude}'),
            Text('Radius: ${contextModel?.radius}'), // Use ContextModel
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}

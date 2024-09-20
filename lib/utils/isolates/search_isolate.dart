import 'dart:isolate';

import 'package:serviser/models/fsqr_places_model.dart';

Future<ApiResponseModel> runIsolateForParsingAndProcessing(
    Map<String, dynamic> jsonResponse) async {
  // Create a ReceivePort for communication between the isolate and main thread
  final receivePort = ReceivePort();

  // Spawn an isolate for JSON parsing and data processing
  await Isolate.spawn(_jsonParsingAndProcessingIsolate, [
    receivePort.sendPort,
    jsonResponse,
  ]);

  // Return the result from the isolate
  return await receivePort.first as ApiResponseModel;
}

// Isolate function to handle the parsing and processing
void _jsonParsingAndProcessingIsolate(List<dynamic> args) {
  final SendPort sendPort = args[0];
  final Map<String, dynamic> jsonResponse = args[1];

  // Parse the JSON response into ApiResponseModel
  final apiResponse = ApiResponseModel.fromJson(jsonResponse);

  // Process the data (e.g., filter places)
  final List<FsqrPlacesModel> processedPlaces =
      apiResponse.places?.where((place) => place.name != null).toList() ?? [];

  // Send the processed result back to the main thread
  sendPort.send(
    ApiResponseModel(places: processedPlaces, context: apiResponse.context),
  );
}

import 'dart:isolate';

import 'package:serviser/models/fsqr_places_model.dart';

Future<ApiResponseModel> runIsolateForParsingAndProcessing(
    Map<String, dynamic> jsonResponse) async {
  final receivePort = ReceivePort();

  await Isolate.spawn(_jsonParsingAndProcessingIsolate, [
    receivePort.sendPort,
    jsonResponse,
  ]);

  return await receivePort.first as ApiResponseModel;
}

void _jsonParsingAndProcessingIsolate(List<dynamic> args) {
  final SendPort sendPort = args[0];
  final Map<String, dynamic> jsonResponse = args[1];

  final apiResponse = ApiResponseModel.fromJson(jsonResponse);

  // Process the data (e.g., filter places)
  final List<FsqrPlacesModel> processedPlaces =
      apiResponse.places?.where((place) => place.name != null).toList() ?? [];

  sendPort.send(
    ApiResponseModel(places: processedPlaces, context: apiResponse.context),
  );
}

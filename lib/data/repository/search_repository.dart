import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:serviser/data/api/dio_client.dart';
import 'package:serviser/models/fsqr_places_model.dart';
import 'package:dio/dio.dart';
import 'package:serviser/utils/isolates/search_isolate.dart';

class SearchRepository {
  final dioClient = GetIt.instance<DioClient>();

  Future<ApiResponseModel> searchFoursquare(
      String query, String ll, int radius, int limit) async {
    const String apiUrl = 'https://api.foursquare.com/v3/places/search';

    final Map<String, dynamic> queryParams = {
      'query': query,
      'll': ll, // latitude, longitude
      'radius': radius,
      'limit': limit,
    };

    // Headers for Foursquare API
    final Map<String, String> headers = {
      'Authorization': dotenv.env['FOURSQUARE_API_KEY'] ?? '',
      'Accept': 'application/json',
    };

    try {
      final response = await dioClient.getDynamicMap(
        apiUrl,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );

      debugPrint('Full API Response: $response');

      // Ensure response contains 'results' and 'context'
      if (response['results'] != null && response['context'] != null) {
        // Use the isolate utility to process the data
        final ApiResponseModel apiResponse =
            await runIsolateForParsingAndProcessing(response);

        debugPrint('***** API Response Model: $apiResponse');

        return apiResponse;
      } else {
        // Handle case where 'results' or 'context' is missing
        return ApiResponseModel(places: [], context: null);
      }
    } catch (error) {
      throw Exception('Error during Foursquare search: $error');
    }
  }
}

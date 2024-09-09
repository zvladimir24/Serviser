import 'package:get_it/get_it.dart';
import 'package:serviser/data/api/dio_client.dart';

class HomeScreenGoogleRepository {
  final dio = GetIt.instance<DioClient>();

  Future<Map<String, dynamic>> getPlaceDetails(
      String placeId, String apiKey) async {
    try {
      final response = await dio.get(
        '/maps/api/place/details/json',
        queryParameters: {
          'place_id': placeId,
          'fields': 'name,formatted_address',
          'key': apiKey,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to fetch place details: $e');
    }
  }
}

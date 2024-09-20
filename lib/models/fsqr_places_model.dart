import 'package:flutter/foundation.dart';

class FsqrPlacesModel {
  final String? fsqId;
  final String? name;
  final String? address;
  final String? locality;
  final String? region;
  final String? country;
  final String? formatedAdress;
  final double? latitude;
  final double? longitude;

  FsqrPlacesModel({
    this.name,
    this.address,
    this.locality,
    this.region,
    this.country,
    this.fsqId,
    this.formatedAdress,
    this.latitude,
    this.longitude,
  });

  factory FsqrPlacesModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'] ?? {};
    final geocodes = json['geocodes']?['main'] ?? {};

    debugPrint('Latitude: ${geocodes['latitude']}');
    debugPrint('Longitude: ${geocodes['longitude']}');

    return FsqrPlacesModel(
      fsqId: json['fsq_id'] as String,
      name: json['name'] as String,
      address: location['formatted_address'] as String? ?? '',
      locality: location['locality'] as String? ?? '',
      region: location['region'] as String? ?? '',
      country: location['country'] as String? ?? '',
      formatedAdress: location['formatted_address'] as String? ?? '',
      latitude: (geocodes['latitude'] != null)
          ? (geocodes['latitude'] as num).toDouble()
          : null,
      longitude: (geocodes['longitude'] != null)
          ? (geocodes['longitude'] as num).toDouble()
          : null,
    );
  }
}

class ContextModel {
  final double? latitude;
  final double? longitude;
  final int? radius;

  ContextModel({this.latitude, this.longitude, this.radius});

  factory ContextModel.fromJson(Map<String, dynamic> json) {
    final geoBounds = json['geo_bounds']?['circle']?['center'] ?? {};

    debugPrint('Latitude: ${geoBounds['latitude']}');
    debugPrint('Longitude: ${geoBounds['longitude']}');

    return ContextModel(
      latitude: (geoBounds['center']?['latitude'] != null)
          ? (geoBounds['center']?['latitude'] as num).toDouble()
          : null,
      longitude: (geoBounds['center']?['longitude'] != null)
          ? (geoBounds['center']?['longitude'] as num).toDouble()
          : null,
      radius: json['geo_bounds']?['circle']?['radius'] as int?,
    );
  }
}

class ApiResponseModel {
  final List<FsqrPlacesModel>? places;
  final ContextModel? context;

  ApiResponseModel({this.places, this.context});

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    final placesJson = json['results'] as List<dynamic>? ?? [];
    final contextJson = json['context'] ?? {};

    return ApiResponseModel(
      places: placesJson
          .map((e) => FsqrPlacesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      context:
          contextJson.isNotEmpty ? ContextModel.fromJson(contextJson) : null,
    );
  }
}

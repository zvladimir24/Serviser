import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:serviser/utils/api_constants.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  DioClient._internal();

  final Dio dio = Dio(
    BaseOptions(
        baseUrl: ApiConstants.baseUrlHttps,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        responseType: ResponseType.json),
  )..interceptors.addAll([
      LogInterceptor(
        logPrint: (o) => debugPrint(o.toString()),
      ),
    ]);

  final Dio dioWithoutBearerAuth = Dio(
    BaseOptions(
        baseUrl: ApiConstants.baseUrlHttps,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        responseType: ResponseType.json),
  )..interceptors.add(
      LogInterceptor(
        logPrint: (o) => debugPrint(o.toString()),
      ),
    );

  Future<Map<String, dynamic>> getDynamicMap(String url,
      {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      final Response response = await dio.get(url,
          queryParameters: queryParameters, options: options);
      if (response.statusCode == 200) {
        return response.data;
      }
      throw "something went wrong";
    } catch (e) {
      rethrow;
    }
  }
}

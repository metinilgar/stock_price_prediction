import 'package:dio/dio.dart';
import 'package:finance_app/src/utils/constants/network_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  return Dio(
    BaseOptions(
        baseUrl: NetworkConstants.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        responseType: ResponseType.json),
  );
}

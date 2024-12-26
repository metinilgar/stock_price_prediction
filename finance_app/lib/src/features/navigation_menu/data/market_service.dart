import 'package:dio/dio.dart';
import 'package:finance_app/src/features/navigation_menu/models/market_data.dart';

class MarketService {
  final String baseUrl;
  late final Dio _dio;

  MarketService({required this.baseUrl}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));
  }

  Future<MarketOverviewData> getMarketOverview() async {
    try {
      final response = await _dio.get('/stock/market/overview');
      if (response.statusCode == 200) {
        return MarketOverviewData.fromMap(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Piyasa verileri alınamadı: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Piyasa verileri alınamadı: ${e.message}');
    } catch (e) {
      throw Exception('Piyasa verileri alınamadı: $e');
    }
  }
}

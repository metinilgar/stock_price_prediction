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
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ));
  }

  Future<MarketOverviewData> getMarketOverview() async {
    try {
      final response = await _dio.get('/stock/market/overview');
      if (response.statusCode == 200) {
        return MarketOverviewData.fromMap(response.data);
      } else {
        throw Exception('Piyasa verileri alınamadı: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Piyasa verileri alınamadı: ${e.message}');
    } catch (e) {
      throw Exception('Piyasa verileri alınamadı: $e');
    }
  }

  Future<List<FollowedStock>> getFollowedStocks(List<String> symbols) async {
    try {
      final response = await _dio.post('/stock/followed', data: symbols);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        return data.map((item) => FollowedStock.fromMap(item)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('Takip edilen hisseler bulunamadı');
      } else {
        throw Exception(
            'Takip edilen hisse verileri alınamadı: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw Exception(
            'Geçersiz hisse kodu formatı. Lütfen hisse kodlarını kontrol edin.');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
            'Bağlantı zaman aşımına uğradı. Lütfen tekrar deneyin.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Sunucu yanıt vermedi. Lütfen tekrar deneyin.');
      }
      throw Exception('Takip edilen hisse verileri alınamadı: ${e.message}');
    } catch (e) {
      throw Exception('Takip edilen hisse verileri alınamadı: $e');
    }
  }
}

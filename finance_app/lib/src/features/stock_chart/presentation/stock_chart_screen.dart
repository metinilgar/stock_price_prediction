import 'package:dio/dio.dart';
import 'package:finance_app/src/features/stock_chart/models/stock_data.dart';
import 'package:finance_app/src/features/stock_chart/models/stock_history_data.dart';
import 'package:finance_app/src/features/stock_chart/presentation/horizontal_period_list.dart';
import 'package:finance_app/src/features/stock_chart/presentation/stock_chart.dart';
import 'package:finance_app/src/features/stock_chart/presentation/stock_info.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StockChartScreen extends StatefulWidget {
  const StockChartScreen({super.key, required this.symbol});

  final String symbol;

  @override
  StockChartScreenState createState() => StockChartScreenState();
}

class StockChartScreenState extends State<StockChartScreen> {
  late Future<List<StockHistoryData>> _stockData;
  late Future<Map<String, dynamic>> _stockInfo;
  String _selectedPeriod = '1mo'; // Varsayılan periyot
  bool _isPredicting = false; // Tahmin işlemi devam ediyor mu kontrolü için
  bool _hasPredicted = false; // Tahmin yapılıp yapılmadığını kontrol etmek için
  List<StockData> _predictedData = []; // Tahmin edilen verileri tutmak için

  // Function to fetch stock data from the API using Dio
  Future<List<StockHistoryData>> fetchStockData(
      String symbol, String period) async {
    Dio dio = Dio();
    final response = await dio.get(
      'http://10.0.2.2:8000/stock/$symbol/history/$period',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data
          .map<StockHistoryData>((item) => StockHistoryData.fromMap(item))
          .toList();
    } else {
      throw Exception('Hisse verisi yüklenemedi');
    }
  }

  // Function to fetch stock info from the API using Dio
  Future<Map<String, dynamic>> fetchStockInfo(String symbol) async {
    Dio dio = Dio();
    final response = await dio.get('http://10.0.2.2:8000/stock/$symbol');

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Hisse bilgisi yüklenemedi');
    }
  }

  // Fiyat tahmini için API çağrısı
  Future<List<StockData>> _predictPrice() async {
    if (_isPredicting || _hasPredicted) {
      return []; // Eğer tahmin zaten yapıldıysa veya devam ediyorsa, işlemi engelle
    }

    try {
      setState(() {
        _isPredicting = true; // Tahmin başladı
      });

      Dio dio = Dio();
      final response = await dio.post(
        'http://10.0.2.2:8000/stock/predict',
        data: {'symbol': widget.symbol},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final predictions = StockData.fromPredictionList(data);

        setState(() {
          _predictedData = predictions; // Tahmin verilerini state'e kaydet
          _hasPredicted = true; // Tahmin yapıldığını işaretle
        });

        return predictions;
      }
      throw Exception('Tahmin verisi alınamadı');
    } catch (e) {
      if (!mounted) return [];

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fiyat tahmini yapılırken hata oluştu')),
      );
      rethrow;
    } finally {
      setState(() {
        _isPredicting = false; // Tahmin bitti
      });
    }
  }

  void _updatePeriod(String period) {
    setState(() {
      _selectedPeriod = period;
      _stockData = fetchStockData(widget.symbol, period);
    });
  }

  @override
  void initState() {
    super.initState();
    _stockData = fetchStockData(widget.symbol, _selectedPeriod);
    _stockInfo = fetchStockInfo(widget.symbol);
  }

  Widget _buildShimmerChart() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 320,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildShimmerInfo() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 24,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(widget.symbol),
        actions: [
          _isPredicting
              ? const CircularProgressIndicator()
              : IconButton(
                  icon: const Icon(Icons.auto_graph),
                  onPressed: _hasPredicted
                      ? null
                      : _predictPrice, // Tahmin yapıldıysa butonu devre dışı bırak
                  tooltip: _hasPredicted ? 'Tahmin Yapıldı' : 'Fiyat Tahmini',
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder<List<StockHistoryData>>(
                future: _stockData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildShimmerChart();
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Hata: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Veri bulunamadı'));
                  } else {
                    final stockData = snapshot.data!;
                    return StockChart(
                      stockData: stockData,
                      predictedData: _predictedData,
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              HorizontalPeriodList(
                selectedPeriod: _selectedPeriod,
                onPeriodSelected: _updatePeriod,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _stockInfo,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildShimmerInfo();
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Hata: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Bilgi bulunamadı'));
                    } else {
                      final stockInfo = snapshot.data!;
                      return StockInfo(stockInfo: stockInfo);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:finance_app/src/features/stock_chart/models/stock_data.dart';
import 'package:finance_app/src/features/stock_chart/presentation/stock_chart.dart';
import 'package:flutter/material.dart';

class StockChartScreen extends StatefulWidget {
  const StockChartScreen({super.key});

  @override
  _StockChartScreenState createState() => _StockChartScreenState();
}

class _StockChartScreenState extends State<StockChartScreen> {
  late Future<List<StockData>> _stockData;
  late Future<Map<String, dynamic>> _stockInfo;

  // Function to fetch stock data from the API using Dio
  Future<List<StockData>> fetchStockData(String symbol) async {
    Dio dio = Dio();
    final response = await dio.post(
      'http://10.0.2.2:8000/predict',
      data: json.encode({'symbol': symbol}),
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data['data'] as List;
      return data.map((item) => StockData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load stock data');
    }
  }

  // Function to fetch stock info from the API using Dio
  Future<Map<String, dynamic>> fetchStockInfo(String symbol) async {
    Dio dio = Dio();
    final response = await dio.get('http://10.0.2.2:8000/stock/$symbol');

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load stock info');
    }
  }

  @override
  void initState() {
    super.initState();
    // Replace 'DOAS.IS' with the stock symbol you want
    final symbol = 'DOAS.IS';
    _stockData = fetchStockData(symbol);
    _stockInfo = fetchStockInfo(symbol);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hisse Verisi Grafiği'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder<List<StockData>>(
                future: _stockData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Hata: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Veri bulunamadı'));
                  } else {
                    final stockData = snapshot.data!;
                    return StockChart(stockData: stockData);
                  }
                },
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: _stockInfo,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Hata: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('Bilgi bulunamadı'));
                      } else {
                        final stockInfo = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Şirket Adı: ${stockInfo['company_name']}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('Sektör: ${stockInfo['sector']}',
                                style: const TextStyle(fontSize: 16)),
                            Text('Endüstri: ${stockInfo['industry']}',
                                style: const TextStyle(fontSize: 16)),
                            Text('Güncel Fiyat: ${stockInfo['current_price']}',
                                style: const TextStyle(fontSize: 16)),
                            Text(
                                '52 Hafta Yüksek: ${stockInfo['52_week_high']}',
                                style: const TextStyle(fontSize: 16)),
                            Text('52 Hafta Düşük: ${stockInfo['52_week_low']}',
                                style: const TextStyle(fontSize: 16)),
                            Text('Piyasa Değeri: ${stockInfo['market_cap']}',
                                style: const TextStyle(fontSize: 16)),
                            Text('F/K Oranı: ${stockInfo['pe_ratio']}',
                                style: const TextStyle(fontSize: 16)),
                            Text(
                                'Temettü Verimi: ${stockInfo['dividend_yield']}',
                                style: const TextStyle(fontSize: 16)),
                            Text('Beta: ${stockInfo['beta']}',
                                style: const TextStyle(fontSize: 16)),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

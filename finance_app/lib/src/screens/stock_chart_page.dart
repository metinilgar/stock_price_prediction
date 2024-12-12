import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:finance_app/src/models/stock_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockChartPage extends StatefulWidget {
  @override
  _StockChartPageState createState() => _StockChartPageState();
}

class _StockChartPageState extends State<StockChartPage> {
  late Future<List<StockData>> _stockData;

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

  @override
  void initState() {
    super.initState();
    // Replace 'DOAS.IS' with the stock symbol you want
    _stockData = fetchStockData('DOAS.IS');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hisse Verisi Grafiği'),
      ),
      body: FutureBuilder<List<StockData>>(
        future: _stockData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Veri bulunamadı'));
          } else {
            final stockData = snapshot.data!;
            return SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              primaryYAxis: NumericAxis(),
              zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enablePanning: true,
                zoomMode: ZoomMode.x,
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              crosshairBehavior: CrosshairBehavior(
                enable: true,
                lineType: CrosshairLineType.both,
                activationMode: ActivationMode.singleTap,
              ),
              series: <CartesianSeries>[
                LineSeries<StockData, DateTime>(
                  dataSource: stockData,
                  xValueMapper: (StockData data, _) => data.date,
                  yValueMapper: (StockData data, _) => data.close,
                  name: 'Kapanış Fiyatı',
                  color: Colors.blue,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

import 'package:finance_app/src/features/stock_chart/models/stock_data.dart';
import 'package:finance_app/src/features/stock_chart/models/stock_history_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockChart extends StatelessWidget {
  const StockChart({
    super.key,
    required this.stockData,
    required this.predictedData,
  });

  final List<StockHistoryData> stockData;
  final List<StockData> predictedData;

  @override
  Widget build(BuildContext context) {
    // Minimum ve maksimum değerleri bul
    double minValue = double.infinity;
    double maxValue = double.negativeInfinity;

    for (var data in stockData) {
      if (data.low < minValue) minValue = data.low;
      if (data.high > maxValue) maxValue = data.high;
    }

    // Tahmin verilerini de min/max hesaplamasına dahil et
    if (predictedData.isNotEmpty) {
      for (var data in predictedData) {
        if (data.close < minValue) minValue = data.close;
        if (data.close > maxValue) maxValue = data.close;
      }
    }

    // Aralık için tampon ekle
    double range = maxValue - minValue;
    double buffer = range * 0.1; // %10 tampon

    return SfCartesianChart(
      primaryXAxis: const DateTimeAxis(),
      primaryYAxis: NumericAxis(
        minimum: minValue - buffer,
        maximum: maxValue + buffer,
        axisLine: const AxisLine(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        labelStyle: const TextStyle(fontSize: 0), // Y ekseni etiketlerini gizle
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        enablePanning: true,
        zoomMode: ZoomMode.x,
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        canShowMarker: false,
        activationMode: ActivationMode.longPress,
        format:
            'Tarih: point.x\nAçılış: point.open\nKapanış: point.close\nYüksek: point.high\nDüşük: point.low\nHacim: point.volume',
      ),
      crosshairBehavior: CrosshairBehavior(
        enable: true,
        lineType: CrosshairLineType.both,
        activationMode: ActivationMode.singleTap,
        lineColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        shouldAlwaysShow: true,
        lineWidth: 1,
      ),
      series: <CartesianSeries>[
        CandleSeries<StockHistoryData, DateTime>(
          dataSource: stockData,
          xValueMapper: (StockHistoryData data, _) => data.date,
          lowValueMapper: (StockHistoryData data, _) => data.low,
          highValueMapper: (StockHistoryData data, _) => data.high,
          openValueMapper: (StockHistoryData data, _) => data.open,
          closeValueMapper: (StockHistoryData data, _) => data.close,
          name: 'Hisse Bilgisi',
          bearColor: Colors.red,
          bullColor: Colors.green,
        ),
        if (predictedData.isNotEmpty)
          LineSeries<StockData, DateTime>(
            dataSource: predictedData,
            xValueMapper: (StockData data, _) => data.date,
            yValueMapper: (StockData data, _) => data.close,
            name: 'Tahmin',
            color: Colors.blue,
            width: 2,
            dashArray: const <double>[5, 5], // Kesikli çizgi
          ),
      ],
    );
  }
}

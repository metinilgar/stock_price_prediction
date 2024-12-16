import 'package:finance_app/src/features/stock_chart/models/stock_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockChart extends StatelessWidget {
  const StockChart({
    super.key,
    required this.stockData,
  });

  final List<StockData> stockData;

  @override
  Widget build(BuildContext context) {
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
}

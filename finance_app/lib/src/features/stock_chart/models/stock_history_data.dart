class StockHistoryData {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;

  StockHistoryData({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory StockHistoryData.fromMap(Map<String, dynamic> map) {
    return StockHistoryData(
      date: DateTime.parse(map['Date']),
      open: map['Open'].toDouble(),
      high: map['High'].toDouble(),
      low: map['Low'].toDouble(),
      close: map['Close'].toDouble(),
      volume: map['Volume'].toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Date': date.toIso8601String(),
      'Open': open,
      'High': high,
      'Low': low,
      'Close': close,
      'Volume': volume,
    };
  }
}

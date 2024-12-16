// StockData model
class StockData {
  final DateTime date;
  final double close;

  StockData(this.date, this.close);

  // Factory constructor to create StockData from JSON
  factory StockData.fromJson(Map<String, dynamic> json) {
    return StockData(
      DateTime.parse(json['Date']),
      json['Close'].toDouble(),
    );
  }

  // Method to convert StockData to JSON for use in request body (if needed)
  Map<String, dynamic> toJson() {
    return {
      'Date': date.toIso8601String(),
      'Close': close,
    };
  }
}
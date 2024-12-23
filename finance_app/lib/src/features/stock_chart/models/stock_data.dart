// StockData modeli
class StockData {
  final DateTime date;
  final double close;

  StockData(this.date, this.close);

  // JSON'dan StockData oluşturmak için factory constructor
  factory StockData.fromJson(Map<String, dynamic> json) {
    return StockData(
      DateTime.parse(json['Date']),
      json['Close'].toDouble(),
    );
  }

  // Map'ten StockData oluşturmak için factory constructor
  factory StockData.fromMap(Map<String, dynamic> map) {
    return StockData(
      DateTime.parse(map['Date']),
      map['Close'].toDouble(),
    );
  }

  // StockData'yı JSON'a dönüştürmek için metod
  Map<String, dynamic> toJson() {
    return {
      'Date': date.toIso8601String(),
      'Close': close,
    };
  }

  // Liste halindeki tahmin verilerini StockData listesine dönüştürmek için
  static List<StockData> fromPredictionList(List<dynamic> predictions) {
    return predictions
        .map((prediction) => StockData.fromMap(prediction))
        .toList();
  }
}

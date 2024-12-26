class MarketData {
  final String symbol;
  final double currentPrice;
  final double change;
  final double high;
  final double low;
  final double? volume;

  MarketData({
    required this.symbol,
    required this.currentPrice,
    required this.change,
    required this.high,
    required this.low,
    this.volume,
  });

  factory MarketData.fromMap(Map<String, dynamic> json) {
    return MarketData(
      symbol: json['symbol'] as String,
      currentPrice: (json['current_price'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      volume:
          json['volume'] != null ? (json['volume'] as num).toDouble() : null,
    );
  }
}

class MarketOverviewData {
  final MarketData? bist100;
  final MarketData? usdTry;
  final MarketData? eurTry;
  final MarketData? goldTry;

  MarketOverviewData({
    this.bist100,
    this.usdTry,
    this.eurTry,
    this.goldTry,
  });

  factory MarketOverviewData.fromMap(Map<String, dynamic> json) {
    return MarketOverviewData(
      bist100:
          json['BIST100'] != null ? MarketData.fromMap(json['BIST100']) : null,
      usdTry:
          json['USD/TRY'] != null ? MarketData.fromMap(json['USD/TRY']) : null,
      eurTry:
          json['EUR/TRY'] != null ? MarketData.fromMap(json['EUR/TRY']) : null,
    );
  }
}

class SearchModel {
  final String symbol;
  final String name;

  SearchModel({
    required this.symbol,
    required this.name,
  });

  factory SearchModel.fromMap(Map<String, dynamic> map) {
    return SearchModel(
      symbol: map['symbol'] as String,
      name: map['name'] as String,
    );
  }

  static List<SearchModel> fromMapList(List<dynamic> list) {
    return list.map((item) => SearchModel.fromMap(item)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'symbol': symbol,
      'name': name,
    };
  }
}

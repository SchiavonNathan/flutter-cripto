class CryptoCurrency {
  final String name;
  final String symbol;
  final double priceUSD;
  final double percentChange24h;
  final DateTime dateAdded;

  CryptoCurrency({
    required this.name,
    required this.symbol,
    required this.priceUSD,
    required this.percentChange24h,
    required this.dateAdded,
  });

  factory CryptoCurrency.fromJson(Map<String, dynamic> json) {
    return CryptoCurrency(
      name: json['name'] ?? 'N/A',
      symbol: json['symbol'] ?? 'N/A',
      priceUSD: json['quote']['USD']['price']?.toDouble() ?? 0.0,
      percentChange24h: json['quote']['USD']['percent_change_24h']?.toDouble() ?? 0.0,
      dateAdded: DateTime.tryParse(json['date_added'] ?? '') ?? DateTime.now(),
    );
  }
}
import '../models/crypto_model.dart';

abstract class CryptoRepository {
  Future<List<CryptoCurrency>> fetchLatestListings();
  Future<List<CryptoCurrency>> fetchQuotesForSymbols(String symbols);
  Future<double> fetchUsdToBrlRate();
}
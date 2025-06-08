import 'dart:convert';
import '../../domain/models/crypto_model.dart';
import '../../domain/repositories/crypto_repository.dart';
import '../datasources/crypto_datasource.dart';

class CryptoRepositoryImpl implements CryptoRepository {
  final CryptoDataSource dataSource;

  CryptoRepositoryImpl({required this.dataSource});

  @override
  Future<List<CryptoCurrency>> fetchLatestListings() async {
    final jsonString = await dataSource.fetchLatestListings();
    final Map<String, dynamic> jsonResponse = jsonDecode(jsonString);
    final List<dynamic> jsonList = jsonResponse['data'];
    return jsonList.map((json) => CryptoCurrency.fromJson(json)).toList();
  }

  @override
  Future<List<CryptoCurrency>> fetchQuotesForSymbols(String symbols) async {
    final jsonString = await dataSource.fetchQuotesForSymbols(symbols);
    final Map<String, dynamic> jsonResponse = jsonDecode(jsonString);

    final Map<String, dynamic> dataMap = jsonResponse['data'];

    return dataMap.values.map((json) => CryptoCurrency.fromJson(json)).toList();
  }

  @override
  Future<double> fetchUsdToBrlRate() async {
    try {
      final jsonString = await dataSource.fetchUsdToBrlRate();
      final Map<String, dynamic> jsonResponse = jsonDecode(jsonString);
      return jsonResponse['data'][0]['quote']['BRL']['price']?.toDouble() ?? 0.0;
    } catch (e) {
      throw Exception('Erro no repositório ao processar taxa de conversão: $e');
    }
  }
}
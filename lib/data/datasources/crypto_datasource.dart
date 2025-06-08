import 'package:http/http.dart' as http;
import 'dart:convert';

const String _apiKey = '7ef46057-5b17-48b5-86f6-a5c5ee396ec4';

abstract class CryptoDataSource {
  Future<String> fetchLatestListings();
  Future<String> fetchQuotesForSymbols(String symbols);
  Future<String> fetchUsdToBrlRate(); // NOVO MÉTODO
}

class CryptoRemoteDataSource implements CryptoDataSource {
  final http.Client client;
  final _baseUrl = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency';
  final _toolsUrl = 'https://pro-api.coinmarketcap.com/v2/tools';

  CryptoRemoteDataSource({required this.client});

  @override
  Future<String> fetchLatestListings() async {
    final response = await client.get(
      Uri.parse('$_baseUrl/listings/latest?convert=USD'),
      headers: {'X-CMC_PRO_API_KEY': _apiKey, 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) return response.body;
    throw Exception('Falha ao carregar listagem da API: ${response.body}');
  }

  @override
  Future<String> fetchQuotesForSymbols(String symbols) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/quotes/latest?symbol=$symbols&convert=USD'),
      headers: {'X-CMC_PRO_API_KEY': _apiKey, 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) return response.body;
    throw Exception('Falha ao buscar moedas por símbolo: ${response.body}');
  }

  @override
  Future<String> fetchUsdToBrlRate() async {
    final response = await client.get(
      Uri.parse('$_toolsUrl/price-conversion?amount=1&symbol=USD&convert=BRL'),
      headers: {'X-CMC_PRO_API_KEY': _apiKey, 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) return response.body;
    throw Exception('Falha ao buscar taxa de conversão: ${response.body}');
  }
}
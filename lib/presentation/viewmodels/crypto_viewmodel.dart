import 'package:flutter/material.dart';
import '../../domain/models/crypto_model.dart';
import '../../domain/repositories/crypto_repository.dart';

class CryptoViewModel extends ChangeNotifier {
  final CryptoRepository cryptoRepository;

  CryptoViewModel({required this.cryptoRepository});

  bool _isLoading = false;
  List<CryptoCurrency> _cryptoList = [];
  String? _errorMessage;
  String _currentQuery = '';
  double _usdToBrlRate = 0.0;

  bool get isLoading => _isLoading;
  List<CryptoCurrency> get cryptoList => _cryptoList;
  String? get errorMessage => _errorMessage;
  double get usdToBrlRate => _usdToBrlRate;

  Future<void> fetchData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _currentQuery.isEmpty
            ? cryptoRepository.fetchLatestListings()
            : cryptoRepository.fetchQuotesForSymbols(_currentQuery),
        cryptoRepository.fetchUsdToBrlRate(),
      ]);

      _cryptoList = results[0] as List<CryptoCurrency>;
      _usdToBrlRate = results[1] as double;

    } catch (e) {
      _errorMessage = e.toString();
      _cryptoList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String symbols) {
    _currentQuery = symbols.trim().toUpperCase();
    fetchData();
  }
}
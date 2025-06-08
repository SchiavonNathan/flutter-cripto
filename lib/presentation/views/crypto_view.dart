import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../domain/models/crypto_model.dart';
import '../viewmodels/crypto_viewmodel.dart';

class CryptoView extends StatefulWidget {
  const CryptoView({super.key});

  @override
  State<CryptoView> createState() => _CryptoViewState();
}

class _CryptoViewState extends State<CryptoView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CryptoViewModel>(context, listen: false).fetchData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    FocusScope.of(context).unfocus();
    await Provider.of<CryptoViewModel>(context, listen: false).fetchData();
  }

  void _showDetailsDialog(BuildContext context, CryptoCurrency crypto, double usdToBrlRate) {
    final usdFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    final brlFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dateFormatter = DateFormat('dd/MM/yyyy');

    final brlPrice = crypto.priceUSD * usdToBrlRate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(crypto.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildDetailRow('Símbolo:', crypto.symbol),
                _buildDetailRow('Adicionada em:', dateFormatter.format(crypto.dateAdded)),
                const SizedBox(height: 16),
                _buildDetailRow('Preço USD:', usdFormatter.format(crypto.priceUSD)),
                _buildDetailRow('Preço BRL:', brlFormatter.format(brlPrice)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style.copyWith(fontSize: 16),
          children: <TextSpan>[
            TextSpan(text: title, style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' $value'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usdFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    final brlFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Consumer<CryptoViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('CurrencyCoins Broker'),
            backgroundColor: Colors.deepPurple,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _refreshData,
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Ex: BTC,ETH,DOGE',
                          labelText: 'Buscar por Símbolo',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onSubmitted: (value) => viewModel.search(value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        viewModel.search(_searchController.text);
                      },
                      child: const Text('Buscar'),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: _buildBody(context, viewModel, usdFormatter, brlFormatter),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(
      BuildContext context,
      CryptoViewModel viewModel,
      NumberFormat usdFormatter,
      NumberFormat brlFormatter,
      ) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Ocorreu um erro: ${viewModel.errorMessage}'),
        ),
      );
    }
    if (viewModel.cryptoList.isEmpty) {
      return const Center(child: Text('Nenhuma moeda encontrada.'));
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: viewModel.cryptoList.length,
        itemBuilder: (context, index) {
          final crypto = viewModel.cryptoList[index];
          final usdToBrlRate = viewModel.usdToBrlRate;
          final brlPrice = crypto.priceUSD * usdToBrlRate;
          final priceChange = crypto.percentChange24h;
          final color = priceChange >= 0 ? Colors.green : Colors.red;

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  crypto.symbol.isNotEmpty ? crypto.symbol[0] : '?',
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
              ),
            ),
            title: Text('${crypto.name} (${crypto.symbol})'),
            subtitle: Text(
              'Variação 24h: ${priceChange.toStringAsFixed(2)}%',
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  usdFormatter.format(crypto.priceUSD),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                if (usdToBrlRate > 0) // Só mostra o preço em BRL se a taxa foi carregada
                  Text(
                    brlFormatter.format(brlPrice),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
              ],
            ),
            onTap: () {
              // Chama o dialog de detalhes ao tocar no item
              _showDetailsDialog(context, crypto, usdToBrlRate);
            },
          );
        },
      ),
    );
  }
}
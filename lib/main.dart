import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'data/datasources/crypto_datasource.dart';
import 'data/repositories/crypto_repository_impl.dart';
import 'domain/repositories/crypto_repository.dart';
import 'presentation/viewmodels/crypto_viewmodel.dart';
import 'presentation/views/crypto_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<http.Client>(
          create: (_) => http.Client(),
        ),
        Provider<CryptoDataSource>(
          create: (context) => CryptoRemoteDataSource(client: context.read<http.Client>()),
        ),
        Provider<CryptoRepository>(
          create: (context) => CryptoRepositoryImpl(dataSource: context.read<CryptoDataSource>()),
        ),
        ChangeNotifierProvider<CryptoViewModel>(
          create: (context) => CryptoViewModel(cryptoRepository: context.read<CryptoRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Cripto App',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const CryptoView(),
      ),
    );
  }
}
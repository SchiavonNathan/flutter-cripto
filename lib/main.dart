// lib/main.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'data/datasources/user_datasource.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';
import 'presentation/viewmodels/user_viewmodel.dart';
import 'presentation/views/user_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Para prover o ViewModel, precisamos primeiro criar suas dependências.
    return Provider<http.Client>(
      create: (_) => http.Client(),
      child: Provider<UserDataSource>(
        create: (context) => UserRemoteDataSource(client: context.read<http.Client>()),
        child: Provider<UserRepository>(
          create: (context) => UserRepositoryImpl(dataSource: context.read<UserDataSource>()),
          child: ChangeNotifierProvider<UserViewModel>(
            create: (context) => UserViewModel(userRepository: context.read<UserRepository>()),
            child: MaterialApp(
              title: 'Exemplo MVVM Completo',
              theme: ThemeData(
                primarySwatch: Colors.teal,
              ),
              home: const UserView(),
            ),
          ),
        ),
      ),
    );
  }
}
// lib/data/datasources/user_datasource.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

// Abstração para facilitar a troca de implementação ou testes (mocking)
abstract class UserDataSource {
  Future<String> fetchUsersJson();
}

class UserRemoteDataSource implements UserDataSource {
  final http.Client client;
  final _baseUrl = 'https://jsonplaceholder.typicode.com/users';

  UserRemoteDataSource({required this.client});

  @override
  Future<String> fetchUsersJson() async {
    final response = await client.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      return response.body; // Retorna o JSON bruto como uma String
    } else {
      throw Exception('Falha ao carregar os usuários da API');
    }
  }
}
// lib/data/repositories/user_repository_impl.dart
import 'dart:convert';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  // O repositório depende da abstração do DataSource, não da implementação!
  UserRepositoryImpl({required this.dataSource});

  @override
  Future<List<User>> fetchUsers() async {
    try {
      final jsonString = await dataSource.fetchUsersJson();
      final List<dynamic> jsonList = jsonDecode(jsonString);

      // Converte a lista de JSONs para uma lista de objetos User
      return jsonList.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      // Aqui você pode tratar erros de forma mais específica
      throw Exception('Erro no repositório: ${e.toString()}');
    }
  }
}
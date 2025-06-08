// lib/domain/repositories/user_repository.dart
import '../models/user_model.dart';

// O contrato que o ViewModel usará, sem saber da implementação.
abstract class UserRepository {
  Future<List<User>> fetchUsers();
}
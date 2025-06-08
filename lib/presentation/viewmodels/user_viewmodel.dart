// lib/presentation/viewmodels/user_viewmodel.dart
import 'package:flutter/material.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository userRepository;

  // Agora ele depende da abstração do repositório
  UserViewModel({required this.userRepository});

  bool _isLoading = false;
  List<User> _userList = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<User> get userList => _userList;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // A única responsabilidade do ViewModel é chamar o repositório.
      _userList = await userRepository.fetchUsers();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
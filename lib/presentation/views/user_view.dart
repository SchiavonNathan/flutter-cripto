import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/user_viewmodel.dart';

/// UserView é um StatefulWidget para que possamos usar o método `initState`.
/// O `initState` é o local ideal para disparar uma ação que deve ocorrer
/// apenas uma vez quando a tela é carregada, como buscar dados iniciais.
class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {

  // O método initState é chamado uma vez quando o widget é inserido na árvore de widgets.
  @override
  void initState() {
    super.initState();
    // Usamos `addPostFrameCallback` para garantir que o 'context' esteja totalmente
    // disponível antes de tentarmos acessá-lo. É uma forma segura de chamar
    // ações que dependem do contexto dentro do initState.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Usamos `Provider.of` com `listen: false` porque aqui estamos apenas
      // disparando uma ação (chamar o método fetchUsers). Não estamos
      // interessados em "ouvir" por mudanças neste ponto do código.
      Provider.of<UserViewModel>(context, listen: false).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários (MVVM + Repository)'),
        backgroundColor: Colors.teal,
      ),
      // O Consumer é o widget do Provider que ouve as notificações do UserViewModel.
      // Toda vez que `notifyListeners()` é chamado no ViewModel, o `builder`
      // do Consumer é executado novamente, redesenhando a UI com os novos dados.
      body: Consumer<UserViewModel>(
        builder: (context, viewModel, child) {

          // Caso 1: Se o ViewModel estiver no estado de "carregando".
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Caso 2: Se o ViewModel tiver uma mensagem de erro.
          if (viewModel.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Ocorreu um erro: ${viewModel.errorMessage}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          }

          // Caso 3: Se os dados foram carregados com sucesso.
          return ListView.builder(
            itemCount: viewModel.userList.length,
            itemBuilder: (context, index) {
              // Pega o usuário da lista fornecida pelo ViewModel.
              final user = viewModel.userList[index];

              // Constrói um ListTile para cada usuário.
              return ListTile(
                leading: CircleAvatar(
                  child: Text(user.id.toString()),
                ),
                title: Text(user.name),
                subtitle: Text(user.email),
              );
            },
          );
        },
      ),
    );
  }
}
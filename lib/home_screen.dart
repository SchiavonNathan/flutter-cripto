// Importa o pacote principal do Material Design, que contém os widgets que vamos usar.
import 'package:flutter/material.dart';

// Cria a classe da nossa tela, que é um StatelessWidget.
class HomeScreen extends StatelessWidget {
  // O construtor é opcional para stateless widgets, mas é uma boa prática.
  const HomeScreen({super.key});

  // O método build é obrigatório. É ele quem descreve a aparência do widget.
  // Ele é chamado pelo Flutter sempre que o widget precisa ser desenhado na tela.
  @override
  Widget build(BuildContext context) {
    // Retornamos um Scaffold, que é a estrutura básica de uma tela no Material Design.
    return Scaffold(
      // A barra no topo da tela.
      appBar: AppBar(
        title: const Text('Página Inicial'),
        backgroundColor: Colors.blueAccent, // Cor da barra
      ),
      // O corpo principal da tela.
      body: const Center( // Center é um widget que centraliza seu filho.
        child: Text(
          'Bem-vindo à minha primeira tela!',
          style: TextStyle(fontSize: 24), // Estilizando o texto
        ),
      ),
    );
  }
}
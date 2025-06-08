# App de Cotação de Criptomoedas com Flutter

Um aplicativo desenvolvido em Flutter que exibe cotações das principais criptomoedas em tempo real, consumindo a API da CoinMarketCap. O projeto foi estruturado utilizando a arquitetura MVVM+R para garantir um código limpo, escalável e testável.

## 📷 Screenshots

| Tela Principal | Detalhes da Moeda |
| :---: | :---: |
| ![Tela Principal com a lista de moedas](docs/Tela-Principal.png) | ![Dialog com os detalhes de uma moeda](docs/Tela-Modal.png) |
| *Listagem com busca, cotação em USD/BRL e variação.* | *Dialog modal com informações detalhadas.* |

## ✨ Funcionalidades

- **Listagem em Tempo Real:** Exibe as principais criptomoedas com dados atualizados.
- **Cotação Dupla:** Mostra os preços em Dólar (USD) e Real (BRL).
- **Taxa de Conversão Dinâmica:** Busca a taxa de conversão USD-BRL em tempo real para garantir a precisão dos valores.
- **Atualização de Dados:**
  - Gesto de "Puxar para atualizar" (Pull-to-Refresh).
  - Botão de atualização na barra de aplicativos.
- **Pesquisa Avançada:** Campo para pesquisar uma ou mais moedas por seus símbolos (ex: `BTC,ETH,XRP`).
- **Detalhes da Moeda:** Ao clicar em uma moeda, um dialog exibe informações adicionais como nome, símbolo, data de adição e cotações formatadas.
- **Interface Reativa:** Tratamento de estados de UI para carregamento (loading), sucesso e erro.

## 🏗️ Arquitetura

Este projeto utiliza uma arquitetura limpa, inspirada no **MVVM (Model-View-ViewModel)**, com a adição das camadas de **Repository** e **DataSource**.

**Fluxo de Dados:**

`View` ↔️ `ViewModel` → `Repository` → `DataSource` → `API Externa`

- **View:** Camada de apresentação (Widgets do Flutter). Apenas exibe o estado e notifica o ViewModel sobre as interações do usuário.
- **ViewModel:** Contém a lógica de apresentação e o estado da UI. Atua como um intermediário entre a View e o Repository.
- **Repository:** Orquestra a obtenção de dados de diferentes fontes (neste caso, o DataSource da API). É responsável por transformar os dados brutos em modelos que a aplicação entende.
- **DataSource:** Camada de acesso a dados. Sua única responsabilidade é se comunicar diretamente com a fonte de dados (a API da CoinMarketCap).

Essa separação de responsabilidades torna o código mais organizado, fácil de manter e de testar.

## 🚀 Tecnologias e Pacotes

- **[Flutter](https://flutter.dev/)**: Framework principal para construção da UI.
- **[Dart](https://dart.dev/)**: Linguagem de programação.
- **[provider](https://pub.dev/packages/provider)**: Para gerenciamento de estado e injeção de dependência de forma simples e eficiente.
- **[http](https://pub.dev/packages/http)**: Para realizar as chamadas HTTP para a API da CoinMarketCap.
- **[intl](https://pub.dev/packages/intl)**: Para formatação de números como moeda (USD/BRL) e formatação de datas.

## ⚙️ Como Executar o Projeto

Siga os passos abaixo para executar o projeto em sua máquina local.

### Pré-requisitos

- Ter o [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado e configurado em seu PATH.
- Um editor de código como [VS Code](https://code.visualstudio.com/) ou [Android Studio](https://developer.android.com/studio).
- Um emulador Android, simulador iOS ou um dispositivo físico conectado.

### Passos para Instalação

1.  **Clone o repositório:**
    ```sh
    git clone https://github.com/SchiavonNathan/flutter-cripto-broker
    cd seu-repositorio
    ```

2.  **Instale as dependências:**
    ```sh
    flutter pub get
    ```

3.  **Configure a Chave da API:**

    > ⚠️ **IMPORTANTE:** Este projeto requer uma chave de API da CoinMarketCap.
    >
    > 1.  Obtenha sua chave de API gratuita em [https://pro.coinmarketcap.com/](https://pro.coinmarketcap.com/).
    > 2.  Abra o arquivo: `lib/data/datasources/crypto_datasource.dart`.
    > 3.  Localize a constante `_apiKey` e substitua o valor do placeholder pela sua chave:
    >
    >     ```dart
    >     // Antes
    >     const String _apiKey = 'SUA_NOVA_CHAVE_API_AQUI';
    >
    >     // Depois
    >     const String _apiKey = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx';
    >     ```

4.  **Execute o aplicativo:**
    ```sh
    flutter run
    ```

## 📁 Estrutura de Pastas

O projeto segue uma estrutura de pastas organizada por camadas para facilitar a navegação e a manutenção.

- `lib/`
  - `data/`
    - `datasources/`
      - `crypto_datasource.dart` # Comunicação direta com a API
    - `repositories/`
      - `crypto_repository_impl.dart` # Implementação do repositório
  - `domain/`
    - `models/`
      - `crypto_model.dart` # Modelo de dados da criptomoeda
    - `repositories/`
      - `crypto_repository.dart` # Contrato (interface) do repositório
  - `presentation/`
    - `viewmodels/`
      - `crypto_viewmodel.dart` # Lógica de estado e apresentação
    - `views/`
      - `crypto_view.dart` # Widgets e UI da tela
  - `main.dart` # Ponto de entrada e injeção de dependência

---

*Este projeto foi desenvolvido como um exercício prático para demonstrar a arquitetura MVVM+R em Flutter.*

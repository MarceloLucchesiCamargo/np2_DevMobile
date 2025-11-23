// =============================================================
// ARQUIVO: lib/main.dart
// =============================================================
//
// OBJETIVO GERAL
// --------------
// - Definir o ponto de entrada da aplicação Flutter (main()).
// - Criar uma instância única de AppState (estado global).
// - Configurar o MaterialApp com tema, rotas nomeadas e tela inicial.
//
// RELAÇÃO COM OUTROS ARQUIVOS
// ---------------------------
// - Usa:
//     * estado/app_state.dart  → estado global (usuário, carrinho, endereço).
//     * rotas.dart             → nomes das rotas nomeadas do app.
//     * pages/login_page.dart  → tela inicial (login).
//     * pages/registro_page.dart
//     * pages/loja_page.dart
//     * pages/detalhes_produto_page.dart
//     * pages/carrinho_page.dart
//     * pages/perfil_page.dart
//
// COMO ESTE ARQUIVO É USADO
// -------------------------
// - A função main() é chamada automaticamente pelo Flutter quando o app inicia.
// - O runApp() recebe a raiz do app: LojaFakeMegaStoreApp.
//
// INFORMAÇÕES GERAIS
// ------------------
// - Este projeto é acadêmico, sem backend real.
// - O estado é mantido em memória por AppState enquanto o app está aberto.
// =============================================================

import 'package:flutter/material.dart';

import 'estado/app_state.dart';
import 'rotas.dart';
import 'pages/login_page.dart';
import 'pages/registro_page.dart';
import 'pages/loja_page.dart';
import 'pages/detalhes_produto_page.dart';
import 'pages/carrinho_page.dart';
import 'pages/perfil_page.dart';
import 'modelos/produto.dart';

void main() {
  runApp(const LojaFakeMegaStoreApp());
}

// CLASSE: LojaFakeMegaStoreApp
// ----------------------------
// PARA QUE SERVE:
// - Ser o widget raiz da aplicação (passado para runApp).
// - Criar e manter UMA instância de AppState para todo o app.
// - Configurar o MaterialApp (tema, rotas, etc.).
//
// QUEM USA / ONDE:
// - Usada diretamente em main() → runApp(const LojaFakeMegaStoreApp()).
//
// INFORMAÇÕES IMPORTANTES:
// - AppState é criado aqui e reaproveitado em todas as rotas, garantindo
//   que o mesmo carrinho, usuário e endereço sejam compartilhados.
class LojaFakeMegaStoreApp extends StatelessWidget {
  const LojaFakeMegaStoreApp({super.key});

  // INSTÂNCIA GLOBAL SIMPLIFICADA DO ESTADO
  //
  // PARA QUE SERVE:
  // - Guardar o estado compartilhado entre telas (usuário, carrinho, etc.).
  //
  // POR QUE AQUI:
  // - Como este widget é o "topo" do app, esta instância é criada uma vez
  //   só e passada para todas as páginas nas rotas.
  static final AppState appState = AppState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loja Fake MegaStore',
      debugShowCheckedModeBanner: false,

      // TEMA SIMPLES: azul como cor principal
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      // Rota inicial do app: tela de login
      initialRoute: RotasApp.loginPage,

      // REGISTRO DAS ROTAS NOMEADAS
      //
      // PARA QUE SERVE:
      // - Dizer ao MaterialApp como construir cada tela a partir de um nome.
      routes: {
        RotasApp.loginPage: (context) => LoginPage(appState: appState),
        RotasApp.registroPage: (context) => RegistroPage(appState: appState),
        RotasApp.lojaPage: (context) => LojaPage(appState: appState),
        RotasApp.carrinhoPage: (context) => CarrinhoPage(appState: appState),
        RotasApp.perfilPage: (context) => PerfilPage(appState: appState),
      },

      // onGenerateRoute:
      // - Usado quando precisamos passar argumentos (ex.: produto selecionado).
      onGenerateRoute: (settings) {
        if (settings.name == RotasApp.detalhesProdutoPage) {
          // Esperamos receber um Produto em settings.arguments.
          final produto = settings.arguments as Produto;
          return MaterialPageRoute(
            builder: (context) =>
                DetalhesProdutoPage(produto: produto, appState: appState),
          );
        }

        // Se a rota não for reconhecida, cai no login.
        return MaterialPageRoute(
          builder: (context) => LoginPage(appState: appState),
        );
      },
    );
  }
}

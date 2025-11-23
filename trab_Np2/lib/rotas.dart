// =============================================================
// ARQUIVO: lib/rotas.dart
// =============================================================
//
// OBJETIVO GERAL
// --------------
// - Centralizar os nomes de todas as rotas nomeadas do app.
// - Evitar uso de "strings mágicas" espalhadas, como '/loja-page' solto.
//
// RELAÇÃO COM OUTROS ARQUIVOS
// ---------------------------
// - Usado por:
//     * main.dart        → registro das rotas no MaterialApp.
//     * todas as pages   → navegação com Navigator.pushNamed/pushReplacement.
//
// COMO ESTE ARQUIVO É USADO
// -------------------------
// - Ao navegar, usamos, por exemplo:
//       Navigator.pushNamed(context, RotasApp.lojaPage);
//
// INFORMAÇÕES GERAIS
// ------------------
// - Facilita manutenção: se o caminho mudar, alteramos apenas aqui.
// =============================================================

class RotasApp {
  // Tela de login (primeira tela do app)
  //
  // PARA QUE SERVE:
  // - Identificar a rota da tela de login.
  //
  // QUEM USA / ONDE:
  // - main.dart (initialRoute).
  // - LoginPage pode ser reapontada a partir de logout.
  static const String loginPage = '/login-page';

  // Tela de registro de novo usuário
  static const String registroPage = '/registro-page';

  // Tela principal da loja (lista de produtos da FakeStoreAPI)
  static const String lojaPage = '/loja-page';

  // Tela de detalhes de um produto específico
  static const String detalhesProdutoPage = '/detalhes-produto-page';

  // Tela do carrinho de compras
  static const String carrinhoPage = '/carrinho-page';

  // Tela de perfil do usuário (dados básicos + endereço + sair)
  static const String perfilPage = '/perfil-page';
}

// =============================================================
// ARQUIVO: lib/estado/app_state.dart
// =============================================================
//
// OBJETIVO GERAL
// --------------
// - Representar o ESTADO GLOBAL da aplicação Fake MegaStore.
// - Centralizar:
//     * dados do usuário (nome, e-mail)
//     * dados de endereço de entrega
//     * itens no carrinho de compras
// - Oferecer funções para manipular esse estado (login, logout, carrinho).
//
// RELAÇÃO COM OUTROS ARQUIVOS
// ---------------------------
// - Usado por:
//     * main.dart           → cria uma instância única de AppState.
//     * login_page.dart     → fazerLogin.
//     * perfil_page.dart    → atualizarPerfil, fazerLogout.
//     * carrinho_page.dart  → manipular itens do carrinho.
//     * loja_page.dart      → ler quantidadeTotalCarrinho.
//     * detalhes_produto_page.dart → adicionar itens ao carrinho.
//
// COMO ESTE ARQUIVO É USADO
// -------------------------
// - Importado nas telas que precisam ler ou modificar dados globais.
// - Passado pelo construtor das páginas como parâmetro (appState).
//
// INFORMAÇÕES GERAIS
// ------------------
// - Não há persistência real (sem banco de dados).
// - Os dados existem apenas em memória enquanto o app está aberto.
// =============================================================

import '../modelos/produto.dart';

// CLASSE: AppState
// ----------------
// PARA QUE SERVE:
// - Guardar em memória o estado principal do app inteiro.
// - Substitui temporariamente aquilo que, em produção, seria um backend
//   + armazenamento local + controle de sessão.
//
// QUEM USA / ONDE:
// - Criada em main.dart e passada para as telas via construtor.
// - Telas leem e alteram o estado chamando os métodos desta classe.
class AppState {
  // =========================
  // DADOS DO USUÁRIO LOGADO
  // =========================

  // Nome do usuário
  //
  // PARA QUE SERVE:
  // - Exibir em telas de perfil ou saudação.
  String? nomeUsuario;

  // E-mail do usuário
  //
  // PARA QUE SERVE:
  // - Identificar o usuário logado.
  // - Exibir na tela de perfil.
  String? emailUsuario;

  // ===============================
  // ENDEREÇO PARA ENTREGA (OPCIONAL)
  // ===============================
  String? cidadeEntrega;
  String? estadoEntrega;
  String? cepEntrega;
  String? bairroEntrega;
  String? ruaEntrega;
  String? numeroEntrega;

  // =========================
  // CARRINHO DE COMPRAS
  // =========================

  // Lista interna de itens no carrinho.
  //
  // PARA QUE SERVE:
  // - Guardar todos os produtos que o usuário adicionou ao carrinho.
  //
  // INFORMAÇÕES IMPORTANTES:
  // - Cada inserção adiciona um Produto na lista.
  // - Se um produto é adicionado 3 vezes, ele aparece 3 vezes aqui
  //   (a contagem é feita na tela do carrinho).
  final List<Produto> _itensCarrinho = [];

  // Getter somente leitura para a lista.
  List<Produto> get itensCarrinho => List.unmodifiable(_itensCarrinho);

  // =============================================================
  // MÉTODOS RELACIONADOS A LOGIN / PERFIL
  // =============================================================

  // MÉTODO: fazerLogin
  //
  // PARA QUE SERVE:
  // - Registrar o e-mail do usuário que entrou no sistema.
  //
  // QUEM USA / ONDE:
  // - LoginPage → ao clicar no botão "Entrar".
  void fazerLogin(String email) {
    emailUsuario = email;
  }

  // MÉTODO: fazerLogout
  //
  // PARA QUE SERVE:
  // - Limpar todos os dados de usuário e carrinho.
  //
  // QUEM USA / ONDE:
  // - PerfilPage → ao clicar em "Sair da conta".
  void fazerLogout() {
    nomeUsuario = null;
    emailUsuario = null;
    cidadeEntrega = null;
    estadoEntrega = null;
    cepEntrega = null;
    bairroEntrega = null;
    ruaEntrega = null;
    numeroEntrega = null;
    _itensCarrinho.clear();
  }

  // MÉTODO: atualizarPerfil
  //
  // PARA QUE SERVE:
  // - Atualizar os dados de perfil (nome, e-mail, endereço).
  //
  // QUEM USA / ONDE:
  // - PerfilPage → ao clicar em "Salvar alterações".
  void atualizarPerfil({
    required String nome,
    required String email,
    required String cidade,
    required String estado,
    required String cep,
    required String bairro,
    required String rua,
    required String numero,
  }) {
    nomeUsuario = nome;
    emailUsuario = email;
    cidadeEntrega = cidade;
    estadoEntrega = estado;
    cepEntrega = cep;
    bairroEntrega = bairro;
    ruaEntrega = rua;
    numeroEntrega = numero;
  }

  // =============================================================
  // MÉTODOS RELACIONADOS AO CARRINHO
  // =============================================================

  // MÉTODO: adicionarAoCarrinho
  //
  // PARA QUE SERVE:
  // - Inserir um produto na lista interna de itens do carrinho.
  //
  // QUEM USA / ONDE:
  // - DetalhesProdutoPage (botão "Adicionar ao carrinho").
  // - CarrinhoPage (botão "+").
  void adicionarAoCarrinho(Produto produto) {
    _itensCarrinho.add(produto);
  }

  // MÉTODO: removerUmaUnidadeDoCarrinho
  //
  // PARA QUE SERVE:
  // - Remover apenas UMA unidade do produto informado.
  //
  // QUEM USA / ONDE:
  // - CarrinhoPage (botão "-").
  void removerUmaUnidadeDoCarrinho(Produto produto) {
    final index = _itensCarrinho.indexWhere((p) => p.id == produto.id);
    if (index != -1) {
      _itensCarrinho.removeAt(index);
    }
  }

  // MÉTODO: removerTodasUnidadesDoProduto
  //
  // PARA QUE SERVE:
  // - Remover TODAS as unidades de um produto específico do carrinho.
  //
  // USO ATUAL:
  // - Não usado nas telas atuais, mas disponível para futuras melhorias.
  void removerTodasUnidadesDoProduto(Produto produto) {
    _itensCarrinho.removeWhere((p) => p.id == produto.id);
  }

  // MÉTODO: esvaziarCarrinho
  //
  // PARA QUE SERVE:
  // - Limpar completamente o carrinho.
  //
  // QUEM USA / ONDE:
  // - CarrinhoPage (botão "Esvaziar carrinho").
  // - Finalizar compra (após confirmar a compra simulada).
  void esvaziarCarrinho() {
    _itensCarrinho.clear();
  }

  // GETTER: totalCarrinho
  //
  // PARA QUE SERVE:
  // - Calcular o valor total atualizado do carrinho em reais.
  //
  // QUEM USA / ONDE:
  // - CarrinhoPage → exibir o valor total na parte inferior.
  double get totalCarrinho {
    return _itensCarrinho.fold(
      0.0,
      (total, produto) => total + produto.preco,
    );
  }

  // GETTER: quantidadeTotalCarrinho
  //
  // PARA QUE SERVE:
  // - Informar o número total de itens (unidades) no carrinho.
  //
  // QUEM USA / ONDE:
  // - LojaPage → bolinha vermelha no ícone do carrinho (badge).
  int get quantidadeTotalCarrinho => _itensCarrinho.length;

  // Mantido por compatibilidade com nomes anteriores.
  void removerDoCarrinho(Produto produto) {
    removerUmaUnidadeDoCarrinho(produto);
  }
}

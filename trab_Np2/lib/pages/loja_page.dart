// =============================================================
// ARQUIVO: lib/pages/loja_page.dart
// =============================================================
//
// OBJETIVO GERAL
// --------------
// - Exibir os produtos vindos da FakeStoreAPI em um Grid.
// - Ser a tela principal da Loja Fake MegaStore após o login.
// - Permitir navegar para:
//     * detalhes de um produto
//     * carrinho
//     * perfil do usuário
//
// RELAÇÃO COM OUTROS ARQUIVOS
// ---------------------------
// - Usa:
//     * estado/app_state.dart    → ler quantidade de itens no carrinho.
//     * servicos/api_service.dart→ buscar lista de produtos.
//     * modelos/produto.dart     → tipo Produto.
//     * rotas.dart               → nomes das rotas.
// - Navega para:
//     * RotasApp.detalhesProdutoPage
//     * RotasApp.carrinhoPage
//     * RotasApp.perfilPage
//
// COMO ESTA TELA É ABERTA
// -----------------------
// - A partir da LoginPage, após o "login" bem-sucedido.
// - main.dart registra RotasApp.lojaPage.
//
// INFORMAÇÕES GERAIS
// ------------------
// - Usa FutureBuilder para lidar com a requisição assíncrona.
// - Mostra um badge vermelho no ícone do carrinho com a quantidade total.
// =============================================================

import 'package:flutter/material.dart';

import '../estado/app_state.dart';
import '../servicos/api_service.dart';
import '../modelos/produto.dart';
import '../rotas.dart';

class LojaPage extends StatefulWidget {
  final AppState appState;

  const LojaPage({super.key, required this.appState});

  @override
  State<LojaPage> createState() => _LojaPageState();
}

class _LojaPageState extends State<LojaPage> {
  // Serviço responsável por acessar a FakeStoreAPI.
  final ApiService apiService = ApiService();

  // FUTURE: futuroProdutos
  //
  // PARA QUE SERVE:
  // - Guardar o Future da lista de produtos, carregado uma vez no initState.
  late Future<List<Produto>> futuroProdutos;

  @override
  void initState() {
    super.initState();
    futuroProdutos = apiService.buscarProdutos();
  }

  // FUNÇÃO: _abrirCarrinho
  //
  // PARA QUE SERVE:
  // - Navegar até a tela do carrinho.
  //
  // INFORMAÇÃO IMPORTANTE:
  // - Ao voltar do carrinho, chamamos setState() para atualizar o badge.
  void _abrirCarrinho() {
    Navigator.pushNamed(context, RotasApp.carrinhoPage).then((_) {
      setState(() {});
    });
  }

  // FUNÇÃO: _abrirPerfil
  //
  // PARA QUE SERVE:
  // - Navegar até a tela de perfil do usuário.
  void _abrirPerfil() {
    Navigator.pushNamed(context, RotasApp.perfilPage);
  }

  // FUNÇÃO: _abrirDetalhesProduto
  //
  // PARA QUE SERVE:
  // - Navegar até a tela de detalhes de um produto específico.
  //
  // QUEM USA / ONDE:
  // - Chamado ao tocar em um Card do Grid de produtos.
  void _abrirDetalhesProduto(Produto produto) {
    Navigator.pushNamed(
      context,
      RotasApp.detalhesProdutoPage,
      arguments: produto,
    ).then((_) {
      // Ao voltar, atualizamos a bolinha do carrinho (caso tenha adicionado).
      setState(() {});
    });
  }

  // WIDGET AUXILIAR: _buildIconeCarrinho
  //
  // PARA QUE SERVE:
  // - Construir o ícone do carrinho com uma bolinha vermelha (badge)
  //   mostrando a quantidade total de itens no carrinho.
  Widget _buildIconeCarrinho() {
    final int quantidade = widget.appState.quantidadeTotalCarrinho;

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: _abrirCarrinho,
          icon: const Icon(Icons.shopping_cart),
          tooltip: 'Ver carrinho',
        ),
        if (quantidade > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Center(
                child: Text(
                  quantidade.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja Fake MegaStore'),
        actions: [
          _buildIconeCarrinho(),
          IconButton(
            onPressed: _abrirPerfil,
            icon: const Icon(Icons.person),
            tooltip: 'Perfil',
          ),
        ],
      ),
      body: Column(
        children: [
          // Cabeçalho textual simples abaixo da AppBar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bem-vindo(a),',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Confira os produtos da Fake MegaStore',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Toque em um produto para ver mais detalhes.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // LISTA DE PRODUTOS
          Expanded(
            child: FutureBuilder<List<Produto>>(
              future: futuroProdutos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao carregar produtos:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final List<Produto> produtos = snapshot.data ?? [];

                if (produtos.isEmpty) {
                  return const Center(
                    child: Text('Nenhum produto encontrado na loja.'),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.70,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: produtos.length,
                  itemBuilder: (context, index) {
                    final Produto produto = produtos[index];

                    return GestureDetector(
                      onTap: () => _abrirDetalhesProduto(produto),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  produto.imagemUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.image_not_supported,
                                      size: 48,
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                produto.titulo,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                'R\$ ${produto.preco.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// ARQUIVO: lib/pages/detalhes_produto_page.dart
// =============================================================
//
// OBJETIVO GERAL
// --------------
// - Exibir os detalhes completos de um produto selecionado na loja:
//     * imagem grande
//     * título
//     * preço
//     * categoria
//     * descrição
// - Permitir adicionar o produto ao carrinho.
//
// RELAÇÃO COM OUTROS ARQUIVOS
// ---------------------------
// - Usa:
//     * modelos/produto.dart → produto selecionado.
//     * estado/app_state.dart → adicionar ao carrinho.
// - É aberta por:
//     * LojaPage → Navigator.pushNamed(RotasApp.detalhesProdutoPage, arguments: produto).
//
// COMO ESTA TELA É ABERTA
// -----------------------
// - A partir da LojaPage, usando rota nomeada + arguments.
// - main.dart cuida do onGenerateRoute para montar esta tela.
//
// INFORMAÇÕES GERAIS
// ------------------
// - A adição ao carrinho é feita direto no AppState.
// =============================================================

import 'package:flutter/material.dart';

import '../estado/app_state.dart';
import '../modelos/produto.dart';

class DetalhesProdutoPage extends StatelessWidget {
  // Produto selecionado
  final Produto produto;

  // Estado global para manipular o carrinho
  final AppState appState;

  const DetalhesProdutoPage({
    super.key,
    required this.produto,
    required this.appState,
  });

  // FUNÇÃO LOCAL: _adicionarAoCarrinho
  //
  // PARA QUE SERVE:
  // - Adicionar o produto atual ao carrinho usando o AppState.
  //
  // QUEM USA / ONDE:
  // - Chamado pelo botão "Adicionar ao carrinho".
  void _adicionarAoCarrinho(BuildContext context) {
    appState.adicionarAoCarrinho(produto);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${produto.titulo}" adicionado ao carrinho.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do produto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagem do produto
            SizedBox(
              height: 200,
              child: Image.network(
                produto.imagemUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    size: 64,
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Título
            Text(
              produto.titulo,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Categoria
            Text(
              'Categoria: ${produto.categoria}',
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 8),

            // Preço
            Text(
              'R\$ ${produto.preco.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 16),

            // Descrição
            const Text(
              'Descrição',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              produto.descricao,
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 24),

            // Botão: adicionar ao carrinho
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _adicionarAoCarrinho(context),
                child: const Text('Adicionar ao carrinho'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

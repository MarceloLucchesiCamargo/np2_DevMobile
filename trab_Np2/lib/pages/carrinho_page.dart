// =============================================================
// ARQUIVO: lib/pages/carrinho_page.dart
// =============================================================
//
// OBJETIVO GERAL
// --------------
// - Exibir os produtos que o usuário adicionou ao carrinho.
// - Permitir aumentar/diminuir a quantidade de cada produto.
// - Exibir o valor total da compra.
// - Permitir esvaziar o carrinho.
// - Simular a finalização da compra.
//
// RELAÇÃO COM OUTROS ARQUIVOS
// ---------------------------
// - Usa:
//     * estado/app_state.dart   → ler e alterar o carrinho.
//     * modelos/produto.dart    → chave do mapa de quantidades.
// - É aberta por:
//     * LojaPage (ícone do carrinho).
//
// COMO ESTA TELA É ABERTA
// -----------------------
// - A partir da LojaPage, via Navigator.pushNamed(RotasApp.carrinhoPage).
//
// INFORMAÇÕES GERAIS
// ------------------
// - A lista interna do carrinho guarda múltiplas cópias do mesmo produto;
//   aqui fazemos o agrupamento para saber a quantidade.
// =============================================================

import 'package:flutter/material.dart';

import '../estado/app_state.dart';
import '../modelos/produto.dart';

class CarrinhoPage extends StatefulWidget {
  final AppState appState;

  const CarrinhoPage({super.key, required this.appState});

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  @override
  Widget build(BuildContext context) {
    final itens = widget.appState.itensCarrinho;
    final double total = widget.appState.totalCarrinho;

    if (itens.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Carrinho'),
        ),
        body: const Center(
          child: Text('Seu carrinho está vazio'),
        ),
      );
    }

    // AGRUPANDO PRODUTOS POR QUANTIDADE
    final Map<Produto, int> mapaQuantidade = {};
    for (final produto in itens) {
      mapaQuantidade[produto] = (mapaQuantidade[produto] ?? 0) + 1;
    }
    final List<MapEntry<Produto, int>> listaAgrupada =
        mapaQuantidade.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Column(
        children: [
          // LISTA DE ITENS
          Expanded(
            child: ListView.builder(
              itemCount: listaAgrupada.length,
              itemBuilder: (context, index) {
                final entrada = listaAgrupada[index];
                final Produto produto = entrada.key;
                final int quantidade = entrada.value;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: ListTile(
                    leading: Image.network(
                      produto.imagemUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported),
                    ),
                    title: Text(produto.titulo),
                    subtitle: Text(
                      'R\$ ${produto.preco.toStringAsFixed(2)}  |  Qtd: $quantidade',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botão "-"
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            setState(() {
                              widget.appState
                                  .removerUmaUnidadeDoCarrinho(produto);
                            });
                          },
                        ),
                        const SizedBox(width: 4),
                        // Botão "+"
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            setState(() {
                              widget.appState.adicionarAoCarrinho(produto);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // RODAPÉ: total, finalizar, esvaziar
          Container(
            width: double.infinity,
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Linha com o total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'R\$ ${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Botão "Finalizar compra" (simulação)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Compra finalizada'),
                            content: const Text(
                              'Pedido realizado com sucesso!\n'
                              'Obrigado por comprar na Fake MegaStore. Seu pedido está sendo preparado.\n'
                              'Fim da simulação!',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  widget.appState.esvaziarCarrinho();
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Finalizar compra'),
                  ),
                ),

                const SizedBox(height: 8),

                // Botão "Esvaziar carrinho"
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.appState.esvaziarCarrinho();
                      });
                    },
                    child: const Text('Esvaziar carrinho'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// ARQUIVO: lib/servicos/api_service.dart
// =============================================================
//
// OBJETIVO GERAL
// --------------
// - Centralizar o acesso HTTP à FakeStoreAPI.
// - Buscar a lista de produtos via GET /products.
// - Retornar uma lista de objetos Produto para o app.
//
// RELAÇÃO COM OUTROS ARQUIVOS
// ---------------------------
// - Usa:
//     * modelos/produto.dart → para montar os objetos Produto.
// - É usado por:
//     * pages/loja_page.dart → carregar produtos no Grid.
//
// COMO ESTE ARQUIVO É USADO
// -------------------------
// - A LojaPage cria uma instância de ApiService e chama buscarProdutos().
// - O resultado é tratado em um FutureBuilder.
//
// INFORMAÇÕES GERAIS
// ------------------
// - Usa o pacote http para fazer requisições REST.
// - Em produção, poderíamos adicionar timeout, tratamento de erros avançado,
//   logging, etc. Aqui o foco é didático.
// =============================================================

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../modelos/produto.dart';

// CLASSE: ApiService
// ------------------
// PARA QUE SERVE:
// - Encapsular a comunicação com a FakeStoreAPI.
// - Evitar espalhar código de http.get e jsonDecode pelas telas.
//
// QUEM USA / ONDE:
// - LojaPage → para buscar a lista de produtos.
class ApiService {
  // URL base da FakeStoreAPI
  static const String _baseUrl = 'https://fakestoreapi.com';

  // MÉTODO: buscarProdutos
  //
  // PARA QUE SERVE:
  // - Fazer uma requisição HTTP GET para /products.
  // - Converter a resposta JSON em uma lista de Produto.
  //
  // QUEM USA / ONDE:
  // - LojaPage, dentro de initState(), para popular o Grid.
  //
  // INFORMAÇÕES IMPORTANTES:
  // - Lança uma Exception se o statusCode não for 200.
  Future<List<Produto>> buscarProdutos() async {
    final uri = Uri.parse('$_baseUrl/products');

    final http.Response resposta = await http.get(uri);

    if (resposta.statusCode == 200) {
      final corpo = resposta.body;

      // jsonDecode transforma String em List<dynamic> ou Map.
      final dados = jsonDecode(corpo);

      if (dados is List) {
        final List<Produto> produtos = [];
        for (final item in dados) {
          if (item is Map<String, dynamic>) {
            produtos.add(Produto.fromJson(item));
          } else if (item is Map) {
            // Caso seja Map genérico, fazemos cast.
            produtos.add(Produto.fromJson(item.cast<String, dynamic>()));
          }
        }
        return produtos;
      } else {
        throw Exception('Resposta inesperada da API (não é lista).');
      }
    } else {
      if (kDebugMode) {
        print(
            'Erro ao buscar produtos: statusCode=${resposta.statusCode}, body=${resposta.body}');
      }
      throw Exception(
          'Erro ao buscar produtos (código ${resposta.statusCode}).');
    }
  }
}

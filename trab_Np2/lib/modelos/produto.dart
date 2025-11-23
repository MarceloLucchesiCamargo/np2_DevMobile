// =============================================================
// ARQUIVO: lib/modelos/produto.dart
// =============================================================
//
// OBJETIVO GERAL
// --------------
// - Definir a classe de modelo "Produto" usada pela Fake MegaStore.
// - "Traduzir" o JSON da FakeStoreAPI em um objeto Dart fortemente tipado.
// - Facilitar o uso de dados de produto nas telas (lista, detalhes, carrinho).
//
// RELAÇÃO COM OUTROS ARQUIVOS
// ---------------------------
// - Usado por:
//     * servicos/api_service.dart         → criar objetos Produto a partir do JSON.
//     * pages/loja_page.dart              → exibir lista em GridView.
//     * pages/detalhes_produto_page.dart  → exibir detalhes.
//     * pages/carrinho_page.dart          → agrupar e exibir itens.
//
// COMO ESTE ARQUIVO É USADO
// -------------------------
// - Ao receber um JSON da API, chamamos Produto.fromJson(json).
// - Na interface, usamos as propriedades: titulo, preco, imagemUrl, etc.
//
// INFORMAÇÕES GERAIS
// ------------------
// - Representa o modelo mínimo necessário para o app acadêmico.
// =============================================================

class Produto {
  // CAMPOS PRINCIPAIS DO PRODUTO
  //
  // PARA QUE SERVEM:
  // - id          → identificar unicamente o produto.
  // - titulo      → nome/título exibido na lista e nos detalhes.
  // - descricao   → texto mais longo, exibido nos detalhes.
  // - preco       → valor em reais (double).
  // - imagemUrl   → URL da imagem, usada em Image.network.
  // - categoria   → categoria da FakeStoreAPI (ex.: "men's clothing").
  final int id;
  final String titulo;
  final String descricao;
  final double preco;
  final String imagemUrl;
  final String categoria;

  // CONSTRUTOR
  //
  // QUEM USA / ONDE:
  // - Usado internamente em fromJson, copyWith e, eventualmente, em testes.
  Produto({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.preco,
    required this.imagemUrl,
    required this.categoria,
  });

  // FÁBRICA: Produto.fromJson
  //
  // PARA QUE SERVE:
  // - Converter um Map<String, dynamic> (JSON decodificado) em Produto.
  //
  // QUEM USA / ONDE:
  // - ApiService.buscarProdutos() → ao interpretar o retorno da FakeStoreAPI.
  //
  // INFORMAÇÕES IMPORTANTES:
  // - Faz conversão cuidadosa de tipos (ex.: preço pode vir como int/double).
  factory Produto.fromJson(Map<String, dynamic> json) {
    final dynamic precoBruto = json['price'];

    double precoConvertido;
    if (precoBruto is int) {
      precoConvertido = precoBruto.toDouble();
    } else if (precoBruto is double) {
      precoConvertido = precoBruto;
    } else {
      precoConvertido = 0.0;
    }

    return Produto(
      id: json['id'] ?? 0,
      titulo: json['title'] ?? '',
      descricao: json['description'] ?? '',
      preco: precoConvertido,
      imagemUrl: json['image'] ?? '',
      categoria: json['category'] ?? '',
    );
  }

  // MÉTODO: toJson
  //
  // PARA QUE SERVE:
  // - Converter um Produto de volta para Map<String, dynamic>.
  //
  // QUEM USA / ONDE:
  // - Útil em cenários de envio de dados para APIs (POST/PUT).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': titulo,
      'description': descricao,
      'price': preco,
      'image': imagemUrl,
      'category': categoria,
    };
  }

  // MÉTODO: copyWith
  //
  // PARA QUE SERVE:
  // - Criar uma cópia de Produto mudando apenas alguns campos.
  //
  // QUEM USA / ONDE:
  // - Útil para evoluções futuras (edição de produtos, etc.).
  Produto copyWith({
    int? id,
    String? titulo,
    String? descricao,
    double? preco,
    String? imagemUrl,
    String? categoria,
  }) {
    return Produto(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      preco: preco ?? this.preco,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      categoria: categoria ?? this.categoria,
    );
  }
}

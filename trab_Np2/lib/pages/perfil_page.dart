// =============================================================
// ARQUIVO: lib/pages/perfil_page.dart
// =============================================================
//
// OBJETIVO GERAL
// --------------
// - Exibir e permitir edição dos dados do perfil do usuário:
//     * Nome
//     * E-mail
//     * Endereço de entrega (cidade, estado, CEP, bairro, rua, número).
// - Permitir sair da conta (logout).
//
// RELAÇÃO COM OUTROS ARQUIVOS
// ---------------------------
// - Usa:
//     * estado/app_state.dart → ler/salvar dados de perfil e logout.
//     * rotas.dart            → voltar para a tela de Login após logout.
// - É aberta por:
//     * LojaPage (ícone de usuário na AppBar).
//
// COMO ESTA TELA É ABERTA
// -----------------------
// - Via Navigator.pushNamed(context, RotasApp.perfilPage) a partir da Loja.
//
// INFORMAÇÕES GERAIS
// ------------------
// - Mantém dois modos: visualização e edição.
// - Em modo edição, campos ficam habilitados e aparecem botões "Salvar"/"Cancelar".
// =============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../estado/app_state.dart';
import '../rotas.dart';

class PerfilPage extends StatefulWidget {
  final AppState appState;

  const PerfilPage({super.key, required this.appState});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  // CONTROLADORES DOS CAMPOS
  final TextEditingController controladorNome = TextEditingController();
  final TextEditingController controladorEmail = TextEditingController();
  final TextEditingController controladorCidade = TextEditingController();
  final TextEditingController controladorEstado = TextEditingController();
  final TextEditingController controladorCep = TextEditingController();
  final TextEditingController controladorBairro = TextEditingController();
  final TextEditingController controladorRua = TextEditingController();
  final TextEditingController controladorNumero = TextEditingController();

  // Flag que indica se estamos editando ou apenas visualizando.
  bool modoEdicao = false;

  @override
  void initState() {
    super.initState();
    _carregarDadosDoEstado();
  }

  @override
  void dispose() {
    controladorNome.dispose();
    controladorEmail.dispose();
    controladorCidade.dispose();
    controladorEstado.dispose();
    controladorCep.dispose();
    controladorBairro.dispose();
    controladorRua.dispose();
    controladorNumero.dispose();
    super.dispose();
  }

  // FUNÇÃO: _carregarDadosDoEstado
  //
  // PARA QUE SERVE:
  // - Preencher os TextEditingController com os valores atuais do AppState.
  //
  // QUEM USA / ONDE:
  // - Chamado em initState e quando o usuário cancela a edição.
  void _carregarDadosDoEstado() {
    final appState = widget.appState;

    controladorNome.text = appState.nomeUsuario ?? '';
    controladorEmail.text = appState.emailUsuario ?? '';
    controladorCidade.text = appState.cidadeEntrega ?? '';
    controladorEstado.text = appState.estadoEntrega ?? '';
    controladorCep.text = appState.cepEntrega ?? '';
    controladorBairro.text = appState.bairroEntrega ?? '';
    controladorRua.text = appState.ruaEntrega ?? '';
    controladorNumero.text = appState.numeroEntrega ?? '';
  }

  // FUNÇÃO: _fazerLogout
  //
  // PARA QUE SERVE:
  // - Limpar estado (usuário + carrinho) e voltar ao login.
  void _fazerLogout(BuildContext context) {
    widget.appState.fazerLogout();
    Navigator.pushNamedAndRemoveUntil(
      context,
      RotasApp.loginPage,
      (route) => false,
    );
  }

  // ENTRAR EM MODO EDIÇÃO
  void _entrarEmModoEdicao() {
    setState(() {
      modoEdicao = true;
    });
  }

  // CANCELAR EDIÇÃO
  //
  // PARA QUE SERVE:
  // - Descartar alterações e restaurar dados originais.
  void _cancelarEdicao() {
    setState(() {
      _carregarDadosDoEstado();
      modoEdicao = false;
    });
  }

  // SALVAR PERFIL
  //
  // PARA QUE SERVE:
  // - Gravar os dados digitados no AppState e sair do modo edição.
  void _salvarPerfil() {
    final nome = controladorNome.text.trim();
    final email = controladorEmail.text.trim();
    final cidade = controladorCidade.text.trim();
    final estado = controladorEstado.text.trim();
    final cep = controladorCep.text.trim();
    final bairro = controladorBairro.text.trim();
    final rua = controladorRua.text.trim();
    final numero = controladorNumero.text.trim();

    widget.appState.atualizarPerfil(
      nome: nome,
      email: email,
      cidade: cidade,
      estado: estado,
      cep: cep,
      bairro: bairro,
      rua: rua,
      numero: numero,
    );

    setState(() {
      modoEdicao = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perfil atualizado com sucesso.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil - Loja Fake MegaStore',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Perfil do usuário',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: controladorNome,
              enabled: modoEdicao,
              decoration: const InputDecoration(
                labelText: 'Nome completo',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controladorEmail,
              enabled: modoEdicao,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Endereço para entrega',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controladorCidade,
              enabled: modoEdicao,
              decoration: const InputDecoration(
                labelText: 'Cidade',
                prefixIcon: Icon(Icons.location_city),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controladorEstado,
              enabled: modoEdicao,
              decoration: const InputDecoration(
                labelText: 'Estado (UF)',
                prefixIcon: Icon(Icons.map),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controladorCep,
              enabled: modoEdicao,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: 'CEP',
                prefixIcon: Icon(Icons.local_post_office),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controladorBairro,
              enabled: modoEdicao,
              decoration: const InputDecoration(
                labelText: 'Bairro',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controladorRua,
              enabled: modoEdicao,
              decoration: const InputDecoration(
                labelText: 'Rua',
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controladorNumero,
              enabled: modoEdicao,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: 'Número',
                prefixIcon: Icon(Icons.confirmation_number),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            if (!modoEdicao) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _entrarEmModoEdicao,
                  child: const Text('Editar perfil'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _fazerLogout(context),
                  child: const Text('Sair da conta'),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvarPerfil,
                  child: const Text('Salvar alterações'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _cancelarEdicao,
                  child: const Text('Cancelar'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

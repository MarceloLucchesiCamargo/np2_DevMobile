// =============================================================
// ARQUIVO: lib/pages/registro_page.dart
// =============================================================
//
// OBJETIVO GERAL
// --------------
// - Simular o cadastro de um novo usuário na Fake MegaStore.
// - Coletar:
//     * Nome completo
//     * E-mail
//     * Senha + confirmação de senha
// - Validar se as senhas coincidem e se os campos foram preenchidos.
// - Retornar para a tela de Login após o "cadastro" (simulado).
//
// RELAÇÃO COM OUTROS ARQUIVOS
// ---------------------------
// - Usa:
//     * estado/app_state.dart (por consistência, embora aqui não salve nada).
// - Navega de volta para:
//     * RotasApp.loginPage (via Navigator.pop).
//
// COMO ESTA TELA É ABERTA
// -----------------------
// - A partir da LoginPage, quando o usuário clica em "Criar conta".
//
// INFORMAÇÕES GERAIS
// ------------------
// - Não há persistência real dos dados.
// - O objetivo é demonstrar fluxo de formulário + validação simples.
// =============================================================

import 'package:flutter/material.dart';

import '../estado/app_state.dart';

// CLASSE: RegistroPage
// --------------------
// PARA QUE SERVE:
// - Exibir um formulário de cadastro com nome, e-mail e senha.
// - Simular o processo de criação de conta para fins acadêmicos.
//
// QUEM USA / ONDE:
// - Registrada em main.dart na rota RotasApp.registroPage.
// - Aberta pela LoginPage.
class RegistroPage extends StatefulWidget {
  final AppState appState;

  const RegistroPage({super.key, required this.appState});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  // CONTROLADORES DOS CAMPOS
  final TextEditingController controladorNome = TextEditingController();
  final TextEditingController controladorEmail = TextEditingController();
  final TextEditingController controladorSenha = TextEditingController();
  final TextEditingController controladorConfirmacaoSenha =
      TextEditingController();

  @override
  void dispose() {
    controladorNome.dispose();
    controladorEmail.dispose();
    controladorSenha.dispose();
    controladorConfirmacaoSenha.dispose();
    super.dispose();
  }

  // FUNÇÃO: _registrarUsuario
  //
  // PARA QUE SERVE:
  // - Validar os dados do formulário e simular o cadastro.
  //
  // QUEM USA / ONDE:
  // - Chamado pelo botão "Cadastrar".
  //
  // INFORMAÇÕES IMPORTANTES:
  // - Faz validação mínima:
  //     * Todos os campos preenchidos
  //     * senha == confirmação
  void _registrarUsuario() {
    final nome = controladorNome.text.trim();
    final email = controladorEmail.text.trim();
    final senha = controladorSenha.text;
    final confirmacao = controladorConfirmacaoSenha.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty || confirmacao.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos para se cadastrar.'),
        ),
      );
      return;
    }

    if (senha != confirmacao) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não conferem.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cadastro realizado para $nome (simulado).'),
      ),
    );

    // Volta para a tela de login
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro - Loja Fake MegaStore',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Criar nova conta',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: controladorNome,
              decoration: const InputDecoration(
                labelText: 'Nome completo',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controladorEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controladorSenha,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controladorConfirmacaoSenha,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar senha',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _registrarUsuario,
                child: const Text('Cadastrar'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Voltar para login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

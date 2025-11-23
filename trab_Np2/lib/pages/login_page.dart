// =============================================================
// ARQUIVO: lib/pages/login_page.dart
// =============================================================
//
// OBJETIVO GERAL
// --------------
// - Ser a porta de entrada da aplicação "Loja Fake MegaStore".
// - Exibir um formulário de login simples (e-mail + senha simulada).
// - Encaminhar o usuário para a Loja após o login bem-sucedido.
// - Possibilitar navegação para a tela de Registro.
//
// RELAÇÃO COM OUTROS ARQUIVOS
// ---------------------------
// - Usa:
//     * estado/app_state.dart → salvar e-mail do usuário logado.
//     * rotas.dart            → navegar para loja e registro.
// - Navega para:
//     * RotasApp.lojaPage
//     * RotasApp.registroPage
//
// COMO ESTA TELA É ABERTA
// -----------------------
// - main.dart define initialRoute = RotasApp.loginPage.
// - Também pode ser reaberta a partir do logout (PerfilPage).
//
// INFORMAÇÕES GERAIS
// ------------------
// - Login é apenas simulado (não há validação real contra servidor).
// - Senha não é verificada de fato (apenas campo de entrada).
// =============================================================

import 'package:flutter/material.dart';

import '../estado/app_state.dart';
import '../rotas.dart';

// CLASSE: LoginPage
// -----------------
// PARA QUE SERVE:
// - Exibir campos de e-mail e senha para o usuário.
// - Encaminhar para LojaPage em caso de "login".
//
// QUEM USA / ONDE:
// - Registrada em main.dart na rota RotasApp.loginPage.
class LoginPage extends StatefulWidget {
  // REFERÊNCIA AO ESTADO GLOBAL (AppState)
  //
  // PARA QUE SERVE:
  // - Permitir registrar o e-mail do usuário logado.
  // - Possibilitar que outras telas (PerfilPage) leiam este e-mail.
  final AppState appState;

  const LoginPage({super.key, required this.appState});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// ESTADO: _LoginPageState
// -----------------------
// PARA QUE SERVE:
// - Guardar os TextEditingController dos campos (e-mail, senha).
// - Implementar as funções de ação (_realizarLogin e _abrirRegistro).
// - Construir o layout da tela.
class _LoginPageState extends State<LoginPage> {
  // CONTROLADOR: controladorEmail
  //
  // PARA QUE SERVE:
  // - Ler e manipular o texto digitado no campo de e-mail.
  final TextEditingController controladorEmail = TextEditingController();

  // CONTROLADOR: controladorSenha
  //
  // PARA QUE SERVE:
  // - Ler o texto digitado no campo de senha (apenas para efeito visual).
  final TextEditingController controladorSenha = TextEditingController();

  @override
  void dispose() {
    // Libera os recursos dos controladores quando a tela é destruída.
    controladorEmail.dispose();
    controladorSenha.dispose();
    super.dispose();
  }

  // FUNÇÃO: _realizarLogin
  //
  // PARA QUE SERVE:
  // - Ler o e-mail digitado, salvar no AppState e navegar para a LojaPage.
  //
  // QUEM USA / ONDE:
  // - Chamado pelo botão "Entrar" (onPressed).
  void _realizarLogin() {
    final String email = controladorEmail.text.trim();

    // Salva o e-mail no estado global (para poder exibir no perfil, etc).
    widget.appState.fazerLogin(email);

    // Navega para a Loja, substituindo a tela atual.
    Navigator.pushReplacementNamed(context, RotasApp.lojaPage);
  }

  // FUNÇÃO: _abrirRegistro
  //
  // PARA QUE SERVE:
  // - Navegar até a tela de Registro.
  //
  // QUEM USA / ONDE:
  // - Chamado pelo botão "Criar conta".
  void _abrirRegistro() {
    Navigator.pushNamed(context, RotasApp.registroPage);
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold com AppBar simples e corpo centralizado.
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login - Loja Fake MegaStore',
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
            // TÍTULO PRINCIPAL
            const Text(
              'Bem-vindo à Loja Fake MegaStore',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            // CAMPO DE E-MAIL
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

            // CAMPO DE SENHA
            TextField(
              controller: controladorSenha,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 40),

            // BOTÃO "ENTRAR"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _realizarLogin,
                child: const Text('Entrar'),
              ),
            ),

            const SizedBox(height: 20),

            // BOTÃO "CRIAR CONTA"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _abrirRegistro,
                child: const Text('Criar conta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

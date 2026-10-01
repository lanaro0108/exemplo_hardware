import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identificadorController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authService = AuthService();
  bool _carregando = false;
  bool _mostrarSenha = false;

  @override
  void dispose() {
    _identificadorController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _entrarComSenha() {
    final autenticado = _authService.autenticarComSenha(
      _identificadorController.text.trim(),
      _senhaController.text,
    );
    if (autenticado) {
      _abrirHome('Senha');
    } else {
      _mostrarMensagem('NIF/email ou senha inválidos.');
    }
  }

  Future<void> _entrarComBiometria() async {
    setState(() => _carregando = true);
    final autenticado = await _authService.autenticarComBiometria();
    if (!mounted) return;
    setState(() => _carregando = false);
    if (autenticado) {
      _abrirHome('Biometria');
    } else {
      _mostrarMensagem('Biometria indisponível ou não reconhecida.');
    }
  }

  void _abrirHome(String metodo) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(metodoAutenticacao: metodo)),
    );
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 48),
              Icon(Icons.access_time_filled, size: 64),
              SizedBox(height: 16),
              Text(
                'Sistema de Ponto',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Registre sua jornada com segurança e localização.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              TextField(
                controller: _identificadorController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'NIF ou email',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _senhaController,
                obscureText: !_mostrarSenha,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _mostrarSenha = !_mostrarSenha),
                    icon: Icon(
                      _mostrarSenha ? Icons.visibility_off : Icons.visibility,
                    ),
                    tooltip: 'Mostrar senha',
                  ),
                ),
              ),
              SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _carregando ? null : _entrarComSenha,
                icon: Icon(Icons.login),
                label: Text('Entrar'),
              ),
              SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _carregando ? null : _entrarComBiometria,
                icon: Icon(Icons.fingerprint),
                label: Text(
                  _carregando ? 'Verificando...' : 'Entrar com biometria',
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Acesso de demonstração: ${AuthService.emailDemo} / '
                '${AuthService.senhaDemo}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

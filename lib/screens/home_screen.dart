import 'package:flutter/material.dart';

import '../models/local_trabalho.dart';
import '../models/ponto_registro.dart';
import '../services/location_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String metodoAutenticacao;

  const HomeScreen({super.key, required this.metodoAutenticacao});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _locationService = LocationService();
  final List<PontoRegistro> _registros = [];
  double? _distanciaMetros;
  bool _carregandoLocalizacao = false;
  String? _mensagemLocalizacao;

  bool get _podeRegistrar =>
      _distanciaMetros != null &&
      _locationService.estaNoLocal(_distanciaMetros!);

  @override
  void initState() {
    super.initState();
    _atualizarLocalizacao();
  }

  Future<void> _atualizarLocalizacao() async {
    setState(() {
      _carregandoLocalizacao = true;
      _mensagemLocalizacao = null;
    });
    final posicao = await _locationService.obterPosicaoAtual();
    if (!mounted) return;
    if (posicao == null) {
      setState(() {
        _carregandoLocalizacao = false;
        _mensagemLocalizacao =
            'Ative o GPS e permita o acesso à localização para continuar.';
      });
      return;
    }
    setState(() {
      _carregandoLocalizacao = false;
      _distanciaMetros = _locationService.calcularDistancia(posicao);
    });
  }

  Future<void> _registrarPonto() async {
    if (!_podeRegistrar) return;
    final posicao = await _locationService.obterPosicaoAtual();
    if (!mounted || posicao == null) return;
    final distancia = _locationService.calcularDistancia(posicao);
    if (!_locationService.estaNoLocal(distancia)) {
      setState(() => _distanciaMetros = distancia);
      _mostrarMensagem('Você está fora do raio permitido de 100 metros.');
      return;
    }
    setState(() {
      _distanciaMetros = distancia;
      _registros.insert(
        0,
        PontoRegistro(
          dataHora: DateTime.now(),
          latitude: posicao.latitude,
          longitude: posicao.longitude,
          distanciaMetros: distancia,
          metodoAutenticacao: widget.metodoAutenticacao,
        ),
      );
    });
    _mostrarMensagem('Ponto registrado com sucesso.');
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  String _formatarData(DateTime data) {
    String doisDigitos(int valor) => valor.toString().padLeft(2, '0');
    return '${doisDigitos(data.day)}/${doisDigitos(data.month)}/${data.year} '
        '${doisDigitos(data.hour)}:${doisDigitos(data.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sistema de Ponto'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
            ),
            icon: Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _construirStatusLocalizacao(),
          SizedBox(height: 16),
          _construirBotaoRegistro(),
          SizedBox(height: 24),
          Text(
            'Registros desta sessão',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          if (_registros.isEmpty)
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('Nenhum ponto registrado nesta sessão.'),
              ),
            )
          else
            ..._registros.map(_construirRegistro),
        ],
      ),
    );
  }

  Widget _construirStatusLocalizacao() {
    final dentroDoRaio = _podeRegistrar;
    final cor = dentroDoRaio ? Colors.green : Colors.orange.shade800;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  dentroDoRaio ? Icons.location_on : Icons.location_searching,
                  color: cor,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Local de trabalho',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: _carregandoLocalizacao
                      ? null
                      : _atualizarLocalizacao,
                  icon: Icon(Icons.refresh),
                  tooltip: 'Atualizar localização',
                ),
              ],
            ),
            Text(LocalTrabalho.nome),
            SizedBox(height: 8),
            if (_carregandoLocalizacao)
              LinearProgressIndicator()
            else if (_mensagemLocalizacao != null)
              Text(_mensagemLocalizacao!)
            else
              Text(
                'Distância: ${_distanciaMetros!.toStringAsFixed(1)} m\n'
                '${dentroDoRaio ? 'Dentro do raio permitido' : 'Fora do raio permitido'}',
                style: TextStyle(color: cor),
              ),
          ],
        ),
      ),
    );
  }

  Widget _construirBotaoRegistro() {
    return FilledButton.icon(
      onPressed: _podeRegistrar ? _registrarPonto : null,
      icon: Icon(Icons.how_to_reg),
      label: Text('Registrar ponto'),
      style: FilledButton.styleFrom(padding: EdgeInsets.all(16)),
    );
  }

  Widget _construirRegistro(PontoRegistro registro) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(Icons.check)),
        title: Text(_formatarData(registro.dataHora)),
        subtitle: Text(
          '${registro.distanciaMetros.toStringAsFixed(1)} m do local • '
          'Autenticação: ${registro.metodoAutenticacao}',
        ),
      ),
    );
  }
}

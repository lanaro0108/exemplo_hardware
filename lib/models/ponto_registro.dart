class PontoRegistro {
  final DateTime dataHora;
  final double latitude;
  final double longitude;
  final double distanciaMetros;
  final String metodoAutenticacao;

  const PontoRegistro({
    required this.dataHora,
    required this.latitude,
    required this.longitude,
    required this.distanciaMetros,
    required this.metodoAutenticacao,
  });
}

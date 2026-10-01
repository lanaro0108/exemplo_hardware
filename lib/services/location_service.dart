import 'package:geolocator/geolocator.dart';

import '../models/local_trabalho.dart';

class LocationService {
  Future<Position?> obterPosicaoAtual() async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;

    var permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }
    if (permissao == LocationPermission.denied ||
        permissao == LocationPermission.deniedForever) {
      return null;
    }

    return Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
  }

  double calcularDistancia(Position posicao) {
    return Geolocator.distanceBetween(
      posicao.latitude,
      posicao.longitude,
      LocalTrabalho.latitude,
      LocalTrabalho.longitude,
    );
  }

  bool estaNoLocal(double distanciaMetros) {
    return distanciaMetros <= LocalTrabalho.raioPermitidoMetros;
  }
}

import 'package:local_auth/local_auth.dart';

class AuthService {
  static const String emailDemo = 'funcionario@senai.com';
  static const String nifDemo = '123456789';
  static const String senhaDemo = '123456';

  final LocalAuthentication _biometria = LocalAuthentication();

  bool autenticarComSenha(String identificador, String senha) {
    final identificadorValido =
        identificador == emailDemo || identificador == nifDemo;
    return identificadorValido && senha == senhaDemo;
  }

  Future<bool> autenticarComBiometria() async {
    try {
      final suportada = await _biometria.isDeviceSupported();
      final disponivel = await _biometria.canCheckBiometrics;
      if (!suportada || !disponivel) return false;

      return await _biometria.authenticate(
        localizedReason: 'Confirme sua identidade para registrar o ponto.',
        options: AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
    } catch (_) {
      return false;
    }
  }
}

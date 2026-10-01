# SENAI Ponto

Aplicativo Flutter para registro de ponto com autenticação, biometria e validação de geolocalização.

## Funcionalidades

- Login por NIF/email e senha.
- Login por biometria do dispositivo.
- Verificação da distância até o local de trabalho.
- Registro do ponto somente dentro do raio de 100 metros.
- Histórico dos registros feitos na sessão atual.

## Instalação e uso

1. Instale o Flutter e um dispositivo Android ou emulador com GPS.
2. Execute `flutter pub get`.
3. Execute `flutter run`.
4. Use `funcionario@senai.com` e `123456` para o acesso de demonstração.
5. No painel, permita o acesso à localização e toque em `Registrar ponto` quando estiver no raio permitido.

As coordenadas do local de trabalho ficam em `lib/models/local_trabalho.dart`. Substitua os valores de latitude e longitude pelas coordenadas reais da unidade antes da entrega.

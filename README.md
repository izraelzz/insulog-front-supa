# Insulog - Como iniciar

## Pré-requisitos

Antes de rodar o projeto, certifique-se de ter instalado:

- Flutter SDK
- Dart
- Git
- um emulador ou dispositivo físico
- a API do backend funcionando e acessível

Verifique se tudo está certo:

```bash
flutter --version
flutter doctor
```

## 1) Clone o projeto

```bash
git clone <url-do-repositorio>
cd insulog-front-supa
```

## 2) Instale as dependências

```bash
flutter pub get
```

## 3) Rode o projeto

```bash
flutter run
```

Se quiser rodar em um dispositivo específico:

```bash
flutter devices
flutter run -d <device-id>
```

## 4) Configure a API

O app precisa de uma URL da API para funcionar. Você pode configurar isso de duas formas:

### Opção A: pelo app
- abra o app
- na tela de login, clique no botão de configuração de IP
- informe o IP da API

### Opção B: na linha de comando

```bash
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:3000
```

> Ajuste o IP/porta conforme o backend que estiver rodando.

## 5) Se der erro de conexão

- confirme se o backend está ativo
- confirme se o IP informado está correto
- confira se a porta da API está acessível

## Testes rápidos

```bash
flutter test
```

## Observação

O ponto de entrada principal do app está em:

```text
lib/main.dart
```

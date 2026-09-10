import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:insulog/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('usuário consegue entrar e credenciais são persistidas', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final server = await _startFakeApi();

    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString('api_ip_digits', '127.0.0.1');

      await tester.pumpWidget(const MainApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'ana@example.com');
      await tester.enterText(find.byType(TextField).last, 'segredo');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      expect(find.text('Registros'), findsOneWidget);
      expect(
        (await SharedPreferences.getInstance()).getInt('saved_user_id'),
        42,
      );
      expect(
        (await SharedPreferences.getInstance()).getString('saved_username'),
        'ana@example.com',
      );
    } finally {
      await server.close(force: true);
    }
  });
}

Future<HttpServer> _startFakeApi() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000);

  unawaited(
    server.forEach((request) async {
      if (request.method == 'POST' && request.uri.path == '/login') {
        final body = await utf8.decoder.bind(request).join();
        final credentials = jsonDecode(body) as Map<String, dynamic>;

        if (credentials['username'] == 'ana@example.com' &&
            credentials['password'] == 'segredo') {
          request.response
            ..statusCode = HttpStatus.ok
            ..headers.contentType = ContentType.json
            ..write(
              jsonEncode({
                'user': {'id': 42},
              }),
            );
        } else {
          request.response
            ..statusCode = HttpStatus.unauthorized
            ..headers.contentType = ContentType.json
            ..write(jsonEncode({'message': 'Usuario ou senha invalidos.'}));
        }
      } else if (request.method == 'GET' &&
          request.uri.path == '/alarmes/usuario/42') {
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(jsonEncode({'registros': []}));
      } else if (request.method == 'GET' &&
          request.uri.path.startsWith('/registros-glicose/usuario/42')) {
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(
            jsonEncode({
              'mediaDiaria': 0,
              'statusMediaDiaria': 3,
              'statusMediaDiariaDescricao': 'Sem dados',
              'registros': [],
            }),
          );
      } else {
        request.response.statusCode = HttpStatus.notFound;
      }

      await request.response.close();
    }),
  );

  return server;
}

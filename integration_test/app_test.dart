import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insulog/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('abre o login e valida campos obrigatorios', (tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Cadastrar'), findsOneWidget);

    await tester.tap(find.text('Entrar'));
    await tester.pump();

    final textFields = tester.widgetList<TextField>(find.byType(TextField));

    expect(textFields, hasLength(2));
    expect(textFields.first.decoration?.labelStyle?.color, Colors.red);
    expect(textFields.last.decoration?.labelStyle?.color, Colors.red);
  });
}

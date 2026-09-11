import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:insulog/main.dart' as app;
import 'package:insulog/services/local/saved_login_service.dart';
import 'package:insulog/widgets/glucoseRegister/glucose_register_form_widget.dart';
import 'package:insulog/widgets/report/report_glucose_record_list_widget.dart';
import 'package:insulog/widgets/report/stats_report_widget.dart';

// All interactions after session preparation go through the real widgets.
Future<void> until(WidgetTester tester, bool Function() condition) async {
  final deadline = DateTime.now().add(const Duration(seconds: 20));
  do {
    await tester.pump(const Duration(milliseconds: 50));
    if (condition() && tester.binding.transientCallbackCount == 0) return;
  } while (DateTime.now().isBefore(deadline));
  fail('A interface não atingiu a condição esperada em 20 segundos.');
}

Future<void> tap(WidgetTester tester, Finder finder) async {
  await until(tester, () => finder.hitTestable().evaluate().length == 1);
  await tester.tap(finder.hitTestable());
  await tester.pump();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'registra glicose 100 e consulta o histórico persistido',
    (tester) async {
      const base = String.fromEnvironment('API_BASE_URL');
      const username = String.fromEnvironment('SYSTEM_USERNAME');
      const password = String.fromEnvironment('SYSTEM_PASSWORD');
      const userId = int.fromEnvironment('SYSTEM_USER_ID');
      const dateString = String.fromEnvironment('SYSTEM_DATE');
      final uri = Uri.parse(base);
      expect(uri.scheme, 'http');
      expect(uri.host, '127.0.0.1');
      expect(username.endsWith('@example.invalid'), isTrue);
      expect(password, isNotEmpty);
      expect(userId, greaterThan(0));
      final date = DateTime.parse(dateString);
      expect(date.day, 1);

      // Real preferences + the app's existing automatic login authenticate at
      // POST /login. No token, user ID or navigation bypass in production code.
      final savedLogin = SavedLoginService();
      final previous = await savedLogin.getCredentials();
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        await savedLogin.clearCredentials();
        if (previous != null) {
          await savedLogin.saveCredentials(
            userId: previous.userId,
            username: previous.username,
            password: previous.password,
          );
        }
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      await savedLogin.saveCredentials(
        userId: userId,
        username: username,
        password: password,
      );
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(430, 932);
      app.main();
      await tap(tester, find.text('Novo Registro'));
      final input = find.descendant(
        of: find.byType(GlucoseRegisterFormWidget),
        matching: find.byType(TextField),
      );
      await until(tester, () => input.hitTestable().evaluate().length == 1);
      await tester.enterText(input, '100');
      await tap(tester, find.text('Avançar'));

      // MaterialApp currently uses the default en_US Material dialogs.
      await tap(tester, find.byIcon(Icons.calendar_today));
      await tap(tester, find.byIcon(Icons.edit_outlined));
      final dateInput = find.descendant(
        of: find.byType(DatePickerDialog),
        matching: find.byType(TextField),
      );
      await until(tester, () => dateInput.evaluate().length == 1);
      await tester.enterText(dateInput, '${date.month}/1/${date.year}');
      await tap(tester, find.text('OK'));
      await tap(tester, find.byIcon(Icons.access_time));
      await tap(tester, find.byIcon(Icons.keyboard_outlined));
      final timeInputs = find.descendant(
        of: find.byType(TimePickerDialog),
        matching: find.byType(TextField),
      );
      await until(tester, () => timeInputs.evaluate().length == 2);
      await tester.enterText(timeInputs.at(0), '12');
      await tester.enterText(timeInputs.at(1), '00');
      if (find.text('PM').evaluate().isNotEmpty) {
        await tap(tester, find.text('PM'));
      }
      await tap(tester, find.text('OK'));
      // Choosing the first period automatically advances to the insulin step.
      await tap(tester, find.text('Jejum'));
      await tap(tester, find.text('Avançar'));
      await until(
        tester,
        () => find
            .text('Detalhes do Registro')
            .hitTestable()
            .evaluate()
            .isNotEmpty,
      );
      expect(find.text('100 mg/dL'), findsOneWidget);
      expect(find.text('!!! - 0 un'), findsOneWidget);
      final formattedDate =
          '01/${date.month.toString().padLeft(2, '0')}/${date.year}';
      expect(find.text('12:00 - $formattedDate'), findsOneWidget);
      expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
      await tap(tester, find.text('Registrar'));
      // The form only pops after the real POST completes successfully.
      await tap(tester, find.text('Relatório'));

      const months = [
        'Janeiro',
        'Fevereiro',
        'Março',
        'Abril',
        'Maio',
        'Junho',
        'Julho',
        'Agosto',
        'Setembro',
        'Outubro',
        'Novembro',
        'Dezembro',
      ];
      final monthLabel = find.text('${months[date.month - 1]}  ');
      // Covers a local/UTC month boundary without changing the machine clock.
      for (
        var attempt = 0;
        monthLabel.evaluate().isEmpty && attempt < 12;
        attempt++
      ) {
        await tap(tester, find.byIcon(Icons.arrow_left));
        await until(tester, () => tester.binding.transientCallbackCount == 0);
      }
      expect(monthLabel, findsOneWidget);
      expect(find.text(' ${date.year}'), findsOneWidget);
      await tap(tester, find.byKey(const ValueKey('report-day-1')));

      final records = find.byType(ReportGlucoseRecordListWidget);
      Finder inRecords(Finder finder) =>
          find.descendant(of: records, matching: finder);
      final measurement = inRecords(find.text('100 mg/dL', findRichText: true));
      final mean = find.ancestor(
        of: find.text('Média'),
        matching: find.byType(StatsReportWidget),
      );
      Future<void> verifyRecord() async {
        await until(
          tester,
          () =>
              measurement.evaluate().length == 1 &&
              find
                      .descendant(of: mean, matching: find.text('100'))
                      .evaluate()
                      .length ==
                  1,
        );
        expect(measurement, findsOneWidget);
        expect(inRecords(find.text('12:00')), findsOneWidget);
        expect(inRecords(find.text('Jejum')), findsOneWidget);
        expect(inRecords(find.text('DIA 1')), findsOneWidget);
        expect(monthLabel, findsOneWidget);
        expect(find.text(' ${date.year}'), findsOneWidget);
        await tester.ensureVisible(measurement);
        expect(measurement.hitTestable(), findsOneWidget);
      }

      await verifyRecord();
      // Force a different real GET and observe its empty result before returning.
      // This prevents an old cached row from satisfying the persistence assertion.
      await tester.ensureVisible(find.byKey(const ValueKey('report-day-2')));
      await tap(tester, find.byKey(const ValueKey('report-day-2')));
      await until(
        tester,
        () =>
            measurement.evaluate().isEmpty &&
            find
                    .descendant(of: mean, matching: find.text('0'))
                    .evaluate()
                    .length ==
                1,
      );
      await tester.ensureVisible(find.byKey(const ValueKey('report-day-1')));
      await tap(tester, find.byKey(const ValueKey('report-day-1')));
      await verifyRecord();
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}

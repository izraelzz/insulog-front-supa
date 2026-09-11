import 'package:flutter_test/flutter_test.dart';
import 'package:insulog/utils/api_date_time_formatter.dart';

void main() {
  group('ApiDateTimeFormatter', () {
    test('formata com zeros e sem alterar o horario informado', () {
      expect(
        ApiDateTimeFormatter.format(DateTime(2026, 2, 3, 4, 5, 6)),
        '2026-02-03 04:05:06',
      );
    });

    test('combina data e hora vindas de seletores diferentes', () {
      final date = DateTime(2024, 2, 29, 23, 59);
      final time = DateTime(2000, 1, 1, 6, 7, 8);
      expect(
        ApiDateTimeFormatter.combineDateAndTime(date, time),
        DateTime(2024, 2, 29, 6, 7, 8),
      );
      expect(
        ApiDateTimeFormatter.formatDateAndTime(date, time),
        '2024-02-29 06:07:08',
      );
    });

    test('le formato SQL, ISO e horario sem segundos', () {
      for (final value in [
        '2026-09-11 08:05:00',
        '2026-09-11T08:05:00',
        ' 2026-09-11 08:05 ',
      ]) {
        expect(ApiDateTimeFormatter.parse(value), DateTime(2026, 9, 11, 8, 5));
      }
    });

    test(
      'preserva DateTime e interpreta offset explicito como o mesmo instante',
      () {
        final value = DateTime.utc(2026, 9, 11, 11);
        expect(ApiDateTimeFormatter.parse(value), same(value));
        expect(ApiDateTimeFormatter.parse('2026-09-11T08:00:00-03:00'), value);
      },
    );

    test('rejeita data ausente ou texto sem formato de data', () {
      for (final value in [null, '', '   ', 'nao-e-data']) {
        expect(() => ApiDateTimeFormatter.parse(value), throwsFormatException);
      }
    });
  });
}

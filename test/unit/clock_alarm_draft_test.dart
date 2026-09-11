import 'package:flutter_test/flutter_test.dart';
import 'package:insulog/DTO/ENUMs/clock_alarm_draft.dart';
import 'package:insulog/DTO/ENUMs/enum_clock_register.dart';

void main() {
  final draft = ClockAlarmDraft(
    idUsuario: 42,
    dataHora: DateTime(2026, 9, 11, 8, 5),
    periodoId: 0,
    registroId: 0,
    diasSemana: const ['SEG', 'SEX'],
    ativo: true,
    vibracao: true,
    som: false,
  );

  test(
    'alarme omite vinculos ausentes e envia preferencias explicitamente',
    () {
      expect(draft.toCreateJson(), {
        'id_usuario': 42,
        'data_hora': '2026-09-11 08:05:00',
        'dias_semana': ['SEG', 'SEX'],
        'ativo': true,
        'tem_som': false,
        'tem_vibracao': true,
      });
    },
  );

  test('copia inclui vinculos e permite false sem alterar o original', () {
    final copy = draft.copyWith(
      periodoId: 2,
      registroId: 7,
      ativo: false,
      vibracao: false,
      som: true,
    );
    expect(copy.toUpdateJson(), {
      'id_usuario': 42,
      'data_hora': '2026-09-11 08:05:00',
      'id_periodo': 2,
      'id_registro': 7,
      'dias_semana': ['SEG', 'SEX'],
      'ativo': false,
      'tem_som': true,
      'tem_vibracao': false,
    });
    expect(draft.ativo, isTrue);
    expect(draft.vibracao, isTrue);
    expect(draft.som, isFalse);
    expect(draft.periodoId, 0);
  });

  test('conversao para registro local preserva horario e preferencias', () {
    final result = draft.toClockRegister();
    expect(result.idAlarme, 0);
    expect(result.idUsuario, 42);
    expect(result.dataHora, DateTime(2026, 9, 11, 8, 5));
    expect(result.diasSemana, ['SEG', 'SEX']);
    expect(result.ativo, isTrue);
    expect(result.temSom, isFalse);
    expect(result.temVibracao, isTrue);
  });

  test('le alarme da API normalizando dias repetidos, IDs e booleanos', () {
    final result = EnumClockRegister.fromJson({
      'id_alarme': '7',
      'id_usuario': '42',
      'data_hora': '2026-09-11 08:05:00',
      'dias_semana': ' seg, SEX, seg, ',
      'ativo': 'false',
      'tem_som': 1,
      'tem_vibracao': 0,
    });
    expect(result.idAlarme, 7);
    expect(result.idUsuario, 42);
    expect(result.periodo, 0);
    expect(result.idRegistro, 0);
    expect(result.diasSemana, ['SEG', 'SEX']);
    expect(result.ativo, isFalse);
    expect(result.temSom, isTrue);
    expect(result.temVibracao, isFalse);
  });
}

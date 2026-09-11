import 'package:flutter_test/flutter_test.dart';
import 'package:insulog/DTO/ENUMs/enum_form_registroGlicose.dart';
import 'package:insulog/globals.dart';
import 'package:insulog/states/glucose_record_form_screen_state.dart';

void main() {
  late GlucoseRecordFormScreenState state;
  late int previousUserId;
  setUp(() {
    previousUserId = Globals().userId;
    Globals().setUserId(42);
    state = GlucoseRecordFormScreenState();
  });
  tearDown(() {
    state.dispose();
    Globals().setUserId(previousUserId);
  });

  test('registro exige glicose e periodo e permite omitir insulina', () {
    expect(state.isCanRegister, isFalse);
    state.atualizarNivelGlicose('100');
    expect(state.isCanRegister, isFalse);
    state.atualizarPeriodo(1);
    expect(state.insulinaNaoInformada, isTrue);
    expect(state.isCanRegister, isTrue);
  });

  test('insulina exige quantidade e tipo juntos', () {
    state.atualizarNivelGlicose('100');
    state.atualizarPeriodo(1);
    state.atualizarUnidadeInsulina('5');
    expect(state.insulinaIncompleta, isTrue);
    expect(state.isCanRegister, isFalse);
    state.atualizarTipoInsulina(2, false);
    expect(state.insulinaPreenchida, isTrue);
    expect(state.isCanRegister, isTrue);
    state.atualizarUnidadeInsulina('0');
    expect(state.insulinaIncompleta, isTrue);
    expect(state.isCanRegister, isFalse);
    state.atualizarTipoInsulina(2, true);
    expect(state.insulinaNaoInformada, isTrue);
    expect(state.isCanRegister, isTrue);
  });

  test('campos numericos limitam valores entre 0 e 999', () {
    for (final entry in {
      '-1': 0,
      '0': 0,
      '1': 1,
      '999': 999,
      '1000': 999,
      'abc': 0,
      '': 0,
    }.entries) {
      state.atualizarNivelGlicose(entry.key);
      state.atualizarUnidadeInsulina(entry.key);
      expect(state.nivelGlicose, entry.value, reason: entry.key);
      expect(state.unidadeInsulina, entry.value, reason: entry.key);
    }
  });

  test('botoes respeitam limites e atualizam controllers', () {
    state.decrementarNivelGlicose();
    state.decrementarUnidadeInsulina();
    expect(state.nivelGlicose, 0);
    expect(state.unidadeInsulina, 0);
    expect(state.glucoseImputController.text, '');
    state.incrementarNivelGlicose();
    state.incrementarUnidadeInsulina();
    expect(state.glucoseImputController.text, '1');
    expect(state.insulinaImputController.text, '1');
    state.atualizarNivelGlicose('999');
    state.atualizarUnidadeInsulina('999');
    state.incrementarNivelGlicose();
    state.incrementarUnidadeInsulina();
    expect(state.nivelGlicose, 999);
    expect(state.unidadeInsulina, 999);
  });

  test('validacao destaca campos ausentes e remove erros ao corrigir', () {
    state.validaCampos(isFromRegister: true, field: 'glicose');
    state.validaCampos(isFromRegister: true, field: 'periodo');
    expect(state.isErroGlicose, isTrue);
    expect(state.isErroPeriodo, isTrue);
    state.atualizarNivelGlicose('100');
    state.atualizarPeriodo(1);
    expect(state.isErroGlicose, isFalse);
    expect(state.isErroPeriodo, isFalse);
    state.atualizarUnidadeInsulina('5');
    state.validaCampos(isFromRegister: true, field: 'insulina');
    expect(state.isErroInsulina, isTrue);
    state.atualizarTipoInsulina(2, false);
    expect(state.isErroInsulina, isFalse);
  });

  test('novo registro combina dados do formulario e usuario atual', () {
    state.atualizarNivelGlicose('100');
    state.atualizarPeriodo(2);
    state.atualizarUnidadeInsulina('5');
    state.atualizarTipoInsulina(1, false);
    state.atualizarDataDoRegistro(DateTime(2026, 9, 11));
    state.atualizarHoraDoRegistro(DateTime(2000, 1, 1, 8, 5));
    state.atualizarObservacao('Antes da refeicao');
    expect(state.novoRegistro.toJson(), {
      'id_usuario': '42',
      'nivel_glicose': 100,
      'id_periodo': 2,
      'data_hora': '2026-09-11 08:05:00',
      'observacao': 'Antes da refeicao',
      'insulina': {'id_tipo_insulina': 1, 'unidade_insulina': 5},
      'lembrete': {'criar': false},
    });
    expect(state.dataFormatada(), '11/09/2026');
    expect(state.horaFormatada(), '08:05');
  });

  test(
    'iniciar edicao preenche campos, limita valores e limpa erros anteriores',
    () {
      state.setErroGlicose(true);
      state.setErroPeriodo(true);
      state.setErroInsulina(true);
      state.iniciarEdicao(
        7,
        NewRegistroGlicose(
          idUsuario: '42',
          nivelGlicose: 1200,
          periodoId: 2,
          horaDoRegistro: DateTime(2026, 9, 11, 8),
          dataDoRegistro: DateTime(2026, 9, 11),
          unidadeInsulina: -1,
          tipoInsulinaId: 0,
          observacao: 'Edicao',
        ),
      );
      expect(state.isEditing, isTrue);
      expect(state.nivelGlicose, 999);
      expect(state.glucoseImputController.text, '999');
      expect(state.unidadeInsulina, 0);
      expect(state.insulinaImputController.text, '');
      expect(state.periodoId, 2);
      expect(state.observacaoController.text, 'Edicao');
      expect(state.isErroGlicose, isFalse);
      expect(state.isErroPeriodo, isFalse);
      expect(state.isErroInsulina, isFalse);
    },
  );
}

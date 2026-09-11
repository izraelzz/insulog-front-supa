import 'package:flutter_test/flutter_test.dart';
import 'package:insulog/DTO/ENUMs/enum_form_registroGlicose.dart';
import 'package:insulog/DTO/ENUMs/enum_registroGlicose.dart';

Map<String, dynamic> registro(int id, int nivel) => {
  'id': id,
  'horaDoRegistro': '2026-09-11 08:05:00',
  'nivelGlicose': nivel,
  'periodo': 'Jejum',
  'status': 1,
  'statusDescricao': 'Normal',
};

void main() {
  group('RegistroGlicose', () {
    test('interpreta resposta da API com numeros em texto', () {
      final result = RegistroGlicose.fromJson({
        ...registro(7, 100),
        'id': '7',
        'nivelGlicose': '100',
        'status': '1',
      });
      expect(result.id, 7);
      expect(result.nivelGlicose, 100);
      expect(result.status, 1);
      expect(result.statusDescricao, 'Normal');
      expect(result.periodo, 'Jejum');
      expect(result.horaDoRegistro, DateTime(2026, 9, 11, 8, 5));
      expect(result.horaFormatada, '08:05');
    });

    test('aceita nomes alternativos dos campos da API', () {
      final result = RegistroGlicose.fromJson({
        'id_registro_glicose': 8,
        'data_hora': '2026-09-11 08:05:00',
        'nivel_glicose': 126,
        'status': 2,
        'status_descricao': 'Alta',
      });
      expect(result.id, 8);
      expect(result.nivelGlicose, 126);
      expect(result.statusDescricao, 'Alta');
      expect(result.periodo, '');
    });

    test(
      'associa cada status a cor correspondente e usa cinza para desconhecido',
      () {
        for (final entry in {
          0: 0xFFFFC81e,
          1: 0xFF3ea75f,
          2: 0xFFD62828,
          99: 0xFF808080,
        }.entries) {
          final result = RegistroGlicose.fromJson({
            ...registro(1, 100),
            'status': entry.key,
          });
          expect(result.colorStatus, entry.value);
        }
      },
    );

    test('calcula e arredonda a media de uma lista, inclusive lista vazia', () {
      final result = RegistrosGlicoseResponse.fromList([
        registro(1, 100),
        registro(2, 101),
      ]);
      expect(result.mediaDiaria, 101);
      expect(result.registros.map((item) => item.id), [1, 2]);
      expect(RegistrosGlicoseResponse.fromList([]).mediaDiaria, 0);
    });

    test(
      'le resposta direta ou envelopada e preserva a media enviada pela API',
      () {
        final payload = {
          'media_diaria': '120',
          'status_media_diaria': '1',
          'status_media_diaria_descricao': 'Normal',
          'dados': [registro(1, 100)],
        };
        for (final json in [
          payload,
          {'data': payload},
        ]) {
          final result = RegistrosGlicoseResponse.fromJson(json);
          expect(result.mediaDiaria, 120);
          expect(result.statusMediaDiaria, 1);
          expect(result.statusMediaDiariaDescricao, 'Normal');
          expect(result.registros.single.id, 1);
        }
      },
    );

    test('rejeita resposta em que registros nao e uma lista', () {
      for (final value in [null, 'invalido', <String, dynamic>{}]) {
        expect(
          () => RegistrosGlicoseResponse.fromJson({'registros': value}),
          throwsFormatException,
        );
      }
    });
  });

  group('NewRegistroGlicose', () {
    NewRegistroGlicose novo({LembreteRegistroGlicose? lembrete}) =>
        NewRegistroGlicose(
          idUsuario: '42',
          nivelGlicose: 100,
          periodoId: 1,
          horaDoRegistro: DateTime(2000, 1, 1, 8, 5, 6),
          dataDoRegistro: DateTime(2026, 9, 11, 23),
          unidadeInsulina: 0,
          tipoInsulinaId: 0,
          observacao: 'Teste',
          lembrete: lembrete,
        );

    test('monta contrato de criacao sem insulina e sem lembrete', () {
      final value = novo();
      expect(value.toJson(), {
        'id_usuario': '42',
        'nivel_glicose': 100,
        'id_periodo': 1,
        'data_hora': '2026-09-11 08:05:06',
        'observacao': 'Teste',
        'insulina': {'id_tipo_insulina': 0, 'unidade_insulina': 0},
        'lembrete': {'criar': false},
      });
      expect(value.horaFormatada, '08:05');
      expect(value.dataFormatada, '11/09/2026');
    });

    test('serializa lembrete usando a data e hora proprias', () {
      final value = novo(
        lembrete: LembreteRegistroGlicose(
          criar: true,
          dataDoLembrete: DateTime(2026, 9, 12),
          horaDoLembrete: DateTime(2000, 1, 1, 10, 30),
          periodoId: 2,
        ),
      );
      expect(value.toJson()['lembrete'], {
        'criar': true,
        'data_hora': '2026-09-12 10:30:00',
        'id_periodo': 2,
      });
      expect(LembreteRegistroGlicose(criar: false).toJson(), {'criar': false});
    });
  });
}

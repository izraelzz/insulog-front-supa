import 'package:insulog/utils/api_date_time_formatter.dart';

class NewRegistroGlicose {
  final String idUsuario;
  final int nivelGlicose;
  final int periodoId;
  final DateTime horaDoRegistro;
  final DateTime dataDoRegistro;
  final int unidadeInsulina;
  final int tipoInsulinaId;
  final String observacao;
  final LembreteRegistroGlicose? lembrete;

  NewRegistroGlicose({
    required this.idUsuario,
    required this.nivelGlicose,
    required this.periodoId,
    required this.horaDoRegistro,
    required this.dataDoRegistro,
    required this.unidadeInsulina,
    required this.tipoInsulinaId,
    required this.observacao,
    this.lembrete,
  });

  String get horaFormatada {
    final hour = horaDoRegistro.hour.toString().padLeft(2, '0');
    final minute = horaDoRegistro.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String get dataFormatada {
    final day = dataDoRegistro.day.toString().padLeft(2, '0');
    final month = dataDoRegistro.month.toString().padLeft(2, '0');
    final year = dataDoRegistro.year.toString();

    return '$day/$month/$year';
  }

  DateTime get dataHoraDoRegistro {
    return ApiDateTimeFormatter.combineDateAndTime(
      dataDoRegistro,
      horaDoRegistro,
    );
  }

  String get dataHoraDoRegistroApi {
    return ApiDateTimeFormatter.format(dataHoraDoRegistro);
  }

  Map<String, dynamic> toJson() {
    return {
      'id_usuario': idUsuario,
      'nivel_glicose': nivelGlicose,
      'id_periodo': periodoId,
      'data_hora': dataHoraDoRegistroApi,
      'observacao': observacao,
      'insulina': {
        'id_tipo_insulina': tipoInsulinaId,
        'unidade_insulina': unidadeInsulina,
      },
      'lembrete': lembrete?.toJson() ?? {'criar': false},
    };
  }

  factory NewRegistroGlicose.fromJson(
    int idUsuario,
    int nivelGlicose,
    int periodoId,
    DateTime horaDoRegistro,
    DateTime dataDoRegistro,
    int unidadeInsulina,
    int tipoInsulinaId,
    String observacao, {
    LembreteRegistroGlicose? lembrete,
  }) {
    return NewRegistroGlicose(
      idUsuario: idUsuario.toString(),
      nivelGlicose: nivelGlicose,
      periodoId: periodoId,
      horaDoRegistro: horaDoRegistro,
      dataDoRegistro: dataDoRegistro,
      unidadeInsulina: unidadeInsulina,
      tipoInsulinaId: tipoInsulinaId,
      observacao: observacao,
      lembrete: lembrete,
    );
  }
}
 
class LembreteRegistroGlicose {
  final bool criar;
  final DateTime? dataDoLembrete;
  final DateTime? horaDoLembrete;
  final int? periodoId;

  LembreteRegistroGlicose({
    required this.criar,
    this.dataDoLembrete,
    this.horaDoLembrete,
    this.periodoId,
  });

  DateTime? get dataHoraDoLembrete {
    if (dataDoLembrete == null || horaDoLembrete == null) {
      return null;
    }

    return ApiDateTimeFormatter.combineDateAndTime(
      dataDoLembrete!,
      horaDoLembrete!,
    );
  }

  String? get dataHoraDoLembreteApi {
    final dataHora = dataHoraDoLembrete;

    if (dataHora == null) {
      return null;
    }

    return ApiDateTimeFormatter.format(dataHora);
  }

  Map<String, dynamic> toJson() {
    if (!criar) {
      return {'criar': false};
    }

    return {
      'criar': true,
      'data_hora': dataHoraDoLembreteApi,
      'id_periodo': periodoId,
    };
  }
}

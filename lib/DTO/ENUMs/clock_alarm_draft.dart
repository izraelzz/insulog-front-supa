import 'package:insulog/DTO/ENUMs/enum_clock_register.dart';
import 'package:insulog/utils/api_date_time_formatter.dart';

class ClockAlarmDraft {
  final int idUsuario;
  final DateTime dataHora;
  final int periodoId;
  final int registroId;
  final List<String> diasSemana;
  final bool ativo;
  final bool vibracao;
  final bool som;

  const ClockAlarmDraft({
    required this.idUsuario,
    required this.dataHora,
    required this.periodoId,
    required this.registroId,
    required this.diasSemana,
    required this.ativo,
    required this.vibracao,
    required this.som,
  });

  factory ClockAlarmDraft.defaults({required int idUsuario}) {
    final now = DateTime.now();
    var defaultDateTime = DateTime(now.year, now.month, now.day, 6);

    if (!defaultDateTime.isAfter(now)) {
      defaultDateTime = defaultDateTime.add(const Duration(days: 1));
    }

    return ClockAlarmDraft(
      idUsuario: idUsuario,
      dataHora: defaultDateTime,
      periodoId: 0,
      registroId: 0,
      diasSemana: const ['SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SAB', 'DOM'],
      ativo: true,
      vibracao: true,
      som: false,
    );
  }

  int get hora => dataHora.hour;
  int get minuto => dataHora.minute;

  Map<String, dynamic> toCreateJson() {
    return {
      'id_usuario': idUsuario,
      'data_hora': ApiDateTimeFormatter.format(dataHora),
      if (periodoId > 0) 'id_periodo': periodoId,
      'dias_semana': diasSemana,
      'ativo': ativo,
      'tem_som': som,
      'tem_vibracao': vibracao,
      if (registroId > 0) 'id_registro': registroId,
    };
  }

  Map<String, dynamic> toUpdateJson() => toCreateJson();

  ClockAlarmDraft copyWith({
    int? idUsuario,
    DateTime? dataHora,
    int? periodoId,
    int? registroId,
    List<String>? diasSemana,
    bool? ativo,
    bool? vibracao,
    bool? som,
  }) {
    return ClockAlarmDraft(
      idUsuario: idUsuario ?? this.idUsuario,
      dataHora: dataHora ?? this.dataHora,
      periodoId: periodoId ?? this.periodoId,
      registroId: registroId ?? this.registroId,
      diasSemana: diasSemana ?? this.diasSemana,
      ativo: ativo ?? this.ativo,
      vibracao: vibracao ?? this.vibracao,
      som: som ?? this.som,
    );
  }

  EnumClockRegister toClockRegister() {
    return EnumClockRegister(
      idAlarme: 0,
      idUsuario: idUsuario,
      dataHora: dataHora,
      periodo: periodoId,
      idRegistro: registroId,
      diasSemana: diasSemana,
      ativo: ativo,
      temSom: som,
      temVibracao: vibracao,
    );
  }
}

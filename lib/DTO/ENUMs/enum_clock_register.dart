import 'package:insulog/utils/api_date_time_formatter.dart';

class EnumClockRegister {
  final int idAlarme;
  final int idUsuario;
  final DateTime dataHora;
  final int periodo;
  final int idRegistro;
  final List<String> diasSemana;
  final bool ativo;
  final bool temSom;
  final bool temVibracao;

  EnumClockRegister({
    required this.idAlarme,
    required this.idUsuario,
    required this.dataHora,
    required this.periodo,
    required this.idRegistro,
    required this.diasSemana,
    required this.ativo,
    this.temSom = false,
    this.temVibracao = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_alarme': idAlarme,
      'id_usuario': idUsuario,
      'data_hora': ApiDateTimeFormatter.format(dataHora),
      'id_periodo': periodo,
      'id_registro': idRegistro,
      'dias_semana': diasSemana,
      'ativo': ativo,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'id_usuario': idUsuario,
      'data_hora': ApiDateTimeFormatter.format(dataHora),
      'id_periodo': periodo,
      'id_registro': idRegistro,
      'dias_semana': diasSemana,
      'ativo': ativo,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'id_usuario': idUsuario,
      'data_hora': ApiDateTimeFormatter.format(dataHora),
      'id_periodo': periodo,
      'id_registro': idRegistro,
      'dias_semana': diasSemana,
      'ativo': ativo,
      'tem_som': temSom,
      'tem_vibracao': temVibracao,
    };
  }

  EnumClockRegister copyWith({
    int? idAlarme,
    int? idUsuario,
    DateTime? dataHora,
    int? periodo,
    int? idRegistro,
    List<String>? diasSemana,
    bool? ativo,
    bool? temSom,
    bool? temVibracao,
  }) {
    return EnumClockRegister(
      idAlarme: idAlarme ?? this.idAlarme,
      idUsuario: idUsuario ?? this.idUsuario,
      dataHora: dataHora ?? this.dataHora,
      periodo: periodo ?? this.periodo,
      idRegistro: idRegistro ?? this.idRegistro,
      diasSemana: diasSemana ?? this.diasSemana,
      ativo: ativo ?? this.ativo,
      temSom: temSom ?? this.temSom,
      temVibracao: temVibracao ?? this.temVibracao,
    );
  }

  factory EnumClockRegister.fromJson(Map<String, dynamic> json) {
    return EnumClockRegister(
      idAlarme: _readInt(json['id_alarme']),
      idUsuario: _readInt(json['id_usuario']),
      dataHora: ApiDateTimeFormatter.parse(json['data_hora']),
      periodo: _readInt(json['id_periodo']),
      idRegistro: _readInt(json['id_registro']),
      diasSemana: _readDiasSemana(json['dias_semana']),
      ativo: _readBool(json['ativo']),
      temSom: _readBool(json['tem_som'] ?? json['temSom']),
      temVibracao: _readBool(
        json['tem_vibracao'] ?? json['temVibracao'],
        defaultValue: true,
      ),
    );
  }

  static int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString().trim() ?? '') ?? 0;
  }

  static List<String> _readDiasSemana(dynamic value) {
    final values = value is List
        ? value
        : value?.toString().split(',') ?? const <String>[];

    return values
        .map((day) => day.toString().trim().toUpperCase())
        .where((day) => day.isNotEmpty)
        .toSet()
        .toList(growable: false);
  }

  static bool _readBool(dynamic value, {bool defaultValue = false}) {
    if (value == null) {
      return defaultValue;
    }
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    final normalized = value?.toString().trim().toLowerCase();
    return normalized == 'true' || normalized == '1';
  }
}

class EnumClockRegisterResponse {
  final List<EnumClockRegister> registros;

  EnumClockRegisterResponse({required this.registros});

  factory EnumClockRegisterResponse.fromJson(Map<String, dynamic> json) {
    final registrosJson = json['registros'] as List<dynamic>? ?? [];
    final registros = registrosJson
        .map(
          (registroJson) =>
              EnumClockRegister.fromJson(registroJson as Map<String, dynamic>),
        )
        .toList();

    return EnumClockRegisterResponse(registros: registros);
  }

  factory EnumClockRegisterResponse.fromList(List<dynamic> jsonList) {
    final registros = jsonList
        .map(
          (registroJson) =>
              EnumClockRegister.fromJson(registroJson as Map<String, dynamic>),
        )
        .toList();

    return EnumClockRegisterResponse(registros: registros);
  }
}

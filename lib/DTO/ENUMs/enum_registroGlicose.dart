import 'package:insulog/utils/api_date_time_formatter.dart';

class RegistroGlicose {
  final int id;
  final DateTime horaDoRegistro;
  final String periodo;
  final int nivelGlicose;
  final int status;
  final String statusDescricao;

  RegistroGlicose({
    required this.id,
    required this.horaDoRegistro,
    required this.periodo,
    required this.nivelGlicose,
    required this.status,
    required this.statusDescricao,
  });

  String get horaFormatada {
    final hour = horaDoRegistro.hour.toString().padLeft(2, '0');
    final minute = horaDoRegistro.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  int get colorStatus {
    switch (status) {
      case 0:
        return 0xFFFFC81e;
      case 1:
        return 0xFF3ea75f;
      case 2:
        return 0xFFD62828;
      default:
        return 0xFF808080;
    }
  }

  factory RegistroGlicose.fromJson(Map<String, dynamic> json) {
    return RegistroGlicose(
      id: _readInt(
        json['id'] ?? json['id_registro_glicose'] ?? json['idRegistroGlicose'],
      ),
      horaDoRegistro: ApiDateTimeFormatter.parse(
        json['horaDoRegistro'] ?? json['hora_do_registro'] ?? json['data_hora'],
      ),
      periodo: json['periodo'] ?? '',
      nivelGlicose: _readInt(json['nivelGlicose'] ?? json['nivel_glicose']),
      status: _readInt(json['status']),
      statusDescricao:
          json['statusDescricao'] ?? json['status_descricao'] ?? '',
    );
  }

  static int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class RegistrosGlicoseResponse {
  final int mediaDiaria;
  final int statusMediaDiaria;
  final String statusMediaDiariaDescricao;
  final List<RegistroGlicose> registros;

  RegistrosGlicoseResponse({
    required this.mediaDiaria,
    required this.statusMediaDiaria,
    required this.statusMediaDiariaDescricao,
    required this.registros,
  });

  factory RegistrosGlicoseResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final responseJson = data is Map<String, dynamic> ? data : json;
    final registrosJson = responseJson['registros'] ?? responseJson['dados'];

    if (registrosJson is! List) {
      throw FormatException(
        'Campo "registros" deveria ser uma lista, mas veio ${registrosJson.runtimeType}: $registrosJson',
      );
    }

    return RegistrosGlicoseResponse(
      mediaDiaria: _readInt(
        responseJson['mediaDiaria'] ?? responseJson['media_diaria'],
      ),
      statusMediaDiaria: _readInt(
        responseJson['statusMediaDiaria'] ?? responseJson['status_media_diaria'],
      ),
      statusMediaDiariaDescricao:
          responseJson['statusMediaDiariaDescricao'] ??
          responseJson['status_media_diaria_descricao'] ??
          '',
      registros: _readRegistros(registrosJson),
    );
  }

  factory RegistrosGlicoseResponse.fromList(List<dynamic> json) {
    final registros = _readRegistros(json);
    final media = registros.isEmpty
        ? 0
        : (registros
                  .map((registro) => registro.nivelGlicose)
                  .reduce((total, nivel) => total + nivel) /
              registros.length)
            .round();

    return RegistrosGlicoseResponse(
      mediaDiaria: media,
      statusMediaDiaria: 3,
      statusMediaDiariaDescricao: '',
      registros: registros,
    );
  }

  static List<RegistroGlicose> _readRegistros(List<dynamic> registrosJson) {
    return registrosJson
        .map((item) => RegistroGlicose.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

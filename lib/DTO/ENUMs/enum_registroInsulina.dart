import 'package:insulog/utils/api_date_time_formatter.dart';

class RegistroInsulina {
  final int id;
  final int idRegistroGlicose;
  final DateTime horaDoRegistro;
  final int idTipoInsulina;
  final String tipoInsulina;
  final int unidadeInsulina;

  RegistroInsulina({
    required this.id,
    required this.idRegistroGlicose,
    required this.horaDoRegistro,
    required this.idTipoInsulina,
    required this.tipoInsulina,
    required this.unidadeInsulina,
  });

  String get horaFormatada {
    final hour = horaDoRegistro.hour.toString().padLeft(2, '0');
    final minute = horaDoRegistro.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idRegistroGlicose': idRegistroGlicose,
      'horaDoRegistro': ApiDateTimeFormatter.format(horaDoRegistro),
      'idTipoInsulina': idTipoInsulina,
      'tipoInsulina': tipoInsulina,
      'unidadeInsulina': unidadeInsulina,
    };
  }

  factory RegistroInsulina.fromJson(Map<String, dynamic> json) {
    return RegistroInsulina(
      id: _readInt(json['id'] ?? json['id_registro_insulina']),
      idRegistroGlicose: _readInt(
        json['idRegistroGlicose'] ?? json['id_registro_glicose'],
      ),
      horaDoRegistro: ApiDateTimeFormatter.parse(
        json['horaDoRegistro'] ?? json['hora_do_registro'] ?? json['data_hora'],
      ),
      idTipoInsulina: _readInt(
        json['idTipoInsulina'] ?? json['id_tipo_insulina'],
      ),
      tipoInsulina: json['tipoInsulina'] ?? json['tipo_insulina'] ?? '',
      unidadeInsulina: _readInt(
        json['unidadeInsulina'] ?? json['unidade_insulina'],
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

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class RegistroInsulinaResponse {
  final List<RegistroInsulina> registros;

  RegistroInsulinaResponse({required this.registros});

  factory RegistroInsulinaResponse.fromJson(Map<String, dynamic> json) {
    return RegistroInsulinaResponse(
      registros: (json['registros'] as List)
          .map((item) => RegistroInsulina.fromJson(item))
          .toList(),
    );
  }

  factory RegistroInsulinaResponse.fromList(List<dynamic> list) {
    return RegistroInsulinaResponse(
      registros: list
          .map((item) => RegistroInsulina.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:insulog/DTO/ENUMs/clock_alarm_draft.dart';
import 'package:insulog/DTO/ENUMs/enum_clock_register.dart';

class AlarmPlatformService {
  AlarmPlatformService._();

  static final AlarmPlatformService instance = AlarmPlatformService._();
  static const MethodChannel _channel = MethodChannel('insulog/alarm');

  Future<bool> ensurePermissions() async {
    return _invokeBool('ensurePermissions');
  }

  Future<bool> scheduleAlarm(EnumClockRegister alarm) async {
    return _invokeBool('scheduleAlarm', _alarmArguments(alarm));
  }

  Future<bool> scheduleDraft(int idAlarme, ClockAlarmDraft alarm) async {
    return _invokeBool('scheduleAlarm', {
      'id': idAlarme,
      'hour': alarm.hora,
      'minute': alarm.minuto,
      'days': alarm.diasSemana,
      'active': alarm.ativo,
      'sound': alarm.som,
      'vibration': alarm.vibracao,
      'title': 'Lembrete do Insulog',
    });
  }

  Future<bool> cancelAlarm(int idAlarme) async {
    return _invokeBool('cancelAlarm', {'id': idAlarme});
  }

  Future<bool> syncAlarms(List<EnumClockRegister> alarms) async {
    return _invokeBool(
      'syncAlarms',
      alarms.map(_alarmArguments).toList(growable: false),
    );
  }

  Map<String, dynamic> _alarmArguments(EnumClockRegister alarm) {
    return {
      'id': alarm.idAlarme,
      'hour': alarm.dataHora.toLocal().hour,
      'minute': alarm.dataHora.toLocal().minute,
      'days': alarm.diasSemana,
      'active': alarm.ativo,
      'sound': alarm.temSom,
      'vibration': alarm.temVibracao,
      'title': 'Lembrete do Insulog',
    };
  }

  Future<bool> _invokeBool(String method, [dynamic arguments]) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return true;
    }

    try {
      return await _channel.invokeMethod<bool>(method, arguments) ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException catch (error) {
      debugPrint('[ALARM_PLATFORM][$method] ${error.code}: ${error.message}');
      return false;
    }
  }
}

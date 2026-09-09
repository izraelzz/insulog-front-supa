class ApiDateTimeFormatter {
  ApiDateTimeFormatter._();

  static String format(DateTime value) {
    final year = value.year.toString().padLeft(4, '0');
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');

    return '$year-$month-$day $hour:$minute:$second';
  }

  static DateTime parse(dynamic value) {
    if (value is DateTime) {
      return value;
    }

    final normalized = _normalize(value?.toString());

    if (normalized == null) {
      throw const FormatException('Data/hora nao informada.');
    }

    return DateTime.parse(normalized);
  }

  static DateTime combineDateAndTime(DateTime date, DateTime time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      time.second,
    );
  }

  static String formatDateAndTime(DateTime date, DateTime time) {
    return format(combineDateAndTime(date, time));
  }

  static String? _normalize(String? value) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return null;
    }

    var normalized = trimmedValue.replaceFirst(' ', 'T');

    if (RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}$').hasMatch(normalized)) {
      normalized = '$normalized:00';
    }

    return normalized;
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class ApiIpService {
  static const String _apiIpDigitsKey = 'api_ip_digits';
  static const String _defaultApiIpDigits = '26231135107';
  static const String _legacyApiIpDigits = '101735747';
  static const String _legacyApiIp = '10.173.57.47';
  static const int _apiPort = 3000;

  Future<void> saveApiIpDigits(String digits) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiIpDigitsKey, digits);
  }

  Future<String> getApiIpDigits() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIp = prefs.getString(_apiIpDigitsKey);

    if (savedIp == null ||
        savedIp == _legacyApiIpDigits ||
        savedIp == _legacyApiIp) {
      return _defaultApiIpDigits;
    }

    return savedIp;
  }

  Future<String> getBaseUrl() async {
    final savedIp = await getApiIpDigits();
    final ip =
        (isValidIp(savedIp) ? savedIp : null) ??
        formatDigitsAsIp(savedIp) ??
        formatDigitsAsIp(_defaultApiIpDigits) ??
        '26.231.135.107';

    return 'http://$ip:$_apiPort';
  }

  static String? formatDigitsAsIp(String digits) {
    if (!RegExp(r'^\d{4,12}$').hasMatch(digits)) {
      return null;
    }

    final privateIp = _formatPrivateIp(digits);
    if (privateIp != null) {
      return privateIp;
    }

    return _findValidIp(digits);
  }

  static bool isValidIp(String value) {
    final octets = value.split('.');
    if (octets.length != 4) {
      return false;
    }

    return octets.every((octet) {
      if (octet.isEmpty || !RegExp(r'^\d{1,3}$').hasMatch(octet)) {
        return false;
      }

      final number = int.tryParse(octet);
      return number != null && number >= 0 && number <= 255;
    });
  }

  static String? _formatPrivateIp(String digits) {
    if (digits.startsWith('192168')) {
      return _findValidIp(
        digits,
        fixedOctets: const ['192', '168'],
        preferLargestOctets: true,
      );
    }

    if (digits.startsWith('10')) {
      return _findValidIp(
        digits,
        fixedOctets: const ['10'],
        preferLargestOctets: true,
      );
    }

    if (digits.startsWith('172') && digits.length >= 5) {
      final secondOctet = int.tryParse(digits.substring(3, 5));

      if (secondOctet != null && secondOctet >= 16 && secondOctet <= 31) {
        return _findValidIp(
          digits,
          fixedOctets: ['172', '$secondOctet'],
          preferLargestOctets: true,
        );
      }
    }

    return null;
  }

  static String? _findValidIp(
    String digits, {
    List<String> fixedOctets = const [],
    bool preferLargestOctets = false,
  }) {
    final remainingDigits = digits.substring(fixedOctets.join().length);
    final remainingOctets = 4 - fixedOctets.length;
    final result = _splitOctets(
      remainingDigits,
      remainingOctets,
      preferLargestOctets: preferLargestOctets,
    );

    if (result == null) {
      return null;
    }

    return [...fixedOctets, ...result].join('.');
  }

  static List<String>? _splitOctets(
    String digits,
    int octetsLeft, {
    bool preferLargestOctets = false,
  }) {
    if (octetsLeft == 0) {
      return digits.isEmpty ? <String>[] : null;
    }

    final maxSize = digits.length < 3 ? digits.length : 3;
    final sizes = preferLargestOctets
        ? [for (var size = maxSize; size >= 1; size--) size]
        : [for (var size = 1; size <= maxSize; size++) size];

    for (final size in sizes) {
      final octet = digits.substring(0, size);

      if (!_isValidOctet(octet)) {
        continue;
      }

      final remaining = digits.substring(size);
      final minLength = octetsLeft - 1;
      final maxLength = (octetsLeft - 1) * 3;

      if (remaining.length < minLength || remaining.length > maxLength) {
        continue;
      }

      final next = _splitOctets(
        remaining,
        octetsLeft - 1,
        preferLargestOctets: preferLargestOctets,
      );

      if (next != null) {
        return [octet, ...next];
      }
    }

    return null;
  }

  static bool _isValidOctet(String value) {
    if (value.length > 1 && value.startsWith('0')) {
      return false;
    }

    final number = int.tryParse(value);
    return number != null && number >= 0 && number <= 255;
  }
}

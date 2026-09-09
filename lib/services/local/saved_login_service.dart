import 'package:shared_preferences/shared_preferences.dart';

class SavedLoginData {
  final int userId;
  final String username;
  final String password;

  const SavedLoginData({
    required this.userId,
    required this.username,
    required this.password,
  });
}

class SavedLoginService {
  static const String _userIdKey = 'saved_user_id';
  static const String _usernameKey = 'saved_username';
  static const String _passwordKey = 'saved_password';

  Future<void> saveCredentials({
    required int userId,
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_passwordKey, password);
  }

  Future<SavedLoginData?> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_userIdKey);
    final username = prefs.getString(_usernameKey);
    final password = prefs.getString(_passwordKey);

    if (userId == null || username == null || password == null) {
      return null;
    }

    if (userId <= 0 || username.isEmpty || password.isEmpty) {
      return null;
    }

    return SavedLoginData(userId: userId, username: username, password: password);
  }

  Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_passwordKey);
  }
}

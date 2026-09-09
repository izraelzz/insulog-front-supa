class Globals {
  Globals._();

  static final Globals _instance = Globals._();

  factory Globals() => _instance;

  int _userId = 0;
  String _username = '';

  int get userId => _userId;
  String get username => _username;

  void setUserId(int id) {
    _userId = id;
  }

  void setUsername(String name) {
    _username = name;
  }

  void clearUsername() {
    _userId = 0;
    _username = '';
  }
}

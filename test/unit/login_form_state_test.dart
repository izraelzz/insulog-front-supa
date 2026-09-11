import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insulog/states/login_form_state.dart';

void main() {
  late LoginFormState state;
  setUp(() => state = LoginFormState());
  tearDown(() => state.dispose());

  test('login inicia sem erros e sem carregamento', () {
    expect(state.usernameError, isNull);
    expect(state.passwordError, isNull);
    expect(state.isClicked, isFalse);
    expect(state.isLoading, isFalse);
  });

  test('usuario e senha exigem tres caracteres e avisam os ouvintes', () {
    var notifications = 0;
    state.addListener(() => notifications++);
    state.usernameController.text = 'ab';
    state.passwordController.text = '12';
    expect(state.usernameError, 'O nome deve ter pelo menos 3 caracteres');
    expect(state.passwordError, 'A senha deve ter pelo menos 3 caracteres');
    state.usernameController.text = 'ana';
    state.passwordController.text = '123';
    expect(state.usernameError, isNull);
    expect(state.passwordError, isNull);
    expect(notifications, greaterThanOrEqualTo(4));
  });

  test('campos vazios so mostram obrigatoriedade depois da tentativa', () {
    state.usernameController.text = 'ana';
    state.passwordController.text = '123';
    state.usernameController.clear();
    state.passwordController.clear();
    expect(state.usernameError, isNull);
    expect(state.passwordError, isNull);
    state.isClicked = true;
    state.usernameController.text = 'ana';
    state.passwordController.text = '123';
    state.usernameController.clear();
    state.passwordController.clear();
    expect(state.usernameError, 'Campo obrigatorio');
    expect(state.passwordError, 'Campo obrigatorio');
  });

  test('editar texto limpa erro de autenticacao somente do campo editado', () {
    state.usernameController.text = 'ana';
    state.passwordController.text = '123';
    state.usernameAuthError = 'Usuario incorreto';
    state.passwordAuthError = 'Senha incorreta';
    state.usernameController.text = 'maria';
    expect(state.usernameAuthError, isNull);
    expect(state.passwordAuthError, 'Senha incorreta');
    state.passwordController.text = '456';
    expect(state.passwordAuthError, isNull);
  });

  test('mover cursor nao apaga erro de autenticacao', () {
    state.usernameController.text = 'ana';
    state.usernameAuthError = 'Usuario incorreto';
    state.usernameController.selection = const TextSelection.collapsed(
      offset: 1,
    );
    expect(state.usernameError, 'Usuario incorreto');
  });

  test('limpar login remove credenciais, erros e estado de tentativa', () {
    state.usernameController.text = 'ana';
    state.passwordController.text = '123';
    state.usernameAuthError = 'Usuario incorreto';
    state.passwordAuthError = 'Senha incorreta';
    state.loginError = 'Falha simulada';
    state.isClicked = true;
    state.isLoading = true;
    state.clear();
    expect(state.username, isEmpty);
    expect(state.password, isEmpty);
    expect(state.usernameError, isNull);
    expect(state.passwordError, isNull);
    expect(state.loginError, isNull);
    expect(state.isClicked, isFalse);
    expect(state.isLoading, isFalse);
  });
}

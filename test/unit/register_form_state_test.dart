import 'package:flutter_test/flutter_test.dart';
import 'package:insulog/states/register_form_state.dart';

void main() {
  late RegisterFormState state;
  setUp(() => state = RegisterFormState());
  tearDown(() => state.dispose());

  test('cadastro inicia sem mensagens de erro', () {
    expect(state.formErrors, isEmpty);
    expect(state.isLoading, isFalse);
  });

  test('nome e senha validam limite de tres caracteres', () {
    state.usernameController.text = 'ab';
    state.passwordController.text = '12';
    expect(state.formErrors, [
      'O nome deve ter pelo menos 3 caracteres',
      'A senha deve ter pelo menos 3 caracteres',
    ]);
    state.usernameController.text = 'ana';
    state.passwordController.text = '123';
    expect(state.formErrors, isEmpty);
  });

  test('sobrenome e opcional, mas exige tres caracteres quando preenchido', () {
    state.lastnameController.text = 'ab';
    expect(state.lastnameError, 'O sobrenome deve ter pelo menos 3 caracteres');
    state.lastnameController.text = 'abc';
    expect(state.lastnameError, isNull);
    state.lastnameController.clear();
    expect(state.lastnameError, isNull);
  });

  test('email rejeita formatos incompletos e aceita endereco valido', () {
    for (final value in ['ana', 'ana@', 'ana@example', '@example.com']) {
      state.emailController.text = value;
      expect(state.emailError, 'Digite um email valido', reason: value);
    }
    state.emailController.text = 'ana.silva@example.com';
    expect(state.emailError, isNull);
  });

  test('apos tentativa, nome, email e senha vazios exibem obrigatoriedade', () {
    state.isClicked = true;
    state.usernameController.text = 'ana';
    state.emailController.text = 'ana@example.com';
    state.passwordController.text = '123';
    state.usernameController.clear();
    state.emailController.clear();
    state.passwordController.clear();
    expect(state.usernameError, 'Campo obrigatorio');
    expect(state.emailError, 'Campo obrigatorio');
    expect(state.passwordError, 'Campo obrigatorio');
    expect(state.lastnameError, isNull);
    expect(state.formErrors, hasLength(3));
  });

  test('clear remove dados pessoais, mensagens e carregamento', () {
    state.usernameController.text = 'ana';
    state.lastnameController.text = 'silva';
    state.emailController.text = 'invalido';
    state.passwordController.text = '123';
    state.registerError = 'Falha simulada';
    state.isLoading = true;
    state.clear();
    expect([
      state.username,
      state.lastname,
      state.email,
      state.password,
    ], everyElement(isEmpty));
    expect(state.formErrors, isEmpty);
    expect(state.registerError, isNull);
    expect(state.isLoading, isFalse);
  });
}

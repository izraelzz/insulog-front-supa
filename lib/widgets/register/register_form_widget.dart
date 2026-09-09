import 'package:flutter/material.dart';
import 'package:insulog/states/register_form_state.dart';
import 'package:insulog/widgets/custom_button_widget.dart';
import 'package:insulog/widgets/input_text_widget.dart';

class Registerform extends StatefulWidget {
  final RegisterFormState registerFormState;
  final Size size;

  const Registerform({
    super.key,
    required this.size,
    required this.registerFormState,
  });

  @override
  State<Registerform> createState() => _RegisterformState();
}

class _RegisterformState extends State<Registerform> {
  @override
  void initState() {
    super.initState();
    widget.registerFormState.addListener(handleNotify);
  }

  void handleNotify() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    widget.registerFormState.removeListener(handleNotify);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InputTextWidget(
                    size: widget.size,
                    label: 'Nome',
                    controller: widget.registerFormState.usernameController,
                    placeholder: 'Nome de Usuario',
                    isPassword: false,
                    errorMessage: widget.registerFormState.usernameError,
                  ),
                ),
                SizedBox(width: widget.size.width * 0.04, ),
                Expanded(
                  child: InputTextWidget(
                    size: widget.size,
                    label: 'Sobrenome',
                    controller: widget.registerFormState.lastnameController,
                    placeholder: 'Sobrenome',
                    isPassword: false,
                    errorMessage: widget.registerFormState.lastnameError,
                  ),
                ),
              ],
            ),
               SizedBox(height: widget.size.height * 0.025),
            InputTextWidget(
              size: widget.size,
              label: 'Email',
              controller: widget.registerFormState.emailController,
              placeholder: 'Digite seu email',
              isPassword: false,
              errorMessage: widget.registerFormState.emailError,
            ),
             SizedBox(height: widget.size.height * 0.025),
            InputTextWidget(
              size: widget.size,
              label: 'Senha',
              controller: widget.registerFormState.passwordController,
              placeholder: 'Digite sua senha',
              isPassword: true,
              errorMessage: widget.registerFormState.passwordError,
            ),
          ],
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: widget.size.height * 0.02,
                 
              ),
              height: widget.size.height * 0.06,
              child: CustomButtonWidget(
                onPressed: () => widget.registerFormState.register(context),
                text: "Cadastrar",
                isFontBold: true,
                isLoading: widget.registerFormState.isLoading,
                textSize: widget.size.height * 0.025,
                textColor: Colors.white,
                onpressTextColor: Colors.grey[600]!,
                onpressBoxShadow: BoxShadow(
                  color: Colors.black.withOpacity(0),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
                boxShadow: BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 2),
                ),
                colorGradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 71, 204, 113),
                    const Color(0xFF3EA75F),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                onpressColorGradient: LinearGradient(
                  colors: [const Color(0xFF3EA75F), const Color(0xFF3EA75F)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.all(Radius.circular(200)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: widget.size.height * 0.02,
                
              ),
              height: widget.size.height * 0.06,
              child: CustomButtonWidget(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Navigator.pop(context);
                },
                text: "Voltar",
                icon: Icons.arrow_back_ios_sharp,
                iconColor: const Color(0xFF3EA75F),
                isFontBold: true,
                textSize: widget.size.height * 0.025,
                textColor: const Color(0xFF3EA75F),
                onpressTextColor: const Color(0xFF3EA75F),
                onpressBoxShadow: BoxShadow(
                  color: Colors.black.withOpacity(0),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),

                border: Border.all(color: const Color(0xFF3EA75F), width: 1),
                borderRadius: BorderRadius.all(Radius.circular(200)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

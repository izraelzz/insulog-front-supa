import 'package:flutter/material.dart';
import 'package:insulog/states/register_form_state.dart';
import 'package:insulog/widgets/custom_button_widget.dart';
import 'package:insulog/widgets/horizontal_line_green_widget.dart';
import 'package:insulog/widgets/main_body_widget.dart';
import 'package:insulog/widgets/register/register_form_widget.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late final RegisterFormState registerFormState;

  @override
  void initState() {
    super.initState();
    registerFormState = RegisterFormState();
  }

  @override
  void dispose() {
    registerFormState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MainBody(
        children: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: size.height * 0.2,
              child: Center(
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Color(0xFF65ff95), Color(0xFF3ea75f)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                    ,
                  ).createShader(bounds),
                  child: Text(
                    "Criar Conta",
                    style: TextStyle(
                      fontSize: size.height * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: 
                Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: Registerform(size: size, registerFormState: registerFormState,)),
              ),
            ),

            HorizontalLineGreenWidget(text: "Continuar com"),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: size.width * 0.1,
                vertical: size.height * 0.03,
              ),
              padding: EdgeInsets.all(size.width * 0.02),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(200)),
              ),
              child: CustomButtonWidget(
                svgPath: "assets/images/google_icon_svg.svg",
                iconSize: size.height * 0.04,
                text: "Cadastrar com Google",
                isFontBold: true,
                textSize: size.height * 0.025,
                textColor: Colors.black.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

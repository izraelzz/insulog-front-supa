import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insulog/states/login_form_state.dart';
import 'package:insulog/widgets/config_ip_button_widget.dart';
import 'package:insulog/widgets/custom_button_widget.dart';
import 'package:insulog/widgets/horizontal_line_green_widget.dart';
import 'package:insulog/widgets/login/login_form_widget.dart';
import 'package:insulog/widgets/main_body_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginFormState loginFormState;
  bool isCheckingSavedLogin = true;

  @override
  void initState() {
    super.initState();
    loginFormState = LoginFormState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
      _checkSavedLogin();
    });
  }

  Future<void> _checkSavedLogin() async {
    await loginFormState.tryAutoLogin(context);

    if (!mounted) return;

    setState(() {
      isCheckingSavedLogin = false;
    });
  }

  @override
  void dispose() {
    loginFormState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (isCheckingSavedLogin) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MainBody(
        children: Stack(
          children: [
            Positioned(
              top: 10,
              right: 10,
              child: const ConfigIpButtonWidget(),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: size.height * 0.25,
                  child: Center(
                    child: SizedBox(
                      width: size.width * 0.7,
                      child: SvgPicture.asset(
                        'assets/images/insulogLogoSVG.svg',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: size.width * 0.1,
                      ),
                      child: Loginform(
                        size: size,
                        loginFormState: loginFormState,
                      ),
                    ),
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
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/home'),
                    svgPath: "assets/images/google_icon_svg.svg",
                    iconSize: size.height * 0.04,
                    text: "Entrar com Google",
                    isFontBold: true,
                    textSize: size.height * 0.025,
                    textColor: Colors.black.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

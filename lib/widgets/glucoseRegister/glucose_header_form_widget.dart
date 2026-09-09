import 'package:flutter/material.dart';
import 'package:insulog/states/glucose_record_form_screen_state.dart';
import 'package:insulog/widgets/custom_button_widget.dart';

class GlucoseHeaderFormWidget extends StatelessWidget {
  final Size size;
  final int step;
  final GlucoseRecordFormScreenState state;

  const GlucoseHeaderFormWidget({
    super.key,
    required this.size,
    required this.step,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final bool glicosePreenchida = state.glicosePreenchida;
    final bool periodoPreenchido = state.periodoPreenchido;
    final bool insulinaPreenchida = state.insulinaPreenchida;
    final bool isErroGlicose = state.isErroGlicose;
    final bool isErroInsulina = state.isErroInsulina;
    final bool isErroPeriodo = state.isErroPeriodo;

    return SizedBox(
      height: size.height * 0.2,
      child: Stack(
        children: [
          Positioned(
            top: 10,
            right: 10,
            child: SizedBox(
              width: size.width * 0.15,
              child: CustomButtonWidget(
                isFontBold: true,
                inversePosition: true,
                textSize: size.height * 0.025,
                textColor: Color.fromARGB(255, 255, 0, 0),
                icon: Icons.close,
                iconColor: Color.fromARGB(255, 255, 0, 0),
                iconSize: size.height * 0.035,
                onPressed: () => Navigator.pop(context),
                bgColor: Color.fromARGB(255, 255, 0, 0).withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(100),
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(10),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Center(
                  // child:
                  // ShaderMask(
                  //   shaderCallback: (bounds) => LinearGradient(
                  //     colors: [Color(0xFF65ff95), Color(0xFF3ea75f)],
                  //     begin: Alignment.topCenter,
                  //     end: Alignment.bottomCenter,
                  //   ).createShader(bounds),
                  child: Text(
                    "Novo Registro",
                    style: TextStyle(
                      fontSize: size.height * 0.045,
                      fontWeight: FontWeight.bold,
                      // color: Colors.white,
                    ),
                    // ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          AnimatedContainer(
                            width: step == 0
                                ? size.width * 0.3
                                : size.width * 0.18,
                            height: size.height * 0.005,
                            color: isErroGlicose
                                ? const Color(0xFFFF0000)
                                : glicosePreenchida
                                ? const Color(0xFF3EA75F)
                                : const Color.fromARGB(255, 192, 192, 192),
                            duration: const Duration(milliseconds: 300),
                          ),
                          SizedBox(height: size.height * 0.005),
                          AnimatedScale(
                            scale: step == 0 ? 1.3 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              "Glicose",
                              style: TextStyle(
                                color:isErroGlicose
                                ? const Color(0xFFFF0000)
                                : step == 0
                                    ? const Color(0xFF3EA75F)
                                    : null,
                                fontWeight: step == 0
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          AnimatedContainer(
                            width: step == 1
                                ? size.width * 0.3
                                : size.width * 0.18,
                            height: size.height * 0.005,
                            color: isErroPeriodo
                                ? const Color(0xFFFF0000)
                                : periodoPreenchido
                                ? const Color(0xFF3EA75F)
                                : const Color.fromARGB(255, 192, 192, 192),
                            duration: const Duration(milliseconds: 300),
                          ),
                          SizedBox(height: size.height * 0.005),
                          AnimatedScale(
                            scale: step == 1 ? 1.3 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              "Período",
                              style: TextStyle(
                                color: isErroPeriodo
                                    ? const Color(0xFFFF0000)
                                    : step == 1
                                        ? const Color(0xFF3EA75F)
                                        : null,
                                fontWeight: step == 1
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          AnimatedContainer(
                            width: step == 2
                                ? size.width * 0.3
                                : size.width * 0.18,
                            height: size.height * 0.005,
                            color: isErroInsulina
                                ? const Color(0xFFFF0000)
                                : insulinaPreenchida
                                ? const Color(0xFF3EA75F)
                                : const Color.fromARGB(255, 192, 192, 192),
                            duration: const Duration(milliseconds: 300),
                          ),
                          SizedBox(height: size.height * 0.005),
                          AnimatedScale(
                            scale: step == 2 ? 1.3 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              "Insulina",
                              style: TextStyle(
                                color: isErroInsulina
                                    ? const Color(0xFFFF0000)
                                    : step == 2
                                        ? const Color(0xFF3EA75F)
                                        : null,
                                fontWeight: step == 2
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          AnimatedContainer(
                            width: step == 3
                                ? size.width * 0.3
                                : size.width * 0.18,
                            height: size.height * 0.005,
                            color: const Color.fromARGB(255, 192, 192, 192),
                            duration: const Duration(milliseconds: 300),
                          ),
                          SizedBox(height: size.height * 0.005),
                          AnimatedScale(
                            scale: step == 3 ? 1.3 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              "Confirmar",
                              style: TextStyle(
                                color: step == 3
                                    ? const Color(0xFF3EA75F)
                                    : null,
                                fontWeight: step == 3
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:insulog/states/glucose_record_form_screen_state.dart';
import 'package:insulog/widgets/container_card_widget.dart';
import 'package:insulog/widgets/custom_button_widget.dart';

class TipoInsulinaCardWidget extends StatelessWidget {
  final Size size;
  final GlucoseRecordFormScreenState state;

  const TipoInsulinaCardWidget({
    super.key,
    required this.size,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerCardWidget(
      heightFactor: 0.17,
      widthFactor: 0.9,
      size: size,
      isMarginTop: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.006),
            child: Text(
              'Tipo de Insulina',
              style: TextStyle(
                fontSize: size.width * 0.06,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: size.width * 0.3,
                    height: size.height * 0.09,
                    child: CustomButtonWidget(
                      text: 'Ultra-Rápida',
                      bgColor: Colors.transparent,
                      onpressBgColor: Color(0xFF3EA75F),
                      border: Border.all(color: Color(0xFF3EA75F)),
                      borderRadius: BorderRadius.circular(20),
                      textColor: Color(0xFF3EA75F),
                      onpressTextColor: Colors.white,
                      isFontBold: true,
                      textSize: size.width * 0.045,
                      selected: state.tipoInsulinaId == 1,
                      isSelectedUnlocked: true,
                      isColumn: true,
                      icon: Icons.bolt,
                      iconSize: size.width * 0.08,
                      iconColor: Color(0xFF3EA75F),
                      onpressIconColor: Colors.white,
                      onPressed: () => state.atualizarTipoInsulina(1, true),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.2,
                    height: size.height * 0.09,
                    child: CustomButtonWidget(
                      text: 'Rápida',
                      bgColor: Colors.transparent,
                      onpressBgColor: Color(0xFF3EA75F),
                      border: Border.all(color: Color(0xFF3EA75F)),
                      borderRadius: BorderRadius.circular(20),
                      textColor: Color(0xFF3EA75F),
                      onpressTextColor: Colors.white,
                      isFontBold: true,
                      textSize: size.width * 0.045,
                      selected: state.tipoInsulinaId == 2,
                      isSelectedUnlocked: true,
                      isColumn: true,
                      icon: Icons.speed,
                      iconSize: size.width * 0.08,
                      iconColor: Color(0xFF3EA75F),
                      onpressIconColor: Colors.white,
                      onPressed: () => state.atualizarTipoInsulina(2 , true),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.2,
                    height: size.height * 0.09,
                    child: CustomButtonWidget(
                      text: 'Lenta',
                      bgColor: Colors.transparent,
                      onpressBgColor: Color(0xFF3EA75F),
                      border: Border.all(color: Color(0xFF3EA75F)),
                      borderRadius: BorderRadius.circular(20),
                      textColor: Color(0xFF3EA75F),
                      onpressTextColor: Colors.white,
                      isFontBold: true,
                      textSize: size.width * 0.045,
                      selected: state.tipoInsulinaId == 3,
                      isSelectedUnlocked: true,
                      isColumn: true,
                      icon: Icons.schedule,
                      iconSize: size.width * 0.08,
                      iconColor: Color(0xFF3EA75F),
                      onpressIconColor: Colors.white,
                      onPressed: () => state.atualizarTipoInsulina(3, true),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

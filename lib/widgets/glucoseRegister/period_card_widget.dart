import 'package:flutter/material.dart';
import 'package:insulog/states/glucose_record_form_screen_state.dart';
import 'package:insulog/widgets/container_card_widget.dart';
import 'package:insulog/widgets/custom_button_widget.dart';

class PeriodCardWidget extends StatelessWidget {
  final Size size;
  final GlucoseRecordFormScreenState state;

  const PeriodCardWidget({super.key, required this.size, required this.state});

  @override
  Widget build(BuildContext context) {
    return ContainerCardWidget(
      heightFactor: 0.35,
      widthFactor: 0.9,
      size: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Período',
            style: TextStyle(
              fontSize: size.width * 0.06,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: size.width * 0.37,
                        height: size.height * 0.11,
                        child: CustomButtonWidget(
                          text: 'Jejum',
                          isColumn: true,
                          bgColor: Colors.transparent,
                          onpressBgColor: Color(0xFF3EA75F),
                          border: Border.all(color: Color(0xFF3EA75F)),
                          borderRadius: BorderRadius.circular(20),
                          textColor: Color(0xFF3EA75F),
                          onpressTextColor: Colors.white,
                          isFontBold: true,
                          textSize: size.width * 0.045,
                          selected: state.periodoId == 1,
                          iconSize: size.width * 0.08,
                          icon: Icons.wb_twilight,
                          iconColor: Color(0xFF3EA75F),
                          onpressIconColor: Colors.white,
                          onPressed: () => state.atualizarPeriodo(1),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.37,
                        height: size.height * 0.11,
                        child: CustomButtonWidget(
                          text: 'Pré-Prandial',
                          isColumn: true,
                          bgColor: Colors.transparent,
                          onpressBgColor: Color(0xFF3EA75F),
                          border: Border.all(color: Color(0xFF3EA75F)),
                          borderRadius: BorderRadius.circular(20),
                          textColor: Color(0xFF3EA75F),
                          onpressTextColor: Colors.white,
                          isFontBold: true,
                          textSize: size.width * 0.045,
                          selected: state.periodoId == 2,
                          iconSize: size.width * 0.08,
                          icon: Icons.restaurant,
                          iconColor: Color(0xFF3EA75F),
                          onpressIconColor: Colors.white,
                          onPressed: () => state.atualizarPeriodo(2),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: size.width * 0.37,
                        height: size.height * 0.11,
                        child: CustomButtonWidget(
                          text: 'Pós-Prandial',
                          isColumn: true,
                          bgColor: Colors.transparent,
                          onpressBgColor: Color(0xFF3EA75F),
                          border: Border.all(color: Color(0xFF3EA75F)),
                          borderRadius: BorderRadius.circular(20),
                          textColor: Color(0xFF3EA75F),
                          onpressTextColor: Colors.white,
                          isFontBold: true,
                          textSize: size.width * 0.045,
                          selected: state.periodoId == 3,
                          iconSize: size.width * 0.08,
                          icon: Icons.local_dining,
                          iconColor: Color(0xFF3EA75F),
                          onpressIconColor: Colors.white,
                          onPressed: () => state.atualizarPeriodo(3),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.37,
                        height: size.height * 0.11,
                        child: CustomButtonWidget(
                          text: 'Noturna',
                          isColumn: true,
                          bgColor: Colors.transparent,
                          onpressBgColor: Color(0xFF3EA75F),
                          border: Border.all(color: Color(0xFF3EA75F)),
                          borderRadius: BorderRadius.circular(20),
                          textColor: Color(0xFF3EA75F),
                          onpressTextColor: Colors.white,
                          isFontBold: true,
                          textSize: size.width * 0.045,
                          selected: state.periodoId == 4,
                          iconSize: size.width * 0.08,
                          icon: Icons.nights_stay,
                          iconColor: Color(0xFF3EA75F),
                          onpressIconColor: Colors.white,
                          onPressed: () => state.atualizarPeriodo(4),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  state.returnTextPeriodo(),
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 170, 170, 170),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:insulog/states/clock_state.dart';
import 'package:insulog/widgets/custom_button_widget.dart';
import 'package:insulog/widgets/dotted_line_widget.dart';

class ClockRegisterHeaderWidget extends StatelessWidget {
  final Size size;
  final ClockState state;

  const ClockRegisterHeaderWidget({super.key, required this.size, required this.state});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3EA75F);
    const titleColor = Color(0xFF171717);
    const secondaryColor = Color(0xFF6B6B6B);

    return Stack(
      children: [ Positioned(
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
        Container(
          height: size.height * 0.12,
          padding: EdgeInsets.fromLTRB(
            size.width * 0.06,
            size.height * 0.025,
            size.width * 0.06,
            size.height * 0.022,
          ),
          child: SizedBox(
            height: size.height * 0.1,
            child: Center(
              child: Text(
                state.isEditing ? 'Editar Lembrete' : 'Novo Lembrete',
                style: TextStyle(
                  fontSize: 28,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

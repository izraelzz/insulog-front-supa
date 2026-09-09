import 'package:flutter/material.dart';
import 'package:insulog/states/clock_state.dart';

class ClockHeaderWidget extends StatelessWidget {
  final Size size;
  final ClockState state;

  const ClockHeaderWidget({super.key, required this.size, required this.state});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3EA75F);
    const titleColor = Color(0xFF171717);
    const secondaryColor = Color(0xFF6B6B6B);

    return Container(
      height: size.height * 0.25,
      padding: EdgeInsets.fromLTRB(
        size.width * 0.06,
        size.height * 0.025,
        size.width * 0.06,
        size.height * 0.022,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // SizedBox(width: size.width * 0.035),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: size.width * 0.15,
                      height: size.width * 0.15,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.alarm_outlined,
                        color: primaryColor,
                        size: 27,
                      ),
                    ),
                    SizedBox(width: size.width * 0.03),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lembretes',
                          style: TextStyle(
                            fontSize: 28,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                            color: titleColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Alarmes e horários',
                          style: TextStyle(
                            fontSize: size.width * 0.045,
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: size.height * 0.022),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: primaryColor.withOpacity(0.6),
                  width: 2,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.08,
                width: size.width * 0.85,
                child: Column(
                  children: [
                    Text(
                      state.infoLembrete(true) == 'Sem Lembretes ativos'
                          ? 'Sem Lembretes ativos'
                          : "Próximo alarme: ${state.infoLembrete(true)}",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: size.width * 0.055,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                    Text(
                      state.infoLembrete(true) == 'Sem Lembretes ativos'
                          ? ''
                          : state.infoLembrete(false),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: size.width * 0.055,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

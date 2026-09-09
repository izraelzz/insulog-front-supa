import 'package:flutter/material.dart';
import 'package:insulog/states/clock_state.dart';
import 'package:insulog/widgets/clock/alarm_period_dropdown_widget.dart';
import 'package:insulog/widgets/clock/clock_option_tile_widget.dart';
import 'package:insulog/widgets/clock/clock_selection_card_widget.dart';
import 'package:insulog/widgets/clock/number_wheel_picker_widget.dart';
import 'package:insulog/widgets/clock/weekday_selector_widget.dart';
import 'package:insulog/widgets/custom_container_widget.dart';

class ClockBodyWidget extends StatefulWidget {
  const ClockBodyWidget({super.key});

  @override
  State<ClockBodyWidget> createState() => _ClockBodyWidgetState();
}

class _ClockBodyWidgetState extends State<ClockBodyWidget> {
  final stateClock = ClockState(); 

  @override
  void initState() {
    super.initState(); 
  }

  void handleNotify() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() { 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CustomContainerWidget(
      width: size.width,
      innerShadow: const InnerShadow(
        color: Color.fromARGB(80, 0, 0, 0),
        blurRadius: 2,
        offset: Offset(0, 2),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size.width * 0.1),
          topRight: Radius.circular(size.width * 0.1),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          size.width * 0.05,
          size.height * 0.025,
          size.width * 0.05,
          size.height * 0.12,
        ),
        child: Column(
          children: [
            Container(
              width: size.width * 0.9,
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.045,
                vertical: size.height * 0.01,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size.width * 0.05),
                border: Border(),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 104, 104, 104),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Horário',
                    style: TextStyle(
                      fontSize: size.width * 0.052,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF171717),
                    ),
                  ),
                  SizedBox(height: size.height * 0.018),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Horas',
                            style: TextStyle(
                              fontSize: size.width * 0.038,
                              color: const Color(0xFF6B6B6B),
                            ),
                          ),
                          NumberWheelPickerWidget(
                            value: stateClock.novoAlarme.hora,
                            minimum: 0,
                            maximum: 23,
                            width: size.width * 0.25,
                            height: size.height * 0.19,
                            onChanged: stateClock.updateNewAlarmHour,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.025,
                          left: size.width * 0.035,
                          right: size.width * 0.035,
                        ),
                        child: Text(
                          ':',
                          style: TextStyle(
                            fontSize: size.width * 0.1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'Minutos',
                            style: TextStyle(
                              fontSize: size.width * 0.038,
                              color: const Color(0xFF6B6B6B),
                            ),
                          ),
                          NumberWheelPickerWidget(
                            value: stateClock.novoAlarme.minuto,
                            minimum: 0,
                            maximum: 59,
                            width: size.width * 0.25,
                            height: size.height * 0.19,
                            onChanged: stateClock.updateNewAlarmMinute,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Container(
              width: size.width * 0.9,
              padding: EdgeInsets.only(
                right: size.width * 0.045,
                left: size.width * 0.045,
                top: size.height * 0.01,
                bottom: size.height * 0.02,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size.width * 0.05),
                border: Border(),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 104, 104, 104),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: ClockSelectionCardWidget(
                title: 'Dias da semana',
                child: WeekdaySelectorWidget(
                  selectedDays: stateClock.novoAlarme.diasSemana,
                  onChanged: stateClock.updateNewAlarmDays,
                ),
              ),
            ),

            SizedBox(height: size.height * 0.02),
            Container(
              width: size.width * 0.9,
              padding: EdgeInsets.only(
                right: size.width * 0.045,
                left: size.width * 0.045,
                top: size.height * 0.01,
                bottom: size.height * 0.02,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size.width * 0.05),
                border: Border(),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 104, 104, 104),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                    ),
                    child: ClockSelectionCardWidget(
                      title: 'Período',
                      child: AlarmPeriodDropdownWidget(
                        selectedPeriod: stateClock.novoAlarme.periodoId,
                        onChanged: stateClock.updateNewAlarmPeriod,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Container(
              width: size.width * 0.9,
              padding: EdgeInsets.only(
                right: size.width * 0.045,
                left: size.width * 0.045,
                top: size.height * 0.01,
                bottom: size.height * 0.02,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size.width * 0.05),
                border: Border(),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 104, 104, 104),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ClockOptionTileWidget(
                    title: 'Som',
                    icon: Icons.volume_up_outlined,
                    value: stateClock.novoAlarme.som,
                    onChanged: stateClock.updateNewAlarmSound,
                  ),
                  ClockOptionTileWidget(
                    title: 'Vibração',
                    icon: Icons.vibration,
                    value: stateClock.novoAlarme.vibracao,
                    onChanged: stateClock.updateNewAlarmVibration,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

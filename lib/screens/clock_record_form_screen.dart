import 'package:flutter/material.dart';
import 'package:insulog/DTO/ENUMs/enum_clock_register.dart';
import 'package:insulog/states/clock_state.dart';
import 'package:insulog/widgets/clock/clock_body_widget.dart';
import 'package:insulog/widgets/clock/clock_register_header_widget.dart';
import 'package:insulog/widgets/custom_button_widget.dart';
import 'package:insulog/widgets/main_body_widget.dart';

class ClockRegisterScreen extends StatefulWidget {
  const ClockRegisterScreen({super.key});

  @override
  State<ClockRegisterScreen> createState() => _ClockRegisterScreenState();
}

class ClockRegisterFormEditArgs {
  final EnumClockRegister alarm;

  const ClockRegisterFormEditArgs({required this.alarm});
}

class _ClockRegisterScreenState extends State<ClockRegisterScreen> {
  final stateClock = ClockState();
  bool _loadedRouteArgs = false;

  @override
  void initState() {
    super.initState();
    stateClock.initializeNewAlarm();
    stateClock.addListener(handleNotify);
  }

  void handleNotify() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    stateClock.removeListener(handleNotify);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loadedRouteArgs) {
      return;
    }

    _loadedRouteArgs = true;
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is ClockRegisterFormEditArgs) {
      stateClock.initializeAlarmEditing(args.alarm);
    } else if (args is EnumClockRegister) {
      stateClock.initializeAlarmEditing(args);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: size.width * 0.4,
            height: size.height * 0.06,
            margin: const EdgeInsets.only(bottom: 15),
            child: CustomButtonWidget(
              text: stateClock.isSaving ? 'Salvando...' : 'Salvar',
              textSize: size.height * 0.025,
              isFontBold: true,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              selected: false,
              icon: Icons.save,
              iconColor: Color.fromARGB(255, 255, 255, 255),
              onpressIconColor: Color.fromARGB(255, 98, 98, 98),
              textColor: Color.fromARGB(255, 255, 255, 255),
              onpressTextColor:  Color.fromARGB(255, 98, 98, 98),
              bgColor: Color(0xFF3EA75F),
              onpressBgColor: Color.fromARGB(255, 158, 158, 158),

              onPressed: stateClock.isSaving
                  ? null
                  : () => stateClock.saveAlarm(context),
              boxShadow: BoxShadow(
                color: Color.fromARGB(80, 0, 0, 0),
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ),
          ),
        ],
      ),
      body: MainBody(
        children: Column(
          children: [
            ClockRegisterHeaderWidget(size: size, state: stateClock),

            Expanded(child: ClockBodyWidget()),
          ],
        ),
      ),
    );
  }
}

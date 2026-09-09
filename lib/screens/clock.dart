import 'package:flutter/material.dart';
import 'package:insulog/states/clock_state.dart';
import 'package:insulog/services/local/alarm_platform_service.dart';
import 'package:insulog/widgets/clock/clock_header_widget.dart';
import 'package:insulog/widgets/clock/clock_record_list_widget.dart';
import 'package:insulog/widgets/custom_button_widget.dart';
import 'package:insulog/widgets/custom_container_widget.dart';
import 'package:insulog/widgets/main_body_widget.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  final ClockState stateClock = ClockState();

  bool scheduling = false;

  @override
  initState() {
    super.initState();
    stateClock.addListener(handleNotify);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AlarmPlatformService.instance.ensurePermissions();
      stateClock.refreshClockRecords();
    });
  }

  void handleNotify() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  dispose() {
    stateClock.removeListener(handleNotify);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: SizedBox(
        width: size.width * 0.4,
        height: size.height * 0.08,
        child: CustomButtonWidget(
          onPressed: () async {
            final created = await Navigator.pushNamed(
              context,
              '/clock_register',
            );

            if (created == true && mounted) {
              await stateClock.refreshClockRecords();
            }
          },
          text: "Novo Registro",
          isFontBold: true,
          icon: Icons.add,
          textColor: Color.fromARGB(255, 255, 255, 255),
          onpressTextColor: Color.fromARGB(255, 255, 255, 255),
          bgColor: Color(0xFF3EA75F),
          onpressBgColor: Color.fromARGB(255, 31, 88, 49),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: BoxShadow(
            color: Color.fromARGB(80, 0, 0, 0),
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: MainBody(
        children: Column(
          children: [
            ClockHeaderWidget(size: size, state: stateClock),

            Expanded(
              child: CustomContainerWidget(
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
                child: RefreshIndicator(
                  onRefresh: stateClock.refreshClockRecords,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            size.width * 0.04,
                            size.height * 0.022,
                            size.width * 0.04,
                            size.height * 0.035,
                          ),
                          child: ClockRecordListWidget(
                            size: size,
                            state: stateClock,
                            records: stateClock.registros,
                            isLoading: stateClock.isLoading,
                            errorMessage: stateClock.errorMessage,
                          ),
                        ),
                        SizedBox(height: size.height * 0.08),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

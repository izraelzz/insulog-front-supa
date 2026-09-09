import 'package:flutter/material.dart';
import 'package:insulog/DTO/ENUMs/enum_form_registroGlicose.dart';
import 'package:insulog/states/glucose_record_form_screen_state.dart';
import 'package:insulog/widgets/custom_button_widget.dart';
import 'package:insulog/widgets/custom_container_widget.dart';
import 'package:insulog/widgets/glucoseRegister/glucose_header_form_widget.dart';
import 'package:insulog/widgets/glucoseRegister/step_confirm_form_widget.dart';
import 'package:insulog/widgets/glucoseRegister/step_glucose_form_widget.dart';
import 'package:insulog/widgets/glucoseRegister/step_insulina_form_widget.dart';
import 'package:insulog/widgets/glucoseRegister/step_period_form_widget.dart';
import 'package:insulog/widgets/main_body_widget.dart';

class GlucoseRecordFormScreen extends StatefulWidget {
  const GlucoseRecordFormScreen({super.key});

  @override
  State<GlucoseRecordFormScreen> createState() =>
      _GlucoseRecordFormScreenState();
}

class GlucoseRecordFormEditArgs {
  final int idRegistro;
  final NewRegistroGlicose registro;

  const GlucoseRecordFormEditArgs({
    required this.idRegistro,
    required this.registro,
  });
}

class _GlucoseRecordFormScreenState extends State<GlucoseRecordFormScreen> {
  final glucoseRecordFormState = GlucoseRecordFormScreenState();
  bool _loadedRouteArgs = false;

  @override
  void initState() {
    super.initState();
    glucoseRecordFormState.addListener(handleNotify);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      glucoseRecordFormState.refreshRecords();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loadedRouteArgs) {
      return;
    }

    _loadedRouteArgs = true;
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is GlucoseRecordFormEditArgs) {
      glucoseRecordFormState.iniciarEdicao(args.idRegistro, args.registro);
    }
  }

  void handleNotify() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    glucoseRecordFormState.removeListener(handleNotify);
    glucoseRecordFormState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final step = glucoseRecordFormState.step;
    final isConfirmStep = step == 3;
    final isCanRegister = isConfirmStep;

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
              text: 'Voltar',
              textSize: size.height * 0.025,
              isFontBold: step == 0 ? false : true,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              selected: step == 0,
              textColor: Color.fromARGB(255, 255, 255, 255),
              onpressTextColor: step == 0
                  ? Color.fromARGB(255, 98, 98, 98)
                  : Color.fromARGB(255, 255, 255, 255),
              bgColor: Color(0xFF3EA75F),
              onpressBgColor: Color.fromARGB(255, 158, 158, 158),
              onPressed: step == 0 ? null : glucoseRecordFormState.back,
              boxShadow: step == 0
                  ? null
                  : BoxShadow(
                      color: Color.fromARGB(80, 0, 0, 0),
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
            ),
          ),
          Container(
            width: size.width * 0.4,
            height: size.height * 0.06,
            margin: const EdgeInsets.only(bottom: 15),
            child: CustomButtonWidget(
              text: isCanRegister
                  ? glucoseRecordFormState.isEditing
                        ? 'Salvar'
                        : 'Registrar'
                  : 'Avançar',
              textSize: size.height * 0.025,
              isFontBold: true,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              selected: false,
              icon: isCanRegister ? Icons.save : null,
              iconColor: Color.fromARGB(255, 255, 255, 255),
              onpressIconColor: Color.fromARGB(255, 98, 98, 98),
              textColor: Color.fromARGB(255, 255, 255, 255),
              onpressTextColor: step == 3
                  ? Color.fromARGB(255, 98, 98, 98)
                  : Color.fromARGB(255, 255, 255, 255),
              bgColor: isConfirmStep ? Color(0xFF1E88E5) : Color(0xFF3EA75F),
              onpressBgColor: Color.fromARGB(255, 158, 158, 158),

              onPressed: () => glucoseRecordFormState.next(context),
              boxShadow: step == 3
                  ? null
                  : BoxShadow(
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
            GlucoseHeaderFormWidget(
              size: size,
              step: step,
              state: glucoseRecordFormState,
            ),
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
                child: Column(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: glucoseRecordFormState.controller,
                        physics:
                            const NeverScrollableScrollPhysics(), // só pelos botões
                        children: [
                          StepGlucoseFormWidget(
                            size: size,
                            state: glucoseRecordFormState,
                          ),
                          StepPeriodFormWidget(
                            size: size,
                            state: glucoseRecordFormState,
                          ),
                          StepInsulinaFormWidget(
                            size: size,
                            state: glucoseRecordFormState,
                          ),
                          StepConfirmFormWidget(
                            size: size,
                            state: glucoseRecordFormState,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

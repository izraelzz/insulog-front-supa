import 'package:flutter/material.dart';
import 'package:insulog/DTO/ENUMs/enum_registroGlicose.dart';
import 'package:insulog/states/glucose_record_form_screen_state.dart';
import 'package:insulog/widgets/custom_button_widget.dart';

class GlucoseRecordFormListWidget extends StatelessWidget {
  final Size size;
  final List<RegistroGlicose> records;
  final GlucoseRecordFormScreenState state;

  const GlucoseRecordFormListWidget({
    super.key,
    required this.size,
    required this.records,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.05),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(80, 0, 0, 0),
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width,
            margin: EdgeInsets.only(
              top: size.height * 0.01,
              left: size.width * 0.03,
              bottom: size.height * 0.01,
            ),
            child: Text(
              'Ultimos registros',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width * 0.06,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          records.isEmpty
              ? SizedBox(
                  width: size.width,
                  height: size.height * 0.3,
                  child: Center(
                    child: Text(
                      'Sem registros recentes',
                      style: TextStyle(
                        fontSize: size.width * 0.05,
                        color: const Color(0xFF4C4C4C),
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    ...records.map(
                      (record) => Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.018),
                        child: _GlucoseRecordCard(
                          size: size,
                          record: record,
                          state: state,
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

class _GlucoseRecordCard extends StatelessWidget {
  final Size size;
  final RegistroGlicose record;
  final GlucoseRecordFormScreenState state;

  const _GlucoseRecordCard({
    required this.size,
    required this.record,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Row(
        children: [
          Container(
            width: size.width * 0.045,
            height: size.width * 0.045,
            decoration: BoxDecoration(
              color: Color(record.colorStatus),
              shape: BoxShape.circle,
            ),
          ),
          // SizedBox(
          //   width: size.width * 0.2,
          //   child: Text(
          //     record.horaFormatada,
          //     style: TextStyle(
          //       fontSize: size.width * 0.055,
          //       color: const Color(0xFF4C4C4C),
          //       fontWeight: FontWeight.w400,
          //     ),
          //   ),
          // ),
          Expanded(
            child: SizedBox(
              width: size.width * 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${record.nivelGlicose}',
                    style: TextStyle(
                      height: 0,
                      fontSize: size.width * 0.07,
                      color: const Color(0xFF171717),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    ' mg/dL',
                    style: TextStyle(
                      height: 0,
                      fontSize: size.width * 0.05,
                      color: const Color(0xFF4C4C4C),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.2,
            child: CustomButtonWidget(
              text: 'Usar',
              textColor: Color(0xFF3EA75F),
              onpressTextColor: Color.fromARGB(255, 255, 255, 255),
              border: Border.all(color: Color(0xFF3EA75F)),
              borderRadius: BorderRadius.circular(100),
              onpressBgColor: Color(0xFF3EA75F),
              onPressed: () => state.usarRegistro(record.nivelGlicose),
            ),
          ),
        ],
      ),
    );
  }
}

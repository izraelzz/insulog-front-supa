import 'package:flutter/material.dart';
import 'package:insulog/states/glucose_record_form_screen_state.dart';
import 'package:insulog/widgets/container_card_widget.dart';
import 'package:insulog/widgets/dotted_line_widget.dart';
import 'package:insulog/widgets/glucoseRegister/glucose_record_form_list_widget.dart';
import 'package:insulog/widgets/glucoseRegister/glucose_register_form_widget.dart';

class StepGlucoseFormWidget extends StatelessWidget {
  final Size size;
  final GlucoseRecordFormScreenState state;
  const StepGlucoseFormWidget({
    super.key,
    required this.size,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      color: const Color(0xFFF2F2F2),
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: [
          ContainerCardWidget(
            heightFactor: 0.6,
            widthFactor: 0.9,
            size: size,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GlucoseRegisterFormWidget(
                        size: size,
                        state: state,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.height * 0.01,
                    bottom: size.height * 0.01,
                    left: size.width * 0.005,
                    right: size.width * 0.005,
                  ),
                  child: DottedLineWidget(
                    direction: Axis.horizontal,
                    length: size.width * 0.9,
                    thickness: 3,
                    dotSize: 4,
                    spacing: 6,
                    color: Color.fromARGB(80, 0, 0, 0),
                  ),
                ),
                GlucoseRecordFormListWidget(
                  size: size,
                  records: state.registrosGlicose,
                  state: state,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

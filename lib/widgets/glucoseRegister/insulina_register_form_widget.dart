import 'package:flutter/material.dart';
import 'package:insulog/states/glucose_record_form_screen_state.dart';
import 'package:insulog/widgets/custom_button_widget.dart';

class InsulinaRegisterFormWidget extends StatelessWidget {
  final Size size;
  final GlucoseRecordFormScreenState state;
  const InsulinaRegisterFormWidget({
    super.key,
    required this.size,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(top: size.height * 0.006),
          child: Text(
            'Insulina aplicada',
            style: TextStyle(
              fontSize: size.width * 0.06,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: size.width * 0.2,
              height: size.height * 0.08,
              child: CustomButtonWidget(
                icon: Icons.remove,
                iconColor: Color(0xFF3EA75F),
                onpressIconColor: Color.fromARGB(255, 255, 255, 255),
                border: Border.all(color: Color(0xFF3EA75F)),
                borderRadius: BorderRadius.circular(100),
                onpressBgColor: Color(0xFF3EA75F),
                onPressed: state.decrementarUnidadeInsulina,
                onTapDown: state.iniciarDecrementoContinuoInsulina,
                onTapUp: state.pararAlteracaoContinuaInsulina,
                onTapCancel: state.pararAlteracaoContinuaInsulina,
              ),
            ),
            SizedBox(
              width: size.width * 0.2,
              child: TextField(
                maxLines: 1,
                maxLength: 3,
                controller: state.insulinaImputController,
                keyboardType: TextInputType.number,
                onChanged: state.atualizarUnidadeInsulina,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.08,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  counterText: '',
                  hintText: '0',
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.2,
              height: size.height * 0.08,
              child: CustomButtonWidget(
                icon: Icons.add,
                iconColor: Color(0xFF3EA75F),
                onpressIconColor: Color.fromARGB(255, 255, 255, 255),
                border: Border.all(color: Color(0xFF3EA75F)),
                borderRadius: BorderRadius.circular(100),
                onpressBgColor: Color(0xFF3EA75F),
                onPressed: state.incrementarUnidadeInsulina,
                onTapDown: state.iniciarIncrementoContinuoInsulina,
                onTapUp: state.pararAlteracaoContinuaInsulina,
                onTapCancel: state.pararAlteracaoContinuaInsulina,
              ),
            ),
          ],
        ),
        Text(
          'INFORME A INSULINA APLICADA',
          style: TextStyle(
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 170, 170, 170),
          ),
        ),
      ],
    );
  }
}

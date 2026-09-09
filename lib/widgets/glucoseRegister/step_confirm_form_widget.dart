import 'package:flutter/material.dart';
import 'package:insulog/states/glucose_record_form_screen_state.dart';
import 'package:insulog/widgets/container_card_widget.dart';
import 'package:insulog/widgets/dotted_line_widget.dart';

class StepConfirmFormWidget extends StatelessWidget {
  final Size size;
  final GlucoseRecordFormScreenState state;
  const StepConfirmFormWidget({
    super.key,
    required this.size,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: size.height * 1,
        width: size.width,
        color: const Color(0xFFF2F2F2),
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ContainerCardWidget(
              heightFactor: 0.26,
              widthFactor: 0.9,
              size: size,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.006),
                    child: Text(
                      'Detalhes do Registro',
                      style: TextStyle(
                        fontSize: size.width * 0.06,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.05,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "PERÍODO",
                                style: TextStyle(
                                  fontSize: size.width * 0.045,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                state.periodoNome(),
                                style: TextStyle(
                                  fontSize: size.width * 0.045,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.05,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "GLICOSE",
                                style: TextStyle(
                                  fontSize: size.width * 0.045,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                '${state.nivelGlicose} mg/dL',
                                style: TextStyle(
                                  fontSize: size.width * 0.045,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.05,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "INSULINA",
                                style: TextStyle(
                                  fontSize: size.width * 0.045,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Row(
                                children: [
                                  
                                  Text(
                                    "${state.tipoInsulinaNome()} - ${state.unidadeInsulina.toString()} un",
                                    style: TextStyle(
                                      fontSize: size.width * 0.045,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.05,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "DATA/HORA",
                                style: TextStyle(
                                  fontSize: size.width * 0.045,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                "${state.horaFormatada()} - ${state.dataFormatada()}",
                                style: TextStyle(
                                  fontSize: size.width * 0.045,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.001),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ContainerCardWidget(
              size: size,
              heightFactor: 0.2,
              widthFactor: 0.9,
              isMarginTop: false,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.015,
                ),
                child: TextField(
                  controller: state.observacaoController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  onChanged: state.atualizarObservacao,
                  decoration: InputDecoration(
                    hintText: 'Observação (opcional)',
                    hintStyle: TextStyle(
                      fontSize: size.width * 0.045,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    color: const Color(0xFF171717),
                  ),
                ),
              ),
            ),
            ContainerCardWidget(
              heightFactor: 0.11,
              widthFactor: 0.9,
              size: size,
              isMarginTop: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width * 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only( 
                            left: size.width * 0.05, 
                          ),
                          child: Text(
                            'Criar Lembrete',
                            style: TextStyle(
                              height: 0,
                              fontSize: size.width * 0.06,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: size.width * 0.05, 
                          ),
                          child: Text(
                            'Um lembrete será criado neste horário',
                            style: TextStyle(
                              height: 0,
                              color: Colors.grey[700],
                              fontSize: size.width * 0.04, 
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding:  EdgeInsets.only(right: size.width * 0.05),
                    child: Switch(
                      value: state.criarLembrete,
                      activeColor: const Color(0xFF3EA75F),
                      onChanged: state.atualizarCriarLembrete,
                    ),
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

import 'package:flutter/material.dart';
import 'package:insulog/DTO/ENUMs/enum_registroInsulina.dart';
import 'package:insulog/states/glucose_record_form_screen_state.dart'; 

class InsulinaRecordFormListWidget extends StatelessWidget {
  final Size size;
  final List<RegistroInsulina> records;
  final GlucoseRecordFormScreenState state;

  const InsulinaRecordFormListWidget({
    super.key,
    required this.size,
    required this.records,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width,
            margin: EdgeInsets.only(bottom: size.height * 0.01),
            child: Text(
              'Valores recentes',
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
                  height: size.height * 0.12,
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
              : Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                      vertical: size.height * 0.005,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: size.width * 0.03,
                      mainAxisSpacing: size.height * 0.01,
                      childAspectRatio: 2.8,
                    ),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return _InsulinaRecordCard(
                        size: size,
                        record: record,
                        state: state,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class _InsulinaRecordCard extends StatefulWidget {
  final Size size;
  final RegistroInsulina record;
  final GlucoseRecordFormScreenState state;

  const _InsulinaRecordCard({
    required this.size,
    required this.record,
    required this.state,
  });

  @override
  State<_InsulinaRecordCard> createState() => _InsulinaRecordCardState();
}

class _InsulinaRecordCardState extends State<_InsulinaRecordCard> {
  bool isPressed = false;

  void setPressed(bool value) {
    setState(() {
      isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = widget.size;
    return GestureDetector(
      onTapDown: (_) => setPressed(true),
      onTapUp: (_) => setPressed(false),
      onTapCancel: () => setPressed(false),
      onTap: () => widget.state.usarRegistroInsulina(widget.record),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
        decoration: BoxDecoration(
          color: isPressed ? const Color(0xFF3EA75F) : Colors.white,
          border: Border.all(color: const Color(0xFF3EA75F)),
          borderRadius: BorderRadius.circular(widget.size.width * 0.03),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(width: 10),
                  Row(
                    children: [
                      Text(
                        '${widget.record.unidadeInsulina}',
                        style: TextStyle(
                          height: 0,
                          fontSize: widget.size.width * 0.06,
                          color: !isPressed
                              ? const Color(0xFF3EA75F)
                              : const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'U',
                        style: TextStyle(
                          height: 0,
                          fontSize: widget.size.width * 0.04,
                          color: !isPressed
                              ? const Color(0xFF3EA75F)
                              : const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    widget.record.idTipoInsulina == 1
                        ? Icons.bolt
                        : widget.record.idTipoInsulina == 2
                        ? Icons.speed
                        : Icons.schedule,
                    color: !isPressed
                        ? const Color(0xFF3EA75F)
                        : const Color.fromARGB(255, 255, 255, 255),
                    size: widget.size.width * 0.06,
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

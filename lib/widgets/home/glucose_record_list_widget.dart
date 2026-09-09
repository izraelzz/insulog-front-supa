import 'package:flutter/material.dart';
import 'package:insulog/DTO/ENUMs/enum_registroGlicose.dart';
import 'package:insulog/states/home_screen_state.dart';

class GlucoseRecordListWidget extends StatelessWidget {
  final Size size;
  final List<RegistroGlicose> records;
  final VoidCallback? onShowMore;
  final VoidCallback? onShowLess;
  final HomeScreenState state;

  const GlucoseRecordListWidget({
    super.key,
    required this.size,
    required this.records,
    required this.state,
    this.onShowMore,
    this.onShowLess,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...records.map(
          (record) => Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.022),
            child: _GlucoseRecordCard(size: size, record: record, state: state),
          ),
        ),
        if (onShowMore != null || onShowLess != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (onShowLess != null)
                GestureDetector(
                  onTap: onShowLess,
                  child: Text(
                    'Ver menos',
                    style: TextStyle(
                      color: const Color(0xFF6B6B6B),
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xFF6B6B6B),
                    ),
                  ),
                ),
              if (onShowMore != null && onShowLess != null)
                SizedBox(width: size.width * 0.06),
              if (onShowMore != null)
                GestureDetector(
                  onTap: onShowMore,
                  child: Text(
                    'Mostrar mais',
                    style: TextStyle(
                      color: const Color(0xFF3EA75F),
                      fontSize: size.width * 0.055,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xFF3EA75F),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _GlucoseRecordCard extends StatefulWidget {
  final Size size;
  final RegistroGlicose record;
  final HomeScreenState state;

  const _GlucoseRecordCard({
    required this.size,
    required this.record,
    required this.state,
  });

  @override
  State<_GlucoseRecordCard> createState() => _GlucoseRecordCardState();
}

class _GlucoseRecordCardState extends State<_GlucoseRecordCard> {
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    widget.state.addListener(handleStateChange);
  }

  void handleStateChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.state.removeListener(handleStateChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.state.isRecordSelected(widget.record);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () {
        widget.state.onLongPressRecord(widget.record, context, widget.size);
      },
      onTap: () {
        widget.state.onTapRecord(widget.record);
      },
      child: AnimatedScale(
        scale: isSelected ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.size.width * 0.045,
            vertical: widget.size.height * 0.022,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.size.width * 0.05),
            border: Border(
              bottom: BorderSide(
                color: Color(widget.record.colorStatus),
                width: 4,
              ),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 104, 104, 104),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: widget.size.width * 0.045,
                height: widget.size.width * 0.045,
                decoration: BoxDecoration(
                  color: Color(widget.record.colorStatus),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: widget.size.width * 0.02),
              SizedBox(
                width: widget.size.width * 0.17,
                child: Text(
                  widget.record.horaFormatada,
                  style: TextStyle(
                    fontSize: widget.size.width * 0.05,
                    color: const Color(0xFF4C4C4C),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${widget.record.nivelGlicose}',
                        style: TextStyle(
                          fontSize: widget.size.width * 0.07,
                          color: const Color(0xFF171717),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: ' mg/dL',
                        style: TextStyle(
                          fontSize: widget.size.width * 0.05,
                          color: const Color(0xFF4C4C4C),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: widget.size.width * 0.02),
              Text(
                widget.record.periodo,
                style: TextStyle(
                  fontSize: widget.size.width * 0.05,
                  color: const Color(0xFF7C7C7C),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

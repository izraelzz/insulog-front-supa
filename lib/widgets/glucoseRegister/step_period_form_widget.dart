import 'package:flutter/material.dart';
import 'package:insulog/states/glucose_record_form_screen_state.dart'; 
import 'package:insulog/widgets/glucoseRegister/date_time_card_glucose_widget.dart';
import 'package:insulog/widgets/glucoseRegister/period_card_widget.dart';

class StepPeriodFormWidget extends StatelessWidget {
  final GlucoseRecordFormScreenState state;
  final Size size;

  const StepPeriodFormWidget({super.key, required this.size, required this.state});

  String _formatDate(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();

    return '$day/$month/$year';
  }

  String _formatTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  Future<void> _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: state.dataDoRegistro,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selectedDate == null) {
      return;
    }

    state.atualizarDataDoRegistro(selectedDate);
  }

  Future<void> _selectTime(BuildContext context) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(state.horaDoRegistro),
    );

    if (selectedTime == null) {
      return;
    }

    final currentTime = state.horaDoRegistro;
    state.atualizarHoraDoRegistro(
      DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        selectedTime.hour,
        selectedTime.minute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      color: const Color(0xFFF2F2F2),
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: [
          PeriodCardWidget(
            size: size,
            state: state,
          ),
          Row(
            spacing: size.width * 0.05,
            children: [
              Expanded(
                child: DateTimeCard(
                  size: size,
                  icon: Icons.calendar_today,
                  value: _formatDate(state.dataDoRegistro),
                  onTap: () => _selectDate(context),
                ),
              ),
              Expanded(
                child: DateTimeCard(
                  size: size,
                  icon: Icons.access_time,
                  value: _formatTime(state.horaDoRegistro),
                  onTap: () => _selectTime(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AlarmPeriodDropdownWidget extends StatelessWidget {
  static const _periods = <_AlarmPeriodOption>[
    _AlarmPeriodOption(1, 'Jejum', Icons.wb_twilight),
    _AlarmPeriodOption(2, 'Pré-prandial', Icons.restaurant),
    _AlarmPeriodOption(3, 'Pós-prandial', Icons.local_dining),
    _AlarmPeriodOption(4, 'Noturno', Icons.nights_stay),
  ];

  final int selectedPeriod;
  final ValueChanged<int> onChanged;

  const AlarmPeriodDropdownWidget({
    super.key,
    required this.selectedPeriod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedValue = _periods.any((period) => period.id == selectedPeriod)
        ? selectedPeriod
        : null;

    return DropdownButtonFormField<int>(
      value: selectedValue,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      hint: const Text('Selecione um período'),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF2F2F2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD4D4D4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3EA75F), width: 1.5),
        ),
      ),
      items: _periods.map((period) {
        return DropdownMenuItem<int>(
          value: period.id,
          child: Row(
            children: [
              Icon(period.icon, size: 20, color: const Color(0xFF3EA75F)),
              const SizedBox(width: 12),
              Text(
                period.label,
                style: const TextStyle(
                  color: Color(0xFF171717),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      selectedItemBuilder: (context) {
        return _periods.map((period) {
          return Align(
            alignment: AlignmentGeometry.centerLeft,
            child: Row( 
              children: [
                Icon(period.icon, size: 19, color: const Color(0xFF3EA75F)),
                const SizedBox(width: 20),
                Text(
                  period.label,
                  style: const TextStyle(
                    color: Color(0xFF171717),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      onChanged: (periodId) {
        if (periodId != null) {
          onChanged(periodId);
        }
      },
    );
  }
}

class _AlarmPeriodOption {
  final int id;
  final String label;
  final IconData icon;

  const _AlarmPeriodOption(this.id, this.label, this.icon);
}

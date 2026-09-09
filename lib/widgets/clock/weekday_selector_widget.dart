import 'package:flutter/material.dart';

class WeekdaySelectorWidget extends StatelessWidget {
  static const _days = <(String, String)>[
    ('SEG', 'S'),
    ('TER', 'T'),
    ('QUA', 'Q'),
    ('QUI', 'Q'),
    ('SEX', 'S'),
    ('SAB', 'S'),
    ('DOM', 'D'),
  ];

  final List<String> selectedDays;
  final ValueChanged<List<String>> onChanged;

  const WeekdaySelectorWidget({required this.selectedDays, required this.onChanged});

  void _toggleDay(String day) {
    final updatedDays = List<String>.from(selectedDays);

    if (updatedDays.contains(day)) {
      updatedDays.remove(day);
    } else {
      updatedDays.add(day);
    }

    updatedDays.sort(
      (first, second) => _days
          .indexWhere((item) => item.$1 == first)
          .compareTo(_days.indexWhere((item) => item.$1 == second)),
    );
    onChanged(updatedDays);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _days.map((day) {
        final selected = selectedDays.contains(day.$1);

        return Expanded(
          child: Center(
            child: Semantics(
              button: true,
              selected: selected,
              label: day.$1,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () => _toggleDay(day.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF3EA75F)
                        : const Color(0xFFF2F2F2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF3EA75F)
                          : const Color(0xFFD4D4D4),
                    ),
                  ),
                  child: Text(
                    day.$2,
                    style: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF6B6B6B),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
import 'package:flutter/material.dart';

class ClockOptionTileWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ClockOptionTileWidget({
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.1,
      child: Column(
        children: [
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF171717),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            spacing: 4,
            children: [
              Icon(icon, color: const Color(0xFF3EA75F)),
              Switch(
                value: value,
                activeColor: const Color(0xFF3EA75F),
                onChanged: onChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
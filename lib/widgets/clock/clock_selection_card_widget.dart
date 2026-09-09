import 'package:flutter/material.dart';

class ClockSelectionCardWidget extends StatelessWidget {
  final String title;
  final Widget child;

  const ClockSelectionCardWidget({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF171717),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
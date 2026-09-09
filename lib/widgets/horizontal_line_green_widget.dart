import 'package:flutter/material.dart';

class HorizontalLineGreenWidget extends StatelessWidget {
  final String text;
  const HorizontalLineGreenWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        Expanded(
          child: Container(
            height: size.height * 0.005,
            margin: EdgeInsets.only(
              left: size.width * 0.05,
              right: size.width * 0.02,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3EA75F).withOpacity(0.01),
                  const Color(0xFF3EA75F).withOpacity(0.35),
                  const Color(0xFF3EA75F).withOpacity(1), 
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(size.width),
            ),
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: const Color(0xFF3EA75F),
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Container(
            height: size.height * 0.005,
            margin: EdgeInsets.only(
              left: size.width * 0.02,
              right: size.width * 0.05,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ 
                  const Color(0xFF3EA75F).withOpacity(1),
                  const Color(0xFF3EA75F).withOpacity(0.35),
                  const Color(0xFF3EA75F).withOpacity(0.01),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(size.width),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:insulog/widgets/container_card_widget.dart';

class DateTimeCard extends StatelessWidget {
  final Size size;
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  const DateTimeCard({super.key, 
    required this.size,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(size.width * 0.05),
      onTap: onTap,
      child: ContainerCardWidget(
        isMarginTop: false,
        heightFactor: 0.2,
        widthFactor: 0.9,
        size: size,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF3EA75F), size: size.width * 0.08),
            SizedBox(height: size.height * 0.015),
            Text(
              value,
              style: TextStyle(
                color: const Color(0xFF3EA75F),
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

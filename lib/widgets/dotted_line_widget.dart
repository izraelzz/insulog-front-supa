import 'package:flutter/material.dart';

class DottedLineWidget extends StatelessWidget {
  final Axis direction;
  final double length;
  final double thickness;
  final double dotSize;
  final double spacing;
  final Color color;

  const DottedLineWidget({
    super.key,
    this.direction = Axis.horizontal,
    required this.length,
    this.thickness = 1,
    this.dotSize = 3,
    this.spacing = 4,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final size = direction == Axis.horizontal
        ? Size(length, thickness)
        : Size(thickness, length);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: CustomPaint(
        painter: _DottedLinePainter(
          direction: direction,
          dotSize: dotSize,
          spacing: spacing,
          color: color,
        ),
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Axis direction;
  final double dotSize;
  final double spacing;
  final Color color;

  const _DottedLinePainter({
    required this.direction,
    required this.dotSize,
    required this.spacing,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final isHorizontal = direction == Axis.horizontal;
    final lineLength = isHorizontal ? size.width : size.height;
    final crossAxisCenter = isHorizontal ? size.height / 2 : size.width / 2;
    final radius = dotSize / 2;
    final step = dotSize + spacing;

    var currentPosition = radius;

    while (currentPosition <= lineLength - radius) {
      final offset = isHorizontal
          ? Offset(currentPosition, crossAxisCenter)
          : Offset(crossAxisCenter, currentPosition);

      canvas.drawCircle(offset, radius, paint);
      currentPosition += step;
    }
  }

  @override
  bool shouldRepaint(covariant _DottedLinePainter oldDelegate) {
    return oldDelegate.direction != direction ||
        oldDelegate.dotSize != dotSize ||
        oldDelegate.spacing != spacing ||
        oldDelegate.color != color;
  }
}

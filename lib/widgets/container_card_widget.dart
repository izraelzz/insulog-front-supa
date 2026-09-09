import 'package:flutter/material.dart';

class ContainerCardWidget extends StatelessWidget {
  final Size size;
  final Widget child;
  final double heightFactor;
  final double widthFactor;
  final bool isMarginTop;

  const ContainerCardWidget({
    super.key,
    required this.size,
    required this.child,
    required this.heightFactor,
    required this.widthFactor,
    this.isMarginTop = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * heightFactor,
      width: size.width * widthFactor,
      margin: EdgeInsets.only(
        top: isMarginTop ? size.height * 0.03 : 0,
        bottom: size.height * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.05),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(80, 0, 0, 0),
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

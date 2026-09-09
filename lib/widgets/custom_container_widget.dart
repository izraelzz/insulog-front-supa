import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class InnerShadow {
  final Color color;
  final double blurRadius;
  final Offset offset;
  final double spreadRadius;

  const InnerShadow({
    this.color = Colors.black,
    this.blurRadius = 12.0,
    this.offset = const Offset(0, 4),
    this.spreadRadius = 0.0,
  });
}

class CustomContainerWidget extends StatelessWidget {
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;
  final Widget? child;
  final InnerShadow? innerShadow;

  const CustomContainerWidget({
    super.key,
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
    this.child,
    this.innerShadow,
  }) : assert(
         color == null || decoration == null,
         'Cannot provide both a color and a decoration',
       );

  @override
  Widget build(BuildContext context) {
    final boxDecoration = decoration is BoxDecoration
        ? decoration! as BoxDecoration
        : null;
    final effectiveClipBehavior =
        clipBehavior == Clip.none && boxDecoration?.borderRadius != null
        ? Clip.antiAlias
        : clipBehavior;

    final content = Container(
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      clipBehavior: effectiveClipBehavior,
      child: child,
    );

    final decoratedContent =
        innerShadow == null
            ? content
            : CustomPaint(
              foregroundPainter: _InnerShadowPainter(
                shadow: innerShadow!,
                decoration: boxDecoration,
              ),
              child: content,
            );

    return Container(
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      child: decoratedContent,
    );
  }
}

class _InnerShadowPainter extends CustomPainter {
  final InnerShadow shadow;
  final BoxDecoration? decoration;

  const _InnerShadowPainter({
    required this.shadow,
    required this.decoration,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) {
      return;
    }

    final rect = Offset.zero & size;
    final hostPath = _shapePathForRect(rect);
    final insetRect = _deflateRect(rect, shadow.spreadRadius);
    final shiftedRect = insetRect.shift(shadow.offset);
    final shadowPath = _shapePathForRect(shiftedRect);
    final outerBounds = rect.inflate(
      shadow.blurRadius + shadow.spreadRadius.abs() + shadow.offset.distance + 1,
    );
    final differencePath = Path.combine(
      PathOperation.difference,
      Path()..addRect(outerBounds),
      shadowPath,
    );
    final blurSigma = _blurSigma(shadow.blurRadius);
    final shadowPaint = Paint()
      ..color = shadow.color
      ..maskFilter =
          blurSigma == 0 ? null : MaskFilter.blur(BlurStyle.normal, blurSigma);

    canvas.save();
    canvas.clipPath(hostPath);
    canvas.saveLayer(outerBounds, Paint());
    canvas.drawPath(differencePath, shadowPaint);
    canvas.restore();
    canvas.restore();
  }

  Path _shapePathForRect(Rect rect) {
    if (rect.isEmpty) {
      return Path();
    }

    if (decoration?.shape == BoxShape.circle) {
      return Path()..addOval(rect);
    }

    final borderRadius =
        decoration?.borderRadius?.resolve(TextDirection.ltr) ??
        BorderRadius.zero;

    return Path()..addRRect(borderRadius.toRRect(rect));
  }

  Rect _deflateRect(Rect rect, double inset) {
    if (inset == 0) {
      return rect;
    }

    final maxInset = math.max(0.0, (math.min(rect.width, rect.height) / 2) - 0.001);
    final safeInset = inset.clamp(-maxInset, maxInset);

    return Rect.fromLTWH(
      rect.left + safeInset,
      rect.top + safeInset,
      rect.width - (safeInset * 2),
      rect.height - (safeInset * 2),
    );
  }

  double _blurSigma(double radius) {
    if (radius <= 0) {
      return 0;
    }

    return radius * 0.57735 + 0.5;
  }

  @override
  bool shouldRepaint(covariant _InnerShadowPainter oldDelegate) {
    return shadow.color != oldDelegate.shadow.color ||
        shadow.blurRadius != oldDelegate.shadow.blurRadius ||
        shadow.offset != oldDelegate.shadow.offset ||
        shadow.spreadRadius != oldDelegate.shadow.spreadRadius ||
        decoration != oldDelegate.decoration;
  }
}

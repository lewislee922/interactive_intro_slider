import 'dart:math';

import 'package:flutter/material.dart';

class OvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final circlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.save();
    canvas.translate(size.width * 0.5, size.height * 0.5);
    canvas.rotate(-pi / 20);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset.zero,
            width: size.width * 1.3,
            height: size.height * 0.7),
        circlePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

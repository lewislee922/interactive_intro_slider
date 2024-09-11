import 'package:flutter/material.dart';

class CustomShapeButton extends StatelessWidget {
  final String title;
  final CustomPainter painter;
  final Color? color;

  const CustomShapeButton(
      {super.key, required this.title, required this.painter, this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: painter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          title,
          style: TextStyle(fontSize: 22, color: color ?? Colors.white),
        ),
      ),
    );
  }
}

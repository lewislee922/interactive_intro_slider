import 'package:flutter/material.dart';

import '/custom_shape_button.dart';
import '/oval_painter.dart';

class NavBar extends StatelessWidget {
  final String leading;
  final List<Widget>? actions;
  final Widget? trailing;

  const NavBar({
    super.key,
    required this.leading,
    this.actions,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leading,
            style: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          if (actions != null) Row(children: actions!),
          CustomShapeButton(title: "SHOP", painter: OvalPainter())
        ],
      ),
    );
  }
}

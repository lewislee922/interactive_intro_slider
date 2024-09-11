import 'package:flutter/material.dart';

class CarouselItem {
  final bool isFullScreen;
  final Widget child;
  final Size size;

  CarouselItem({
    required this.isFullScreen,
    required this.child,
    Size? defaultSize,
  }) : size = defaultSize ?? const Size(300, 300);
}

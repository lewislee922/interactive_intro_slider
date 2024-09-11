import 'package:flutter/material.dart';

class ImageStackPage extends StatefulWidget {
  final AnimationController? controller;
  final double? rotateAngle;

  const ImageStackPage({super.key, this.rotateAngle, this.controller});

  @override
  State<ImageStackPage> createState() => _ImageStackPageState();
}

class _ImageStackPageState extends State<ImageStackPage>
    with SingleTickerProviderStateMixin {
  late double _rotateTurns;
  late double _defaultOffsetdx;
  late AnimationController _controller;
  late Animation<double> _postiveAnimation;
  late Animation<Offset> _postiveOffsetAnimation;
  late Animation<double> _negativeAnimation;
  late Animation<Offset> _negativeOffsetAnimation;

  @override
  void initState() {
    super.initState();
    _rotateTurns = widget.rotateAngle ?? 0.03;
    _defaultOffsetdx = 0.2;
    _controller = widget.controller ??
        AnimationController(
            vsync: this, duration: const Duration(milliseconds: 500));
    _postiveAnimation =
        Tween<double>(begin: 0, end: _rotateTurns).animate(_controller);
    _postiveOffsetAnimation =
        Tween<Offset>(begin: Offset.zero, end: Offset(_defaultOffsetdx, 0.08))
            .animate(_controller);
    _negativeAnimation =
        Tween<double>(begin: 0, end: -_rotateTurns).animate(_controller);
    _negativeOffsetAnimation =
        Tween<Offset>(begin: Offset.zero, end: Offset(-_defaultOffsetdx, 0.08))
            .animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Center(
            child: SlideTransition(
          position: _negativeOffsetAnimation,
          child: RotationTransition(
            alignment: Alignment.bottomLeft,
            turns: _negativeAnimation,
            child: SizedBox(
              height: size.height * 0.5,
              width: size.width * 0.5,
              child: Image.asset('assets/images/left.jpg', fit: BoxFit.cover),
            ),
          ),
        )),
        Center(
            child: SlideTransition(
          position: _postiveOffsetAnimation,
          child: RotationTransition(
            alignment: Alignment.bottomRight,
            turns: _postiveAnimation,
            child: SizedBox(
              height: size.height * 0.5,
              width: size.width * 0.5,
              child: Image.asset('assets/images/right.jpeg', fit: BoxFit.cover),
            ),
          ),
        )),
        Center(
          child: Hero(
            tag: "main",
            child: SizedBox(
              height: size.height,
              width: size.width,
              child: Image.asset('assets/images/home.jpg', fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

enum AnimatedTextStatus { forward, reverse, stop }

class AnimatedSlideText extends StatefulWidget {
  final List<String> texts;
  final int currentIndex;
  final AnimationController controller;
  final TextStyle? style;

  const AnimatedSlideText(
      {super.key,
      required this.texts,
      required this.currentIndex,
      required this.controller,
      this.style});

  @override
  State<AnimatedSlideText> createState() => _AnimatedSlideTextState();
}

class _AnimatedSlideTextState extends State<AnimatedSlideText>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _slideUpAnimation;
  late Animation<Offset> _slideDownAnimaiton;
  late Animation<Offset> _centerAnimation;
  late TextStyle _style;

  @override
  void initState() {
    super.initState();
    _style = widget.style ??
        const TextStyle(
            fontSize: 128, fontWeight: FontWeight.bold, color: Colors.white);
    const offset = FractionalOffset(0, 1);
    _slideDownAnimaiton =
        Tween<Offset>(begin: const Offset(0, 0), end: Offset(0, -offset.dy))
            .chain(CurveTween(
                curve: const Interval(0, 0.5, curve: Curves.easeInOutCirc)))
            .animate(widget.controller);
    _slideUpAnimation =
        Tween<Offset>(begin: Offset(0, offset.dy), end: const Offset(0, 0))
            .chain(CurveTween(
                curve: const Interval(0.5, 1, curve: Curves.easeInOutCirc)))
            .animate(widget.controller);
    _centerAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
          tween: Tween<Offset>(
                  begin: Offset(0, offset.dy), end: const Offset(0, 0))
              .chain(CurveTween(curve: Curves.easeInOutCirc)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween<Offset>(
                  begin: const Offset(0, 0), end: Offset(0, -offset.dy))
              .chain(CurveTween(curve: Curves.easeInOutCirc)),
          weight: 1),
    ]).animate(widget.controller);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.currentIndex - 1 >= 0)
          Center(
              child: ClipRect(
            child: SlideTransition(
              position: _slideDownAnimaiton,
              child: Text(
                widget.texts[widget.currentIndex - 1],
                style: _style,
              ),
            ),
          )),
        Center(
            child: ClipRect(
          child: SlideTransition(
            position: _centerAnimation,
            child: Text(
              widget.texts[widget.currentIndex],
              style: _style,
            ),
          ),
        )),
        if (widget.currentIndex + 1 < widget.texts.length)
          Center(
              child: ClipRect(
            child: SlideTransition(
              position: _slideUpAnimation,
              child: Text(
                widget.texts[widget.currentIndex + 1],
                style: _style,
              ),
            ),
          ))
      ],
    );
  }
}

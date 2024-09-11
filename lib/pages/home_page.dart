import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '/ui_components/rotating_carousel_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _animate = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Hero(
              tag: "main",
              child: Image.asset('assets/images/home.jpg', fit: BoxFit.cover)),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRect(
                  child: SlideInUp(
                    child: FadeOutUp(
                      animate: _animate,
                      child: const Text(
                        "Start here",
                        style: TextStyle(
                            fontSize: 128,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                HiddenButton(
                  onPressed: () => setState(() => _animate = !_animate),
                )
              ]),
        ),
      ],
    );
  }
}

class HiddenButton extends StatefulWidget {
  final VoidCallback? onPressed;
  const HiddenButton({super.key, this.onPressed});

  @override
  State<HiddenButton> createState() => _HiddenButtonState();
}

class _HiddenButtonState extends State<HiddenButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  bool isHover = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(_controller);
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: FilledButton(
          onHover: (value) => setState(() => isHover = value),
          onPressed: _controller.status == AnimationStatus.forward ||
                  _controller.status == AnimationStatus.reverse
              ? null
              : () {
                  if (_controller.status == AnimationStatus.completed) {
                    widget.onPressed?.call();
                    _controller.reverse().then((_) async {
                      final result = await Navigator.of(context).push<bool>(
                        PageRouteBuilder(
                            opaque: false,
                            transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                            transitionDuration:
                                const Duration(milliseconds: 1200),
                            reverseTransitionDuration:
                                const Duration(milliseconds: 200),
                            pageBuilder:
                                (context, animation, reverseAnimation) =>
                                    RotatingCarouselView(
                                      children: kCrouselItems,
                                    )),
                      );
                      if (result == true) {
                        _controller.forward();
                        widget.onPressed?.call();
                      }
                    });
                  }
                  if (_controller.status == AnimationStatus.dismissed) {
                    _controller
                        .forward()
                        .then((value) => widget.onPressed?.call());
                  }
                },
          style: FilledButton.styleFrom(
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(50)),
              elevation: 0.0,
              backgroundColor: isHover ? Colors.transparent : Colors.white),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 28.0),
            child: Text(
              "I'm ready!",
              style: TextStyle(
                  color: isHover ? Colors.white : Colors.black, fontSize: 28),
            ),
          ),
        ),
      ),
    );
  }
}

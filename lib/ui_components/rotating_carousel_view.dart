import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '/pages/image_stack_page.dart';
import '/ui_components/animated_slide_text.dart';
import '/ui_components/caoursel_item.dart';

final kCrouselItems = [
  CarouselItem(
      isFullScreen: false,
      child: const ImageStackPage(),
      defaultSize: const Size(700, 800)),
  CarouselItem(
      isFullScreen: true,
      child: Image.asset(
        "assets/images/next.jpg",
        fit: BoxFit.cover,
      ))
];

class RotatingCarouselView extends StatefulWidget {
  final Duration? duration;
  final Curve? curve;
  final List<CarouselItem>? children;

  const RotatingCarouselView({
    super.key,
    this.duration,
    this.curve,
    this.children,
  });

  @override
  State<RotatingCarouselView> createState() => _RotatingCarouselViewState();
}

class _RotatingCarouselViewState extends State<RotatingCarouselView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _imageAnimationController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration:
          (widget.duration ?? const Duration(milliseconds: 1200)).multiply(2),
    )
      ..stop()
      ..value = 0.5;
    _imageAnimationController = AnimationController(
        vsync: this,
        duration: (widget.duration ?? const Duration(milliseconds: 800)));
    _imageAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _imageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Center(
            child: _buildCurrent(),
          ),
          Center(child: _buildPrevious() ?? const SizedBox()),
          Center(child: _buildNext() ?? const SizedBox()),
          Center(
            child: AnimatedSlideText(
              texts: const ["Revelations", "Explorations"],
              controller: _animationController,
              currentIndex: _currentIndex,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SlideInLeft(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: IconButton(
                    color: Colors.white,
                    iconSize: 72,
                    onPressed: () {
                      if (_currentIndex == 0) {
                        Navigator.of(context).pop<bool>(true);
                      } else {
                        _animationController
                            .reverse(from: 0.5)
                            .whenComplete(() {
                          setState(() => _currentIndex = _currentIndex - 1);
                          _animationController.stop();
                          _animationController.value = 0.5;
                          _imageAnimationController.forward();
                        });
                      }
                    },
                    icon: const Icon(Icons.arrow_back)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SlideInRight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: IconButton(
                    color: Colors.white,
                    iconSize: 72,
                    onPressed: () {
                      if (_currentIndex + 1 < (widget.children?.length ?? 0)) {
                        _animationController
                            .forward(from: 0.5)
                            .whenComplete(() {
                          setState(() => _currentIndex = _currentIndex + 1);
                          _animationController.stop();
                          _animationController.value = 0.5;
                          _imageAnimationController.reverse();
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                    )),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: SlideInLeft(
                child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: FittedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: AnimatedSlideText(
                        currentIndex: _currentIndex,
                        controller: _animationController,
                        texts: List.generate(widget.children?.length ?? 0,
                            (index) => status(index)),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 64,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    const Text(
                      "PREVIOUS/NEXT",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
            )),
          )
        ],
      ),
    );
  }

  String status(int index) {
    String indexString = '';
    String lengthString = '';
    indexString = index < 10 ? "0${index + 1}" : "${index + 1}";
    lengthString = (widget.children?.length ?? 0) < 10
        ? "0${widget.children?.length ?? 0}"
        : "${widget.children?.length ?? 0}";
    return "$indexString/$lengthString";
  }

  Widget? _buildNext() {
    if (_currentIndex + 1 <= (widget.children?.length ?? 1) - 1) {
      CarouselItem? item = widget.children?[_currentIndex + 1];
      if (item != null) {
        final scaleAni = Tween<double>(begin: 0.2, end: 1.0)
            .chain(CurveTween(
                curve: const Interval(0.5, 1, curve: Curves.easeInOutCirc)))
            .animate(_animationController);
        final slideAni =
            Tween<Offset>(begin: const Offset(3, 3), end: Offset.zero)
                .chain(CurveTween(
                    curve: const Interval(0.5, 1, curve: Curves.easeInOutCirc)))
                .animate(_animationController);
        if (item.isFullScreen) {
          return ScaleTransition(
            scale: scaleAni,
            child: SlideTransition(
              position: slideAni,
              child: SizedBox.expand(
                child: item.child is ImageStackPage
                    ? ImageStackPage(controller: _imageAnimationController)
                    : item.child,
              ),
            ),
          );
        } else {
          return SizedBox(
            height: item.size.height,
            width: item.size.width,
            child: ScaleTransition(
              scale: scaleAni,
              child: SlideTransition(
                position: slideAni,
                child: item.child is ImageStackPage
                    ? ImageStackPage(controller: _imageAnimationController)
                    : item.child,
              ),
            ),
          );
        }
      }
    }
  }

  Widget? _buildPrevious() {
    if (_currentIndex - 1 >= 0) {
      CarouselItem? item = widget.children?[_currentIndex - 1];
      if (item != null) {
        final scaleAni = Tween<double>(begin: 1.0, end: 0.3)
            .chain(CurveTween(
                curve: const Interval(0, 0.5, curve: Curves.easeInOutCirc)))
            .animate(_animationController);
        final slideAni =
            Tween<Offset>(begin: Offset.zero, end: const Offset(-14, 8))
                .chain(CurveTween(
                    curve: const Interval(0, 0.5, curve: Curves.easeInOutCirc)))
                .animate(_animationController);

        if (item.isFullScreen) {
          return SizedBox.expand(
            child: ScaleTransition(
              scale: scaleAni,
              child: SlideTransition(
                position: slideAni,
                child: item.child is ImageStackPage
                    ? ImageStackPage(controller: _imageAnimationController)
                    : item.child,
              ),
            ),
          );
        } else {
          return SizedBox(
            height: item.size.height,
            width: item.size.width,
            child: ScaleTransition(
              scale: scaleAni,
              child: SlideTransition(
                position: slideAni,
                child: item.child is ImageStackPage
                    ? ImageStackPage(controller: _imageAnimationController)
                    : item.child,
              ),
            ),
          );
        }
      }
    }
  }

  Widget _buildCurrent() {
    CarouselItem? item = widget.children?[_currentIndex];
    if (item != null) {
      final scaleAni = TweenSequence([
        TweenSequenceItem(
            tween: Tween<double>(begin: 0.3, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOutCirc)),
            weight: 1),
        TweenSequenceItem(
            tween: Tween<double>(begin: 1.0, end: 0.3)
                .chain(CurveTween(curve: Curves.easeInOutCirc)),
            weight: 1),
      ]).animate(_animationController);

      final slideAni = TweenSequence([
        TweenSequenceItem(
            tween: Tween<Offset>(begin: const Offset(14, 8), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOutCirc)),
            weight: 1),
        TweenSequenceItem(
            tween: Tween<Offset>(begin: Offset.zero, end: const Offset(-14, 8))
                .chain(CurveTween(curve: Curves.easeInOutCirc)),
            weight: 1)
      ]).animate(_animationController);

      if (item.isFullScreen) {
        return SizedBox.expand(
          child: ScaleTransition(
            scale: scaleAni,
            child: SlideTransition(
              position: slideAni,
              child: item.child is ImageStackPage
                  ? ImageStackPage(controller: _imageAnimationController)
                  : item.child,
            ),
          ),
        );
      } else {
        return SizedBox(
          height: item.size.height,
          width: item.size.width,
          child: ScaleTransition(
            scale: scaleAni,
            child: SlideTransition(
              position: slideAni,
              child: item.child is ImageStackPage
                  ? ImageStackPage(controller: _imageAnimationController)
                  : item.child,
            ),
          ),
        );
      }
    }
    return const SizedBox();
  }
}

extension MultiplyDuration on Duration {
  /// return new duration with multiplied by a int factor.
  Duration multiply(int factor) {
    return Duration(milliseconds: inMilliseconds * factor);
  }
}

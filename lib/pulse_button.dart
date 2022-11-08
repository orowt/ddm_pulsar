import 'package:flutter/material.dart';

class PulseButton extends StatefulWidget {
  final double temperature;

  const PulseButton(this.temperature, {Key? key}) : super(key: key);

  @override
  State<PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<PulseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animation = Tween(begin: 5.0, end: 80.0)
        .chain(CurveTween(curve: Curves.linear))
        .animate(_animationController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.temperature > 37.0 && _animationController.isDismissed) {
      _animationController.repeat();
    } else if (widget.temperature < 37.0) {
      _animationController.reverse();
    }

    if (widget.temperature > 33.0 &&
        _animationController.duration?.inMilliseconds == 600) {
      _animationController.stop();
      _animationController.duration = const Duration(milliseconds: 200);
      _animationController.repeat(reverse: true);
    } else if (widget.temperature > 37.0 &&
        widget.temperature < 47.0 &&
        _animationController.duration?.inMilliseconds == 200) {
      _animationController.stop();
      _animationController.duration = const Duration(milliseconds: 600);
      _animationController.repeat(reverse: true);
    }
    final color = (widget.temperature > 37.0 && widget.temperature < 70.0)
        ? Color.fromARGB(255, 230, 67, 175)
        : (widget.temperature > 71.0)
            ? Color.fromARGB(255, 250, 208, 23)
            : Colors.blue;
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: color),
                boxShadow: [
                  BoxShadow(
                      color: color,
                      blurRadius: _animation.value > 0 ? 20 : 0,
                      spreadRadius: _animation.value / 2)
                ]),
            child: Center(
              child: Text(widget.temperature.toStringAsPrecision(2),
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      ?.copyWith(color: Color.fromARGB(255, 0, 255, 242))),
            ),
          );
        });
  }
}

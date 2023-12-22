import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vector_math/vector_math.dart' show radians;

class RadialAnimation extends StatefulWidget {
  const RadialAnimation({super.key});

  @override
  State<RadialAnimation> createState() => _RadialAnimationState();
}

class _RadialAnimationState extends State<RadialAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: Duration(milliseconds: 300), vsync: this)
        ..addStatusListener((status) {
          if (status == AnimationStatus.forward) {
            ranges = List<double>.generate(ICON_COUNT,
                (_) => Random().nextDouble() * SPRAED_RANGE + START_RANGE);
            _controllers.shuffle(Random());
            angles.shuffle(Random());

            setState(() {});
          }
        });

  late final Animation<double> _scale = Tween(
    begin: SCALE_SIZE,
    end: 0.0,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ),
  );

  List<AnimationController> _controllers = [];

  bool _isCollapse = false;

  final double SCALE_SIZE = 1.3;

  final int ICON_COUNT = 8;
  final int SPRAED_RANGE = 70;
  final int START_RANGE = 100;

  var angles = [0.0, 45.0, 90.0, 135.0, 180.0, 225.0, 270.0, 315.0];

  var durations = [800, 700, 600, 500, 400, 300, 200, 100];

  var ranges = [];

  final icons = [
    {"Youtube": FontAwesomeIcons.youtube},
    {"Google": FontAwesomeIcons.google},
    {"Instagram": FontAwesomeIcons.instagram},
    {"Amazon": FontAwesomeIcons.amazon},
    {"Apple": FontAwesomeIcons.apple},
    {"Facebook": FontAwesomeIcons.facebook},
    {"Twitter": FontAwesomeIcons.twitter},
    {"Twitch": FontAwesomeIcons.twitch},
  ];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < ICON_COUNT; i++) {
      _controllers.add(AnimationController(
        duration: Duration(milliseconds: durations.elementAt(i)),
        vsync: this,
      ));
    }

    ranges = List<double>.generate(
        ICON_COUNT, (_) => Random().nextDouble() * SPRAED_RANGE + START_RANGE);
    angles.shuffle(Random());
    _controllers.shuffle(Random());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        for (int i = 0; i < angles.length; i++)
          _buildButton(
            angle: angles.elementAt(i),
            color: Colors.white,
            icon: icons.elementAt(i),
            ac: _controllers.elementAt(i),
            range: ranges.elementAt(i),
          ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scale.value - SCALE_SIZE,
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                onPressed: _close,
                child: FaIcon(FontAwesomeIcons.circleXmark),
                backgroundColor: Colors.indigo.shade50,
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scale.value,
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                onPressed: _open,
                child: FaIcon(FontAwesomeIcons.icons),
                backgroundColor: Colors.indigo.shade100,
              ),
            );
          },
        ),
      ],
    );
  }

  AnimatedBuilder _buildButton(
      {required double angle,
      required Color color,
      required Map<String, IconData> icon,
      required AnimationController ac,
      required double range}) {
    final double rad = radians(angle);

    Animation<double> translation = Tween(
      begin: SCALE_SIZE,
      end: range,
    ).animate(
      CurvedAnimation(
        parent: ac,
        curve: Curves.fastOutSlowIn,
      ),
    );

    return AnimatedBuilder(
      animation: ac,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(
                (translation.value) * cos(rad), (translation.value) * sin(rad)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  _close();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${icon.keys.first} Clicked !',
                        style: TextStyle(
                          color: Colors.deepPurple.shade800,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      duration: Duration(
                        milliseconds: 500,
                      ),
                      backgroundColor: Colors.indigo.shade100,
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: FaIcon(icon.values.first),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              if (_isCollapse)
                Text(
                  icon.keys.first,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _open() {
    _controller.forward();

    for (AnimationController c in _controllers) {
      _childOpen(c);
    }

    setState(() {
      _isCollapse = true;
    });
  }

  void _childOpen(AnimationController controller) {
    controller.forward();
  }

  void _close() {
    // setState(() {
    //   _controllers.shuffle(Random());
    // });

    _controller.reverse();

    for (AnimationController c in _controllers) {
      _childClose(c);
    }

    setState(() {
      _isCollapse = false;
    });
  }

  void _childClose(AnimationController controller) {
    controller.reverse();
  }
}

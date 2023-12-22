import 'package:flutter/material.dart';
import 'package:widgets_practice/radial/widgets/radial_menu.dart';

class RadialScreen extends StatelessWidget {
  const RadialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: RadialMenu(),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PlantoIOTTitleComponent extends StatelessWidget {
  final double size;

  const PlantoIOTTitleComponent({
    super.key,
    this.size = 58.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Plant",
            style: TextStyle(
                color: Colors.white,
                fontSize: size,
                fontFamily: 'FredokaOne',
                decoration: TextDecoration.none)),
        Icon(
          Icons.eco_rounded,
          color: Colors.white,
          size: size,
        ),
        Text(" I",
            style: TextStyle(
                color: Colors.white,
                fontSize: size,
                fontFamily: 'FredokaOne',
                decoration: TextDecoration.none)),
        Icon(
          Icons.settings,
          color: Colors.white,
          size: size,
        ),
        Text("T",
            style: TextStyle(
                color: Colors.white,
                fontSize: size,
                fontFamily: 'FredokaOne',
                decoration: TextDecoration.none)),
      ],
    );
  }
}

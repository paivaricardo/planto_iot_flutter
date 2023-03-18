import 'package:flutter/material.dart';

class PlantoIOTAppBarBackground extends StatelessWidget {
  const PlantoIOTAppBarBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFF083D07),
            Color(0xFF031802),
          ],
          radius: 4.0,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PlantoIoTBackgroundBuilder {

  PlantoIoTBackgroundBuilder();

  BoxDecoration buildPlantoIoTAppBackGround(
      {int firstRadialColor = 0xFF083D07, int secondRadialColor = 0xFF031802}) {
    return BoxDecoration(
      gradient: RadialGradient(colors: [
        Color(firstRadialColor),
        Color(secondRadialColor),
      ], center: Alignment.center, radius: 1.5)
    );
  }
}
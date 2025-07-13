import 'package:flutter/widgets.dart';

class Spaces {
  // --- Vertical Spaces ---
  static const SpaceHeight verticalTiny = SpaceHeight(4.0);
  static const SpaceHeight verticalExtraSmall = SpaceHeight(8.0);
  static const SpaceHeight verticalSmall = SpaceHeight(12.0);
  static const SpaceHeight verticalMedium = SpaceHeight(16.0);
  static const SpaceHeight verticalLarge = SpaceHeight(24.0);
  static const SpaceHeight verticalExtraLarge = SpaceHeight(32.0);
  static const SpaceHeight verticalHuge = SpaceHeight(48.0);

  // --- Horizontal Spaces ---
  static const SpaceWidth horizontalTiny = SpaceWidth(4.0);
  static const SpaceWidth horizontalExtraSmall = SpaceWidth(8.0);
  static const SpaceWidth horizontalSmall = SpaceWidth(12.0);
  static const SpaceWidth horizontalMedium = SpaceWidth(16.0);
  static const SpaceWidth horizontalLarge = SpaceWidth(24.0);
  static const SpaceWidth horizontalExtraLarge = SpaceWidth(32.0);
  static const SpaceWidth horizontalHuge = SpaceWidth(48.0);

  // Generic Space (for custom values)
  static SpaceHeight height(double value) => SpaceHeight(value);
  static SpaceWidth width(double value) => SpaceWidth(value);
}

class SpaceHeight extends StatelessWidget {
  final double height;
  const SpaceHeight(this.height, {super.key});

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

class SpaceWidth extends StatelessWidget {
  final double width;
  const SpaceWidth(this.width, {super.key});

  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}
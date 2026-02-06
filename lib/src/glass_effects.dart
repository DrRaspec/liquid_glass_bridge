import 'package:flutter/material.dart';

Color applyOpacity(Color color, double opacity) {
  final int alpha = (opacity.clamp(0.0, 1.0) * 255).round();
  return color.withAlpha(alpha);
}

class SpecularHighlight extends StatelessWidget {
  const SpecularHighlight({
    super.key,
    required this.borderRadius,
    required this.strength,
  });

  final BorderRadius borderRadius;
  final double strength;

  @override
  Widget build(BuildContext context) {
    if (strength <= 0) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: ClipRRect(
        borderRadius: borderRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                applyOpacity(
                  Colors.white,
                  (0.32 * strength).clamp(0.0, 0.65).toDouble(),
                ),
                applyOpacity(
                  Colors.white,
                  (0.10 * strength).clamp(0.0, 0.3).toDouble(),
                ),
                applyOpacity(Colors.white, 0.0),
              ],
              stops: const <double>[0.0, 0.28, 0.75],
            ),
          ),
        ),
      ),
    );
  }
}

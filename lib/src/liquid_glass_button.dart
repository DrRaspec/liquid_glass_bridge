import 'package:flutter/material.dart';

import 'enums.dart';
import 'liquid_glass_surface.dart';

class LiquidGlassButton extends StatelessWidget {
  const LiquidGlassButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.mode = LiquidGlassMode.auto,
    this.quality = LiquidGlassQuality.medium,
    this.enabled = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.margin = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.elevation = 4,
    this.tintColor = const Color(0xFFFFFFFF),
    this.tintOpacity = 0.18,
    this.blurSigma = 14,
    this.borderColor = const Color(0x99FFFFFF),
    this.borderWidth = 1,
    this.highlightStrength = 0.35,
    this.noiseOpacity = 0.04,
    this.debugLabel,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final LiquidGlassMode mode;
  final LiquidGlassQuality quality;
  final bool enabled;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final BorderRadius borderRadius;
  final double elevation;
  final Color tintColor;
  final double tintOpacity;
  final double blurSigma;
  final Color borderColor;
  final double borderWidth;
  final double highlightStrength;
  final double noiseOpacity;
  final String? debugLabel;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = enabled && onPressed != null;

    return Opacity(
      opacity: isEnabled ? 1 : 0.65,
      child: GestureDetector(
        onTap: isEnabled ? onPressed : null,
        child: LiquidGlassSurface(
          mode: mode,
          quality: quality,
          enabled: isEnabled,
          padding: padding,
          margin: margin,
          borderRadius: borderRadius,
          elevation: elevation,
          tintColor: tintColor,
          tintOpacity: tintOpacity,
          blurSigma: blurSigma,
          borderColor: borderColor,
          borderWidth: borderWidth,
          highlightStrength: highlightStrength,
          noiseOpacity: noiseOpacity,
          debugLabel: debugLabel,
          child: DefaultTextStyle.merge(
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
            child: IconTheme.merge(
              data: const IconThemeData(size: 18),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}

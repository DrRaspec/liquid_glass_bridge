import 'dart:ui';

import 'package:flutter/material.dart';

import 'enums.dart';
import 'glass_effects.dart';
import 'noise_overlay.dart';

/// Flutter-only glass renderer used on Android and non-iOS platforms.
class AndroidGlassSurface extends StatelessWidget {
  /// Creates the Flutter glass renderer.
  const AndroidGlassSurface({
    super.key,
    required this.child,
    required this.borderRadius,
    required this.padding,
    required this.margin,
    required this.elevation,
    required this.tintColor,
    required this.tintOpacity,
    required this.blurSigma,
    required this.borderColor,
    required this.borderWidth,
    required this.highlightStrength,
    required this.noiseOpacity,
    required this.quality,
    required this.enabled,
    this.debugLabel,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double elevation;
  final Color tintColor;
  final double tintOpacity;
  final double blurSigma;
  final Color borderColor;
  final double borderWidth;
  final double highlightStrength;
  final double noiseOpacity;
  final LiquidGlassQuality quality;
  final bool enabled;
  final String? debugLabel;

  @override
  Widget build(BuildContext context) {
    final double effectiveBlur =
        (enabled ? blurSigma : 0) * quality.blurMultiplier;
    final double effectiveNoise =
        (enabled ? noiseOpacity : 0) * quality.noiseMultiplier;
    final double effectiveHighlight =
        (enabled ? highlightStrength : 0) * quality.highlightMultiplier;

    final Widget core = ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          if (enabled && effectiveBlur > 0)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: effectiveBlur,
                  sigmaY: effectiveBlur,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: applyOpacity(
                tintColor,
                (enabled ? tintOpacity : tintOpacity * 0.85).toDouble(),
              ),
              borderRadius: borderRadius,
              border: Border.all(
                color: applyOpacity(
                  borderColor,
                  (enabled ? 1 : 0.75).toDouble(),
                ),
                width: borderWidth,
              ),
            ),
            child: Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                Padding(padding: padding, child: child),
                Positioned.fill(
                  child: SpecularHighlight(
                    borderRadius: borderRadius,
                    strength: effectiveHighlight,
                  ),
                ),
                if (enabled && effectiveNoise > 0)
                  Positioned.fill(
                    child: NoiseOverlay(
                      opacity: effectiveNoise.clamp(0.0, 1.0).toDouble(),
                      borderRadius: borderRadius,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    return RepaintBoundary(
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: elevation <= 0
              ? null
              : <BoxShadow>[
                  BoxShadow(
                    color: applyOpacity(Colors.black, 0.18),
                    blurRadius: elevation * 3.0,
                    spreadRadius: elevation * 0.2,
                    offset: Offset(0, elevation * 0.8),
                  ),
                ],
        ),
        child: Semantics(label: debugLabel, child: core),
      ),
    );
  }
}

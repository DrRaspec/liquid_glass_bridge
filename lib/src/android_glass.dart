import 'dart:ui';

import 'package:flutter/material.dart';

import 'enums.dart';
import 'noise_overlay.dart';

Color _applyOpacity(Color color, double opacity) {
  final int alpha = (opacity.clamp(0.0, 1.0) * 255).round();
  return color.withAlpha(alpha);
}

class AndroidGlassSurface extends StatelessWidget {
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
    final double effectiveBlur = (enabled ? blurSigma : 0) * quality.blurMultiplier;
    final double effectiveNoise = noiseOpacity * quality.noiseMultiplier;
    final double effectiveHighlight = highlightStrength * quality.highlightMultiplier;

    final Widget core = ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (enabled && effectiveBlur > 0)
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: effectiveBlur,
                sigmaY: effectiveBlur,
              ),
              child: const SizedBox.expand(),
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: _applyOpacity(
                tintColor,
                (enabled ? tintOpacity : tintOpacity * 0.85).toDouble(),
              ),
              borderRadius: borderRadius,
              border: Border.all(
                color: _applyOpacity(
                  borderColor,
                  (enabled ? 1 : 0.75).toDouble(),
                ),
                width: borderWidth,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                _SpecularHighlight(
                  borderRadius: borderRadius,
                  strength: effectiveHighlight,
                ),
                if (enabled && effectiveNoise > 0)
                  NoiseOverlay(
                    opacity: effectiveNoise.clamp(0.0, 1.0).toDouble(),
                    borderRadius: borderRadius,
                  ),
                Padding(
                  padding: padding,
                  child: child,
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
                    color: _applyOpacity(Colors.black, 0.18),
                    blurRadius: elevation * 3.0,
                    spreadRadius: elevation * 0.2,
                    offset: Offset(0, elevation * 0.8),
                  ),
                ],
        ),
        child: Semantics(
          label: debugLabel,
          child: core,
        ),
      ),
    );
  }
}

class _SpecularHighlight extends StatelessWidget {
  const _SpecularHighlight({
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
                _applyOpacity(
                  Colors.white,
                  (0.32 * strength).clamp(0.0, 0.65).toDouble(),
                ),
                _applyOpacity(
                  Colors.white,
                  (0.10 * strength).clamp(0.0, 0.3).toDouble(),
                ),
                _applyOpacity(Colors.white, 0.0),
              ],
              stops: const <double>[0.0, 0.28, 0.75],
            ),
          ),
        ),
      ),
    );
  }
}

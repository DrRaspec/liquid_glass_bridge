import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'android_glass.dart';
import 'enums.dart';
import 'glass_effects.dart';
import 'noise_overlay.dart';

/// Android-native blur renderer backed by a platform view.
class AndroidNativeGlassSurface extends StatelessWidget {
  const AndroidNativeGlassSurface({
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

  static const String _nativeViewType = 'liquid_glass_bridge/native_glass_view';

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
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android || !enabled) {
      return AndroidGlassSurface(
        borderRadius: borderRadius,
        padding: padding,
        margin: margin,
        elevation: elevation,
        tintColor: tintColor,
        tintOpacity: tintOpacity,
        blurSigma: blurSigma,
        borderColor: borderColor,
        borderWidth: borderWidth,
        highlightStrength: highlightStrength,
        noiseOpacity: noiseOpacity,
        quality: quality,
        enabled: enabled,
        debugLabel: debugLabel,
        child: child,
      );
    }

    final double effectiveBlur = blurSigma * quality.blurMultiplier;
    final double effectiveNoise = noiseOpacity * quality.noiseMultiplier;
    final double effectiveHighlight = highlightStrength * quality.highlightMultiplier;
    final double cornerRadius = borderRadius.topLeft.x;

    final String viewKey = '${effectiveBlur.toStringAsFixed(2)}_'
        '${cornerRadius.toStringAsFixed(2)}_${enabled ? 1 : 0}';

    final Widget core = ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (effectiveBlur > 0)
            IgnorePointer(
              child: AndroidView(
                key: ValueKey<String>(viewKey),
                viewType: _nativeViewType,
                creationParams: <String, dynamic>{
                  'enabled': enabled,
                  'blurSigma': effectiveBlur,
                  'borderRadius': cornerRadius,
                },
                creationParamsCodec: const StandardMessageCodec(),
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
              fit: StackFit.expand,
              children: <Widget>[
                SpecularHighlight(
                  borderRadius: borderRadius,
                  strength: effectiveHighlight,
                ),
                if (effectiveNoise > 0)
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
                    color: applyOpacity(Colors.black, 0.18),
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

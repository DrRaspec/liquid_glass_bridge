import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'android_glass.dart';
import 'enums.dart';
import 'ios_native_glass.dart';
import 'lens_shader_surface.dart';

/// Base liquid-glass container with a platform-adaptive rendering backend.
///
/// Use this widget when you want one shared API across iOS/Android/web/desktop.
/// The selected backend is controlled by [mode].
class LiquidGlassSurface extends StatelessWidget {
  /// Creates a liquid-glass surface.
  const LiquidGlassSurface({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.elevation = 8,
    this.tintColor = const Color(0xFFFFFFFF),
    this.tintOpacity = 0.2,
    this.blurSigma = 18,
    this.borderColor = const Color(0x99FFFFFF),
    this.borderWidth = 1,
    this.highlightStrength = 0.35,
    this.noiseOpacity = 0.05,
    this.mode = LiquidGlassMode.auto,
    this.quality = LiquidGlassQuality.medium,
    this.enabled = true,
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
  final LiquidGlassMode mode;
  final LiquidGlassQuality quality;
  final bool enabled;
  final String? debugLabel;

  /// Resolves the concrete renderer from [mode] and [platform].
  static LiquidGlassImplementation resolveImplementation({
    required LiquidGlassMode mode,
    required TargetPlatform platform,
  }) {
    switch (mode) {
      case LiquidGlassMode.auto:
        return platform == TargetPlatform.iOS
            ? LiquidGlassImplementation.iosNative
            : LiquidGlassImplementation.flutterGlass;
      case LiquidGlassMode.iosNative:
        return platform == TargetPlatform.iOS
            ? LiquidGlassImplementation.iosNative
            : LiquidGlassImplementation.flutterGlass;
      case LiquidGlassMode.flutterGlass:
        return LiquidGlassImplementation.flutterGlass;
      case LiquidGlassMode.flutterLens:
        return LiquidGlassImplementation.flutterLens;
    }
  }

  @override
  Widget build(BuildContext context) {
    final LiquidGlassImplementation implementation = resolveImplementation(
      mode: mode,
      platform: defaultTargetPlatform,
    );

    switch (implementation) {
      case LiquidGlassImplementation.iosNative:
        return IosNativeGlassSurface(
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
      case LiquidGlassImplementation.flutterGlass:
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
      case LiquidGlassImplementation.flutterLens:
        return LensShaderSurface(
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
  }
}

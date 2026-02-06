import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'android_glass.dart';
import 'android_native_glass.dart';
import 'enums.dart';
import 'ios_native_glass.dart';
import 'lens_shader_surface.dart';
import 'liquid_glass_theme.dart';
import 'liquid_glass_style.dart';

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
    this.iosBlurStyle,
    this.style,
    this.platformStyle,
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
  final LiquidGlassIosBlurStyle? iosBlurStyle;
  final LiquidGlassStyle? style;
  final LiquidGlassPlatformStyle? platformStyle;
  final String? debugLabel;

  /// Resolves the concrete renderer from [mode] and [platform].
  static LiquidGlassImplementation resolveImplementation({
    required LiquidGlassMode mode,
    required TargetPlatform platform,
  }) {
    switch (mode) {
      case LiquidGlassMode.auto:
        if (platform == TargetPlatform.iOS) {
          return LiquidGlassImplementation.iosNative;
        }
        if (platform == TargetPlatform.android) {
          return LiquidGlassImplementation.androidNative;
        }
        return LiquidGlassImplementation.flutterGlass;
      case LiquidGlassMode.iosNative:
        return platform == TargetPlatform.iOS
            ? LiquidGlassImplementation.iosNative
            : LiquidGlassImplementation.flutterGlass;
      case LiquidGlassMode.androidNative:
        return platform == TargetPlatform.android
            ? LiquidGlassImplementation.androidNative
            : LiquidGlassImplementation.flutterGlass;
      case LiquidGlassMode.flutterGlass:
        return LiquidGlassImplementation.flutterGlass;
      case LiquidGlassMode.flutterLens:
        return LiquidGlassImplementation.flutterLens;
    }
  }

  @override
  Widget build(BuildContext context) {
    final LiquidGlassThemeData? theme = LiquidGlassTheme.maybeOf(context);
    final LiquidGlassStyle? themeStyle = theme?.style;
    final LiquidGlassPlatformStyle? themePlatformStyle = theme?.platformStyle;
    final LiquidGlassStyle? effectiveStyle = style ?? themeStyle;
    final LiquidGlassPlatformStyle? effectivePlatformStyle =
        platformStyle ?? themePlatformStyle;
    final bool useStyle =
        effectiveStyle != null || effectivePlatformStyle != null;
    final LiquidGlassStyle resolvedStyle = useStyle
        ? resolveLiquidGlassStyle(
            fallback: LiquidGlassDefaults.surface,
            style: effectiveStyle,
            platformStyle: effectivePlatformStyle,
            platform: defaultTargetPlatform,
            isWeb: kIsWeb,
          )
        : LiquidGlassStyle(
            borderRadius: borderRadius,
            elevation: elevation,
            tintColor: tintColor,
            tintOpacity: tintOpacity,
            blurSigma: blurSigma,
            borderColor: borderColor,
            borderWidth: borderWidth,
            highlightStrength: highlightStrength,
            noiseOpacity: noiseOpacity,
            iosBlurStyle: iosBlurStyle,
          );

    final LiquidGlassMode resolvedMode =
        (theme?.mode != null && mode == LiquidGlassMode.auto)
            ? theme!.mode!
            : mode;
    final LiquidGlassQuality resolvedQuality =
        (theme?.quality != null && quality == LiquidGlassQuality.medium)
            ? theme!.quality!
            : quality;

    final LiquidGlassImplementation implementation = resolveImplementation(
      mode: resolvedMode,
      platform: defaultTargetPlatform,
    );

    switch (implementation) {
      case LiquidGlassImplementation.iosNative:
        return IosNativeGlassSurface(
          borderRadius: resolvedStyle.borderRadius,
          padding: padding,
          margin: margin,
          elevation: resolvedStyle.elevation,
          tintColor: resolvedStyle.tintColor,
          tintOpacity: resolvedStyle.tintOpacity,
          blurSigma: resolvedStyle.blurSigma,
          borderColor: resolvedStyle.borderColor,
          borderWidth: resolvedStyle.borderWidth,
          highlightStrength: resolvedStyle.highlightStrength,
          noiseOpacity: resolvedStyle.noiseOpacity,
          quality: resolvedQuality,
          enabled: enabled,
          iosBlurStyle: resolvedStyle.iosBlurStyle,
          debugLabel: debugLabel,
          child: child,
        );
      case LiquidGlassImplementation.androidNative:
        return AndroidNativeGlassSurface(
          borderRadius: resolvedStyle.borderRadius,
          padding: padding,
          margin: margin,
          elevation: resolvedStyle.elevation,
          tintColor: resolvedStyle.tintColor,
          tintOpacity: resolvedStyle.tintOpacity,
          blurSigma: resolvedStyle.blurSigma,
          borderColor: resolvedStyle.borderColor,
          borderWidth: resolvedStyle.borderWidth,
          highlightStrength: resolvedStyle.highlightStrength,
          noiseOpacity: resolvedStyle.noiseOpacity,
          quality: resolvedQuality,
          enabled: enabled,
          debugLabel: debugLabel,
          child: child,
        );
      case LiquidGlassImplementation.flutterGlass:
        return AndroidGlassSurface(
          borderRadius: resolvedStyle.borderRadius,
          padding: padding,
          margin: margin,
          elevation: resolvedStyle.elevation,
          tintColor: resolvedStyle.tintColor,
          tintOpacity: resolvedStyle.tintOpacity,
          blurSigma: resolvedStyle.blurSigma,
          borderColor: resolvedStyle.borderColor,
          borderWidth: resolvedStyle.borderWidth,
          highlightStrength: resolvedStyle.highlightStrength,
          noiseOpacity: resolvedStyle.noiseOpacity,
          quality: resolvedQuality,
          enabled: enabled,
          debugLabel: debugLabel,
          child: child,
        );
      case LiquidGlassImplementation.flutterLens:
        return LensShaderSurface(
          borderRadius: resolvedStyle.borderRadius,
          padding: padding,
          margin: margin,
          elevation: resolvedStyle.elevation,
          tintColor: resolvedStyle.tintColor,
          tintOpacity: resolvedStyle.tintOpacity,
          blurSigma: resolvedStyle.blurSigma,
          borderColor: resolvedStyle.borderColor,
          borderWidth: resolvedStyle.borderWidth,
          highlightStrength: resolvedStyle.highlightStrength,
          noiseOpacity: resolvedStyle.noiseOpacity,
          quality: resolvedQuality,
          enabled: enabled,
          debugLabel: debugLabel,
          child: child,
        );
    }
  }
}

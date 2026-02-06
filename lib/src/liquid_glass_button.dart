import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'enums.dart';
import 'liquid_glass_surface.dart';
import 'liquid_glass_theme.dart';
import 'liquid_glass_style.dart';

/// iOS-inspired glass button built on top of [LiquidGlassSurface].
class LiquidGlassButton extends StatelessWidget {
  /// Creates a liquid-glass button.
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
    this.iosBlurStyle,
    this.style,
    this.platformStyle,
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
  final LiquidGlassIosBlurStyle? iosBlurStyle;
  final LiquidGlassStyle? style;
  final LiquidGlassPlatformStyle? platformStyle;
  final String? debugLabel;

  @override
  Widget build(BuildContext context) {
    final LiquidGlassThemeData? theme = LiquidGlassTheme.maybeOf(context);
    final LiquidGlassStyle? themeStyle = theme?.style;
    final LiquidGlassPlatformStyle? themePlatformStyle = theme?.platformStyle;
    final LiquidGlassStyle? effectiveStyle = style ?? themeStyle;
    final LiquidGlassPlatformStyle? effectivePlatformStyle =
        platformStyle ?? themePlatformStyle;
    final bool isEnabled = enabled && onPressed != null;
    final bool useStyle =
        effectiveStyle != null || effectivePlatformStyle != null;
    final LiquidGlassStyle resolvedStyle = useStyle
        ? resolveLiquidGlassStyle(
            fallback: LiquidGlassDefaults.button,
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

    return Opacity(
      opacity: isEnabled ? 1 : 0.65,
      child: GestureDetector(
        onTap: isEnabled ? onPressed : null,
        child: LiquidGlassSurface(
          mode: resolvedMode,
          quality: resolvedQuality,
          enabled: isEnabled,
          padding: padding,
          margin: margin,
          borderRadius: resolvedStyle.borderRadius,
          elevation: resolvedStyle.elevation,
          tintColor: resolvedStyle.tintColor,
          tintOpacity: resolvedStyle.tintOpacity,
          blurSigma: resolvedStyle.blurSigma,
          borderColor: resolvedStyle.borderColor,
          borderWidth: resolvedStyle.borderWidth,
          highlightStrength: resolvedStyle.highlightStrength,
          noiseOpacity: resolvedStyle.noiseOpacity,
          iosBlurStyle: resolvedStyle.iosBlurStyle,
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

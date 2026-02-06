import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'enums.dart';
import 'liquid_glass_surface.dart';
import 'liquid_glass_theme.dart';
import 'liquid_glass_style.dart';

/// iOS-style top navigation bar rendered with liquid-glass styling.
class LiquidGlassNavigationBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// Creates a liquid-glass navigation bar.
  const LiquidGlassNavigationBar({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.mode = LiquidGlassMode.auto,
    this.quality = LiquidGlassQuality.medium,
    this.enabled = true,
    this.height = 64,
    this.margin = const EdgeInsets.fromLTRB(12, 12, 12, 8),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.elevation = 6,
    this.tintColor = const Color(0xFFFFFFFF),
    this.tintOpacity = 0.2,
    this.blurSigma = 16,
    this.borderColor = const Color(0x99FFFFFF),
    this.borderWidth = 1,
    this.highlightStrength = 0.35,
    this.noiseOpacity = 0.05,
    this.iosBlurStyle,
    this.style,
    this.platformStyle,
  });

  final Widget title;
  final Widget? leading;
  final Widget? trailing;
  final LiquidGlassMode mode;
  final LiquidGlassQuality quality;
  final bool enabled;
  final double height;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
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

  @override
  Size get preferredSize => Size.fromHeight(height + 24);

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
            fallback: LiquidGlassDefaults.navigationBar,
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

    return SafeArea(
      bottom: false,
      child: LiquidGlassSurface(
        mode: resolvedMode,
        quality: resolvedQuality,
        enabled: enabled,
        margin: margin,
        padding: padding,
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
        child: SizedBox(
          height: height,
          child: Row(
            children: <Widget>[
              SizedBox(width: 44, child: leading),
              Expanded(
                child: DefaultTextStyle.merge(
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                  child: title,
                ),
              ),
              SizedBox(width: 44, child: trailing),
            ],
          ),
        ),
      ),
    );
  }
}

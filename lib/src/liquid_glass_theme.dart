import 'package:flutter/material.dart';

import 'enums.dart';
import 'liquid_glass_style.dart';

@immutable
class LiquidGlassThemeData {
  const LiquidGlassThemeData({
    this.style,
    this.platformStyle,
    this.mode,
    this.quality,
  });

  final LiquidGlassStyle? style;
  final LiquidGlassPlatformStyle? platformStyle;
  final LiquidGlassMode? mode;
  final LiquidGlassQuality? quality;

  LiquidGlassThemeData copyWith({
    LiquidGlassStyle? style,
    LiquidGlassPlatformStyle? platformStyle,
    LiquidGlassMode? mode,
    LiquidGlassQuality? quality,
  }) {
    return LiquidGlassThemeData(
      style: style ?? this.style,
      platformStyle: platformStyle ?? this.platformStyle,
      mode: mode ?? this.mode,
      quality: quality ?? this.quality,
    );
  }

  LiquidGlassThemeData merge(LiquidGlassThemeData? other) {
    if (other == null) return this;
    return copyWith(
      style: other.style ?? style,
      platformStyle: other.platformStyle ?? platformStyle,
      mode: other.mode ?? mode,
      quality: other.quality ?? quality,
    );
  }

  static LiquidGlassThemeData lerp(
    LiquidGlassThemeData a,
    LiquidGlassThemeData b,
    double t,
  ) {
    return LiquidGlassThemeData(
      style: (a.style == null && b.style == null)
          ? null
          : LiquidGlassStyle.lerp(
              a.style ?? b.style!,
              b.style ?? a.style!,
              t,
            ),
      platformStyle: (a.platformStyle == null && b.platformStyle == null)
          ? null
          : LiquidGlassPlatformStyle.lerp(
              a.platformStyle ?? b.platformStyle!,
              b.platformStyle ?? a.platformStyle!,
              t,
            ),
      mode: t < 0.5 ? a.mode : b.mode,
      quality: t < 0.5 ? a.quality : b.quality,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LiquidGlassThemeData &&
        other.style == style &&
        other.platformStyle == platformStyle &&
        other.mode == mode &&
        other.quality == quality;
  }

  @override
  int get hashCode => Object.hash(style, platformStyle, mode, quality);
}

class LiquidGlassTheme extends InheritedTheme {
  const LiquidGlassTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final LiquidGlassThemeData data;

  static LiquidGlassThemeData of(BuildContext context) {
    return maybeOf(context) ?? const LiquidGlassThemeData();
  }

  static LiquidGlassThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LiquidGlassTheme>()?.data;
  }

  @override
  bool updateShouldNotify(LiquidGlassTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return LiquidGlassTheme(data: data, child: child);
  }
}

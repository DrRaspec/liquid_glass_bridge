import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// iOS blur material presets for native UIKit rendering.
enum LiquidGlassIosBlurStyle {
  systemUltraThinMaterial,
  systemThinMaterial,
  systemMaterial,
  systemThickMaterial,
  systemChromeMaterial,
}

/// Visual styling parameters for liquid glass surfaces.
@immutable
class LiquidGlassStyle {
  const LiquidGlassStyle({
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.elevation = 8,
    this.tintColor = const Color(0xFFFFFFFF),
    this.tintOpacity = 0.2,
    this.blurSigma = 18,
    this.borderColor = const Color(0x99FFFFFF),
    this.borderWidth = 1,
    this.highlightStrength = 0.35,
    this.noiseOpacity = 0.05,
    this.iosBlurStyle,
  });

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

  LiquidGlassStyle merge(LiquidGlassStyle? other) {
    if (other == null) return this;
    return copyWith(
      borderRadius: other.borderRadius,
      elevation: other.elevation,
      tintColor: other.tintColor,
      tintOpacity: other.tintOpacity,
      blurSigma: other.blurSigma,
      borderColor: other.borderColor,
      borderWidth: other.borderWidth,
      highlightStrength: other.highlightStrength,
      noiseOpacity: other.noiseOpacity,
      iosBlurStyle: other.iosBlurStyle ?? iosBlurStyle,
    );
  }

  static LiquidGlassStyle lerp(
    LiquidGlassStyle a,
    LiquidGlassStyle b,
    double t,
  ) {
    return LiquidGlassStyle(
      borderRadius:
          BorderRadius.lerp(a.borderRadius, b.borderRadius, t) ?? b.borderRadius,
      elevation: ui.lerpDouble(a.elevation, b.elevation, t) ?? b.elevation,
      tintColor: Color.lerp(a.tintColor, b.tintColor, t) ?? b.tintColor,
      tintOpacity: ui.lerpDouble(a.tintOpacity, b.tintOpacity, t) ?? b.tintOpacity,
      blurSigma: ui.lerpDouble(a.blurSigma, b.blurSigma, t) ?? b.blurSigma,
      borderColor: Color.lerp(a.borderColor, b.borderColor, t) ?? b.borderColor,
      borderWidth: ui.lerpDouble(a.borderWidth, b.borderWidth, t) ?? b.borderWidth,
      highlightStrength:
          ui.lerpDouble(a.highlightStrength, b.highlightStrength, t) ??
              b.highlightStrength,
      noiseOpacity: ui.lerpDouble(a.noiseOpacity, b.noiseOpacity, t) ?? b.noiseOpacity,
      iosBlurStyle: t < 0.5
          ? (a.iosBlurStyle ?? b.iosBlurStyle)
          : (b.iosBlurStyle ?? a.iosBlurStyle),
    );
  }

  LiquidGlassStyle copyWith({
    BorderRadius? borderRadius,
    double? elevation,
    Color? tintColor,
    double? tintOpacity,
    double? blurSigma,
    Color? borderColor,
    double? borderWidth,
    double? highlightStrength,
    double? noiseOpacity,
    LiquidGlassIosBlurStyle? iosBlurStyle,
  }) {
    return LiquidGlassStyle(
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      tintColor: tintColor ?? this.tintColor,
      tintOpacity: tintOpacity ?? this.tintOpacity,
      blurSigma: blurSigma ?? this.blurSigma,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      highlightStrength: highlightStrength ?? this.highlightStrength,
      noiseOpacity: noiseOpacity ?? this.noiseOpacity,
      iosBlurStyle: iosBlurStyle ?? this.iosBlurStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LiquidGlassStyle &&
        other.borderRadius == borderRadius &&
        other.elevation == elevation &&
        other.tintColor == tintColor &&
        other.tintOpacity == tintOpacity &&
        other.blurSigma == blurSigma &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.highlightStrength == highlightStrength &&
        other.noiseOpacity == noiseOpacity &&
        other.iosBlurStyle == iosBlurStyle;
  }

  @override
  int get hashCode => Object.hash(
        borderRadius,
        elevation,
        tintColor,
        tintOpacity,
        blurSigma,
        borderColor,
        borderWidth,
        highlightStrength,
        noiseOpacity,
        iosBlurStyle,
      );
}

/// Platform-specific overrides for liquid glass styling.
@immutable
class LiquidGlassPlatformStyle {
  const LiquidGlassPlatformStyle({
    required this.fallback,
    this.ios,
    this.android,
    this.web,
    this.macos,
    this.windows,
    this.linux,
  });

  const LiquidGlassPlatformStyle.all(LiquidGlassStyle style)
      : fallback = style,
        ios = null,
        android = null,
        web = null,
        macos = null,
        windows = null,
        linux = null;

  final LiquidGlassStyle fallback;
  final LiquidGlassStyle? ios;
  final LiquidGlassStyle? android;
  final LiquidGlassStyle? web;
  final LiquidGlassStyle? macos;
  final LiquidGlassStyle? windows;
  final LiquidGlassStyle? linux;

  LiquidGlassStyle resolve({
    required TargetPlatform platform,
    required bool isWeb,
  }) {
    if (isWeb) {
      return web ?? fallback;
    }
    switch (platform) {
      case TargetPlatform.iOS:
        return ios ?? fallback;
      case TargetPlatform.android:
        return android ?? fallback;
      case TargetPlatform.macOS:
        return macos ?? fallback;
      case TargetPlatform.windows:
        return windows ?? fallback;
      case TargetPlatform.linux:
        return linux ?? fallback;
      case TargetPlatform.fuchsia:
        return fallback;
    }
  }

  static LiquidGlassPlatformStyle lerp(
    LiquidGlassPlatformStyle a,
    LiquidGlassPlatformStyle b,
    double t,
  ) {
    LiquidGlassStyle? lerpOptional(LiquidGlassStyle? a, LiquidGlassStyle? b) {
      if (a == null && b == null) return null;
      return LiquidGlassStyle.lerp(a ?? b!, b ?? a!, t);
    }

    return LiquidGlassPlatformStyle(
      fallback: LiquidGlassStyle.lerp(a.fallback, b.fallback, t),
      ios: lerpOptional(a.ios, b.ios),
      android: lerpOptional(a.android, b.android),
      web: lerpOptional(a.web, b.web),
      macos: lerpOptional(a.macos, b.macos),
      windows: lerpOptional(a.windows, b.windows),
      linux: lerpOptional(a.linux, b.linux),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LiquidGlassPlatformStyle &&
        other.fallback == fallback &&
        other.ios == ios &&
        other.android == android &&
        other.web == web &&
        other.macos == macos &&
        other.windows == windows &&
        other.linux == linux;
  }

  @override
  int get hashCode =>
      Object.hash(fallback, ios, android, web, macos, windows, linux);
}

LiquidGlassStyle resolveLiquidGlassStyle({
  required LiquidGlassStyle fallback,
  LiquidGlassStyle? style,
  LiquidGlassPlatformStyle? platformStyle,
  required TargetPlatform platform,
  required bool isWeb,
}) {
  if (platformStyle != null) {
    return platformStyle.resolve(platform: platform, isWeb: isWeb);
  }
  return style ?? fallback;
}

/// Common presets for quick reuse.
class LiquidGlassPresets {
  const LiquidGlassPresets._();

  static const LiquidGlassStyle frosted = LiquidGlassStyle(
    tintOpacity: 0.22,
    blurSigma: 18,
    highlightStrength: 0.4,
    noiseOpacity: 0.05,
  );

  static const LiquidGlassStyle thin = LiquidGlassStyle(
    tintOpacity: 0.12,
    blurSigma: 12,
    highlightStrength: 0.25,
    noiseOpacity: 0.03,
  );

  static const LiquidGlassStyle dense = LiquidGlassStyle(
    tintOpacity: 0.28,
    blurSigma: 24,
    highlightStrength: 0.45,
    noiseOpacity: 0.06,
  );
}

/// Widget-specific defaults to keep the look consistent with current API.
class LiquidGlassDefaults {
  const LiquidGlassDefaults._();

  static const LiquidGlassStyle surface = LiquidGlassStyle(
    borderRadius: BorderRadius.all(Radius.circular(24)),
    elevation: 8,
    tintOpacity: 0.2,
    blurSigma: 18,
    highlightStrength: 0.35,
    noiseOpacity: 0.05,
  );

  static const LiquidGlassStyle button = LiquidGlassStyle(
    borderRadius: BorderRadius.all(Radius.circular(16)),
    elevation: 4,
    tintOpacity: 0.18,
    blurSigma: 14,
    highlightStrength: 0.35,
    noiseOpacity: 0.04,
  );

  static const LiquidGlassStyle navigationBar = LiquidGlassStyle(
    borderRadius: BorderRadius.all(Radius.circular(20)),
    elevation: 6,
    tintOpacity: 0.2,
    blurSigma: 16,
    highlightStrength: 0.35,
    noiseOpacity: 0.05,
  );

  static const LiquidGlassStyle bottomNavigationBar = LiquidGlassStyle(
    borderRadius: BorderRadius.all(Radius.circular(24)),
    elevation: 8,
    tintOpacity: 0.2,
    blurSigma: 18,
    highlightStrength: 0.35,
    noiseOpacity: 0.05,
  );
}

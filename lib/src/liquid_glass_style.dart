import 'dart:ui' as ui;

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
          BorderRadius.lerp(a.borderRadius, b.borderRadius, t) ??
          b.borderRadius,
      elevation: ui.lerpDouble(a.elevation, b.elevation, t) ?? b.elevation,
      tintColor: Color.lerp(a.tintColor, b.tintColor, t) ?? b.tintColor,
      tintOpacity:
          ui.lerpDouble(a.tintOpacity, b.tintOpacity, t) ?? b.tintOpacity,
      blurSigma: ui.lerpDouble(a.blurSigma, b.blurSigma, t) ?? b.blurSigma,
      borderColor: Color.lerp(a.borderColor, b.borderColor, t) ?? b.borderColor,
      borderWidth:
          ui.lerpDouble(a.borderWidth, b.borderWidth, t) ?? b.borderWidth,
      highlightStrength:
          ui.lerpDouble(a.highlightStrength, b.highlightStrength, t) ??
          b.highlightStrength,
      noiseOpacity:
          ui.lerpDouble(a.noiseOpacity, b.noiseOpacity, t) ?? b.noiseOpacity,
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

  /// iOS 26-inspired preset for rounded, bright liquid glass.
  ///
  /// This stays on public UIKit material APIs in native mode, so it remains
  /// compatible when running on newer iOS versions.
  static const LiquidGlassStyle ios26 = LiquidGlassStyle(
    borderRadius: BorderRadius.all(Radius.circular(32)),
    elevation: 8,
    tintOpacity: 0.1,
    blurSigma: 45,
    borderColor: Color(0x66FFFFFF),
    borderWidth: 1,
    highlightStrength: 0.78,
    noiseOpacity: 0.08,
    iosBlurStyle: LiquidGlassIosBlurStyle.systemUltraThinMaterial,
  );

  /// iOS 26 pill control preset for segmented controls, floating command bars,
  /// and wide capsule buttons.
  static const LiquidGlassStyle ios26Pill = LiquidGlassStyle(
    borderRadius: BorderRadius.all(Radius.circular(999)),
    elevation: 5,
    tintOpacity: 0.08,
    blurSigma: 45,
    borderColor: Color(0x66FFFFFF),
    borderWidth: 1,
    highlightStrength: 0.86,
    noiseOpacity: 0.08,
    iosBlurStyle: LiquidGlassIosBlurStyle.systemUltraThinMaterial,
  );

  /// iOS 26 selected pill segment preset matching the subtle dark selected
  /// capsule used inside glass controls.
  static const LiquidGlassStyle ios26SelectedPill = LiquidGlassStyle(
    borderRadius: BorderRadius.all(Radius.circular(999)),
    elevation: 1,
    tintColor: Color(0xFF000000),
    tintOpacity: 0.1,
    blurSigma: 8,
    borderColor: Color(0x1A000000),
    borderWidth: 0,
    highlightStrength: 0.18,
    noiseOpacity: 0.02,
    iosBlurStyle: LiquidGlassIosBlurStyle.systemThinMaterial,
  );

  /// iOS 26 circular icon control preset for round toolbar buttons.
  static const LiquidGlassStyle ios26Icon = LiquidGlassStyle(
    borderRadius: BorderRadius.all(Radius.circular(999)),
    elevation: 3,
    tintColor: Color(0xFF333333),
    tintOpacity: 0.42,
    blurSigma: 12,
    borderColor: Color(0x33FFFFFF),
    borderWidth: 1,
    highlightStrength: 0.82,
    noiseOpacity: 0.08,
    iosBlurStyle: LiquidGlassIosBlurStyle.systemUltraThinMaterial,
  );

  /// Future-leaning iOS preset for larger radii and lighter material.
  ///
  /// Use this when you want a more spacious iOS 28-style treatment while the
  /// native renderer continues to use stable UIKit APIs.
  static const LiquidGlassStyle ios28 = LiquidGlassStyle(
    borderRadius: BorderRadius.all(Radius.circular(30)),
    elevation: 12,
    tintOpacity: 0.14,
    blurSigma: 24,
    borderColor: Color(0xCCFFFFFF),
    borderWidth: 1,
    highlightStrength: 0.55,
    noiseOpacity: 0.03,
    iosBlurStyle: LiquidGlassIosBlurStyle.systemUltraThinMaterial,
  );

  /// Android-tuned preset with a slightly denser surface and Material-friendly
  /// depth.
  static const LiquidGlassStyle android = LiquidGlassStyle(
    borderRadius: BorderRadius.all(Radius.circular(20)),
    elevation: 6,
    tintOpacity: 0.24,
    blurSigma: 18,
    borderColor: Color(0x80FFFFFF),
    borderWidth: 1,
    highlightStrength: 0.34,
    noiseOpacity: 0.05,
  );

  /// Platform-adaptive style that uses iOS 26 visuals on iOS and Android-tuned
  /// visuals on Android.
  static const LiquidGlassPlatformStyle adaptive = LiquidGlassPlatformStyle(
    fallback: frosted,
    ios: ios26,
    android: android,
  );

  /// Platform-adaptive style that opts iOS into the future-leaning iOS 28
  /// treatment while keeping Android on its native-tuned preset.
  static const LiquidGlassPlatformStyle adaptiveFuture =
      LiquidGlassPlatformStyle(fallback: frosted, ios: ios28, android: android);
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

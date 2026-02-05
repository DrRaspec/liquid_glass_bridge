/// Rendering mode selector for [LiquidGlassSurface] and companion widgets.
enum LiquidGlassMode {
  /// Chooses the best implementation for the current platform.
  ///
  /// - iOS: native UIKit visual effect view
  /// - Other platforms: Flutter glass rendering
  auto,

  /// Forces iOS-native rendering on iOS, fallback to Flutter glass elsewhere.
  iosNative,

  /// Forces the Flutter glass implementation on all platforms.
  flutterGlass,

  /// Forces the shader lens implementation when available.
  ///
  /// Automatically falls back to Flutter glass if unsupported.
  flutterLens,
}

/// Quality profile used to tune blur/noise/highlight intensity.
enum LiquidGlassQuality {
  /// Lower visual cost, better for long lists and low-end devices.
  low,

  /// Balanced quality and performance.
  medium,

  /// Stronger visual effect at higher rendering cost.
  high,
}

/// Internal concrete implementation selected from [LiquidGlassMode].
enum LiquidGlassImplementation {
  iosNative,
  flutterGlass,
  flutterLens,
}

extension LiquidGlassQualityX on LiquidGlassQuality {
  double get blurMultiplier {
    switch (this) {
      case LiquidGlassQuality.low:
        return 0.65;
      case LiquidGlassQuality.medium:
        return 1.0;
      case LiquidGlassQuality.high:
        return 1.3;
    }
  }

  double get noiseMultiplier {
    switch (this) {
      case LiquidGlassQuality.low:
        return 0.7;
      case LiquidGlassQuality.medium:
        return 1.0;
      case LiquidGlassQuality.high:
        return 1.25;
    }
  }

  double get highlightMultiplier {
    switch (this) {
      case LiquidGlassQuality.low:
        return 0.85;
      case LiquidGlassQuality.medium:
        return 1.0;
      case LiquidGlassQuality.high:
        return 1.15;
    }
  }
}

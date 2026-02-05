enum LiquidGlassMode {
  auto,
  iosNative,
  flutterGlass,
  flutterLens,
}

enum LiquidGlassQuality {
  low,
  medium,
  high,
}

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

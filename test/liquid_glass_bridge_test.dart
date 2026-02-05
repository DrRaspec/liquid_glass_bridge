import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_bridge/liquid_glass_bridge.dart';
import 'package:liquid_glass_bridge/src/lens_shader_surface.dart';

void main() {
  group('mode auto platform selection', () {
    test('auto chooses iOS native on iOS', () {
      final LiquidGlassImplementation impl =
          LiquidGlassSurface.resolveImplementation(
            mode: LiquidGlassMode.auto,
            platform: TargetPlatform.iOS,
          );
      expect(impl, LiquidGlassImplementation.iosNative);
    });

    test('auto chooses flutter glass on Android', () {
      final LiquidGlassImplementation impl =
          LiquidGlassSurface.resolveImplementation(
            mode: LiquidGlassMode.auto,
            platform: TargetPlatform.android,
          );
      expect(impl, LiquidGlassImplementation.flutterGlass);
    });
  });

  group('lens fallback logic', () {
    test('falls back when shader support is missing', () {
      final bool fallback = LensShaderSurface.shouldFallbackToGlass(
        shaderSupported: false,
        shaderLoaded: false,
      );
      expect(fallback, isTrue);
    });

    test('falls back when shader fails to load', () {
      final bool fallback = LensShaderSurface.shouldFallbackToGlass(
        shaderSupported: true,
        shaderLoaded: false,
      );
      expect(fallback, isTrue);
    });

    test('does not fallback when shader is supported and loaded', () {
      final bool fallback = LensShaderSurface.shouldFallbackToGlass(
        shaderSupported: true,
        shaderLoaded: true,
      );
      expect(fallback, isFalse);
    });
  });

  test('default parameter values are stable', () {
    const LiquidGlassSurface surface = LiquidGlassSurface(
      child: SizedBox.shrink(),
    );

    expect(surface.mode, LiquidGlassMode.auto);
    expect(surface.quality, LiquidGlassQuality.medium);
    expect(surface.enabled, isTrue);
    expect(surface.blurSigma, 18);
    expect(surface.tintOpacity, 0.2);
    expect(surface.noiseOpacity, 0.05);
    expect(surface.borderWidth, 1);
    expect(surface.highlightStrength, 0.35);
  });
}

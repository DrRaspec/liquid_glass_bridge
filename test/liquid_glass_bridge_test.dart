import 'package:flutter/material.dart';
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

    test('auto chooses Android native on Android', () {
      final LiquidGlassImplementation impl =
          LiquidGlassSurface.resolveImplementation(
            mode: LiquidGlassMode.auto,
            platform: TargetPlatform.android,
          );
      expect(impl, LiquidGlassImplementation.androidNative);
    });
  });

  group('platform style presets', () {
    test('adaptive resolves iOS 26 preset on iOS', () {
      final LiquidGlassStyle style = LiquidGlassPresets.adaptive.resolve(
        platform: TargetPlatform.iOS,
        isWeb: false,
      );

      expect(style, LiquidGlassPresets.ios26);
      expect(style.iosBlurStyle, LiquidGlassIosBlurStyle.systemMaterial);
    });

    test('adaptive future resolves iOS 28 preset on iOS', () {
      final LiquidGlassStyle style = LiquidGlassPresets.adaptiveFuture.resolve(
        platform: TargetPlatform.iOS,
        isWeb: false,
      );

      expect(style, LiquidGlassPresets.ios28);
      expect(
        style.iosBlurStyle,
        LiquidGlassIosBlurStyle.systemUltraThinMaterial,
      );
    });

    test('adaptive resolves Android preset on Android', () {
      final LiquidGlassStyle style = LiquidGlassPresets.adaptive.resolve(
        platform: TargetPlatform.android,
        isWeb: false,
      );

      expect(style, LiquidGlassPresets.android);
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

  group('glass controls', () {
    testWidgets('segmented control reports selected value', (
      WidgetTester tester,
    ) async {
      String selected = 'one';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LiquidGlassSegmentedControl<String>(
              mode: LiquidGlassMode.flutterGlass,
              children: const <String, Widget>{
                'one': Text('One'),
                'two': Text('Two'),
              },
              groupValue: selected,
              onValueChanged: (String value) => selected = value,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Two'));
      expect(selected, 'two');
    });

    testWidgets('switch toggles value', (WidgetTester tester) async {
      bool value = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LiquidGlassSwitch(
              mode: LiquidGlassMode.flutterGlass,
              value: value,
              onChanged: (bool next) => value = next,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LiquidGlassSwitch));
      expect(value, isTrue);
    });

    testWidgets('slider accepts disabled state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LiquidGlassSlider(
              mode: LiquidGlassMode.flutterGlass,
              value: 0.5,
              onChanged: null,
            ),
          ),
        ),
      );

      final Slider slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.onChanged, isNull);
    });
  });
}

import 'package:flutter/foundation.dart';
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
      expect(
        style.iosBlurStyle,
        LiquidGlassIosBlurStyle.systemUltraThinMaterial,
      );
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

    test('iOS 26 component presets use capsule geometry', () {
      expect(
        LiquidGlassPresets.ios26Pill.borderRadius,
        const BorderRadius.all(Radius.circular(999)),
      );
      expect(
        LiquidGlassPresets.ios26Icon.borderRadius,
        const BorderRadius.all(Radius.circular(999)),
      );
      expect(LiquidGlassPresets.ios26Pill.blurSigma, greaterThanOrEqualTo(40));
      expect(
        LiquidGlassPresets.ios26Icon.iosBlurStyle,
        LiquidGlassIosBlurStyle.systemUltraThinMaterial,
      );
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

  testWidgets('surface shrink-wraps inside an unbounded sliver', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: LiquidGlassSurface(
                  mode: LiquidGlassMode.flutterGlass,
                  child: Text('Empty todos'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Empty todos'), findsOneWidget);
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

    testWidgets('icon button renders a circular action', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LiquidGlassIconButton(
              mode: LiquidGlassMode.flutterGlass,
              icon: Icons.arrow_upward_rounded,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
      expect(find.byType(LiquidGlassIconButton), findsOneWidget);
    });

    testWidgets('icon button accepts explicit radius and padding', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LiquidGlassIconButton(
              mode: LiquidGlassMode.flutterGlass,
              icon: Icons.arrow_upward_rounded,
              style: LiquidGlassPresets.ios26Icon,
              borderRadius: BorderRadius.circular(999),
              padding: const EdgeInsets.all(18),
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
    });

    testWidgets('button radius overrides themed style', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LiquidGlassTheme(
            data: const LiquidGlassThemeData(style: LiquidGlassPresets.ios26),
            child: Scaffold(
              body: LiquidGlassButton(
                mode: LiquidGlassMode.flutterGlass,
                borderRadius: BorderRadius.circular(999),
                onPressed: () {},
                child: const Text('Chat'),
              ),
            ),
          ),
        ),
      );

      final LiquidGlassSurface surface = tester.widget<LiquidGlassSurface>(
        find.byType(LiquidGlassSurface),
      );
      expect(surface.borderRadius, BorderRadius.circular(999));
    });

    testWidgets('button background is tappable outside child bounds', (
      WidgetTester tester,
    ) async {
      int taps = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: LiquidGlassButton(
                mode: LiquidGlassMode.flutterGlass,
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 24,
                ),
                onPressed: () => taps += 1,
                child: const Text('Tap'),
              ),
            ),
          ),
        ),
      );

      final Rect buttonRect = tester.getRect(find.byType(LiquidGlassButton));
      await tester.tapAt(buttonRect.centerLeft + const Offset(18, 0));

      expect(taps, 1);
    });
  });

  testWidgets('iOS native mode falls back when plugin is unregistered', (
    WidgetTester tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LiquidGlassSurface(
              mode: LiquidGlassMode.iosNative,
              child: Text('Fallback glass'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Fallback glass'), findsOneWidget);
      expect(tester.takeException(), isNull);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}
